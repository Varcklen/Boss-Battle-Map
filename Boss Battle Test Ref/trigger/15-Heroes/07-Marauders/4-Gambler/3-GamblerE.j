scope GamblerE initializer init

    globals
        private constant integer ID_ABILITY = 'A10M'
        private constant integer ID_ABILITY_ALT = 'A11T'
        
        private constant integer CHANCE = 30
        
        private constant integer MANA_FIRST_LEVEL = 15
        private constant integer MANA_LEVEL_BONUS = 4
        
        private constant integer HEALTH_FIRST_LEVEL = 13
        private constant integer HEALTH_LEVEL_BONUS = 13
        
        private constant integer GOLD_FIRST_LEVEL = 0
        private constant integer GOLD_LEVEL_BONUS = 7
        
        private constant integer STUN_FIRST_LEVEL = 0
        private constant real STUN_LEVEL_BONUS = 0.25
        
        private constant integer EFFECT = 'A11H'
        private constant integer BUFF = 'B06R'
        private constant integer DURATION = 10
        
        private constant string ANIMATION = "Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageDeathCaster.mdl"
    endglobals

    private function DamageModifierEvent_Conditions takes nothing returns boolean
        if udg_IsDamageSpell then
            return false
        elseif IsUnitHasAbility(udg_DamageEventSource, ID_ABILITY) == false and IsUnitHasAbility( udg_DamageEventSource, ID_ABILITY_ALT ) == false then
            return false
        elseif IsUnitAlly(udg_DamageEventSource, GetOwningPlayer(udg_DamageEventTarget)) then
            return false
        elseif LuckChance( udg_DamageEventSource, CHANCE ) == false then
            return false
        endif
        return true
    endfunction

    private function DamageModifierEvent takes nothing returns nothing
        local unit caster = udg_DamageEventSource
        local unit target = udg_DamageEventTarget
        local integer lvl
        local integer rand = GetRandomInt( 1, 5 )
        local integer id
        local integer p

        if IsUnitHasAbility( caster, ID_ABILITY_ALT ) then
            set lvl = LoadInteger( udg_hash, GetHandleId( caster ), StringHash( "gmbwe" ) )
        else
            set lvl = GetUnitAbilityLevel(caster, ID_ABILITY)
        endif
        
        call PlaySpecialEffect(ANIMATION, caster)
        if rand == 1 then
            set p = MANA_FIRST_LEVEL+(MANA_LEVEL_BONUS*lvl)
            call manast( caster, null, p )
            call textst( "|c002020FF +" + I2S(p) + " mana", caster, 64, 90, 10, 1 )
        elseif rand == 2 then
            set p = HEALTH_FIRST_LEVEL+(HEALTH_LEVEL_BONUS*lvl)
            call healst( caster, null, p )
            call textst( "|c0020FF20 +" + I2S(p) + " health" , caster, 64, 90, 10, 1 )
        elseif rand == 3 and combat( caster, false, 0 ) and not( udg_fightmod[3] ) then
            set p = GOLD_FIRST_LEVEL+(GOLD_LEVEL_BONUS*lvl)
            call moneyst( caster, p )
            call textst( "|cFFFFFC01 +" + I2S(p) + " gold" , caster, 64, 90, 10, 1 )
        elseif rand == 4 then
            call UnitStun(caster, target, STUN_FIRST_LEVEL+(STUN_LEVEL_BONUS*lvl) )
            call textst( "|cFF7EBFF1stun" , caster, 64, 90, 10, 1 )
        elseif rand == 5 then
            call bufst(caster, target, EFFECT, BUFF, "gmbe", DURATION )
            call debuffst( caster, target, null, 1, DURATION )
            call textst( "armor" , caster, 64, 90, 10, 1 )
        endif
        
        set caster = null
        set target = null
    endfunction

    //===========================================================================
    private function init takes nothing returns nothing
        call CreateEventTrigger( "udg_DamageModifierEvent", function DamageModifierEvent, function DamageModifierEvent_Conditions )
    endfunction
    
endscope