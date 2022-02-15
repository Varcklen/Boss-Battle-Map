scope KnightR initializer init

    globals
        private constant integer ID_ABILITY = 'A131'
        private constant integer ID_ABILITY_MINION = 'A134'
        
        private constant integer DURATION = 6
        private constant real VAMPIRISM_FIRST_LEVEL = 0.05
        private constant real VAMPIRISM_LEVEL_BONUS = 0.05
        
        private constant integer EFFECT = 'A16S'
        private constant integer BUFF = 'B07D'
        
        private constant string ANIMATION = "Abilities\\Spells\\Undead\\VampiricAura\\VampiricAuraTarget.mdl"
        
        private boolean Loop = false
    endglobals

    //Apply debuff
    private function AfterDamageEvent_Conditions takes nothing returns boolean
        return IsUnitHasAbility( udg_DamageEventSource, ID_ABILITY) or IsUnitHasAbility( udg_DamageEventSource, ID_ABILITY_MINION)
    endfunction

    private function AfterDamageEvent takes nothing returns nothing
        local real duration = timebonus(udg_DamageEventSource, DURATION)
        local real healBonus = 0
        local integer level = 0
    
        call bufst( udg_DamageEventSource, udg_DamageEventTarget, EFFECT, BUFF, "kngrd", duration )
        if IsUnitHasAbility( udg_DamageEventSource, ID_ABILITY_MINION) then
            set level = LoadInteger( udg_hash, GetHandleId( udg_DamageEventSource ), StringHash( "knger" ) )
        else
            set level = GetUnitAbilityLevel(udg_DamageEventSource, ID_ABILITY)
        endif
        
        set healBonus = VAMPIRISM_FIRST_LEVEL + ( VAMPIRISM_LEVEL_BONUS * level )
        call SaveReal( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "kngr" ), healBonus )
        call debuffst( udg_DamageEventSource, udg_DamageEventTarget, null, 1, duration )
    endfunction
    
    //Heal
    private function AfterDamageEventAttack_Conditions takes nothing returns boolean
        return IsUnitHasAbility( udg_DamageEventTarget, EFFECT) and Loop == false
    endfunction

    private function AfterDamageEventAttack takes nothing returns nothing
        local real heal = udg_DamageEventAmount * LoadReal( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "kngr" ) )
    
        set Loop = true
        call healst( udg_DamageEventSource, null, heal )
        call PlaySpecialEffect(ANIMATION, udg_DamageEventSource)
        set Loop = false
    endfunction

    //===========================================================================
    private function init takes nothing returns nothing
        call CreateEventTrigger( "udg_AfterDamageEvent", function AfterDamageEvent, function AfterDamageEvent_Conditions )
        call CreateEventTrigger( "udg_AfterDamageEvent", function AfterDamageEventAttack, function AfterDamageEventAttack_Conditions )
    endfunction

endscope