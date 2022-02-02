scope LycanthropeE initializer init

    globals
        public boolean WolfMode = false
    
        private constant integer ID_ABILITY = 'A1CR'
        
        private constant integer AGILITY_BONUS_FIRST_LEVEL = 2
        private constant integer AGILITY_BONUS_LEVEL_BONUS = 1
        
        private constant integer COOLDOWN_FIRST_LEVEL = 22
        private constant integer COOLDOWN_LEVEL_BONUS = -2
        
        private constant integer AGILITY_BONUS_PER_ATTACK = 1
        private constant integer CHANCE_FIRST_LEVEL = 10
        private constant integer CHANCE_LEVEL_BONUS = 15
        
        private constant integer ALT_AGILITY_BONUS_PER_ATTACK = 1
        
        private constant string ANIMATION = "Abilities\\Spells\\Items\\AIam\\AIamTarget.mdl"
        
        private unit GetUnit = null
    endglobals
    
    private function GetMostHealthiestEnemyNearby takes unit caster returns unit
        local group g = CreateGroup()
        local unit u
        local real maxHealth = 0
        set GetUnit = null
    
        call GroupEnumUnitsInRange( g, GetUnitX( caster ), GetUnitY( caster ), 400, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if unitst( u, caster, "enemy" ) and GetUnitState( u, UNIT_STATE_LIFE ) > maxHealth then
                set GetUnit = u
                set maxHealth = GetUnitState( u, UNIT_STATE_LIFE )
            endif
            call GroupRemoveUnit(g,u)
        endloop
    
        call GroupClear( g )
        call DestroyGroup( g )
        set u = null
        set g = null
        return GetUnit
    endfunction

    private function LycanthropeE_Cast takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer( ) )
        local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "lcne" ) )
        local integer level = LoadInteger(udg_hash, id, StringHash( "lcne" ) )
        
        if IsUnitHasAbility(caster, ID_ABILITY) then
            if IsNight() == false and IsUnitAlive(caster) and IsUnitLoaded( caster ) == false and Aspects_IsHeroAspectActive(caster, ASPECT_03) == false then
                if GetRandomInt(0,1) == 0 then
                    set udg_Caster = caster
                    set udg_Target = null
                    set udg_Level = level
                    set udg_CastLogic = true
                    set udg_Time = LycanthropeQ_DURATION
                    set WolfMode = true
                    call TriggerExecute( gg_trg_LycanthropeQ )
                    set WolfMode = false
                else
                    set udg_Target = GetMostHealthiestEnemyNearby(caster)
                    if udg_Target != null then
                        set udg_Caster = caster
                        set udg_Level = level
                        set udg_CastLogic = true
                        set udg_Time = 15
                        set WolfMode = true
                        call TriggerExecute( gg_trg_LycanthropeR )
                        set WolfMode = false
                    endif
                endif
            endif
        else
            call FlushChildHashtable( udg_hash, id )
            call DestroyTimer( GetExpiredTimer() )
        endif
        
        set caster = null
    endfunction

    function Trig_LycanthropeE_Conditions takes nothing returns boolean
        return GetLearnedSkill() == ID_ABILITY
    endfunction

    function Trig_LycanthropeE_Actions takes nothing returns nothing
        local unit hero = GetLearningUnit()
        local integer level = GetUnitAbilityLevel( hero, ID_ABILITY)
        local integer cooldown = COOLDOWN_FIRST_LEVEL + (level*COOLDOWN_LEVEL_BONUS)
        local integer id
        
        set id = InvokeTimerWithUnit(hero, "lcne", cooldown, true, function LycanthropeE_Cast )
        call SaveInteger(udg_hash, id, StringHash( "lcne" ), level )
        
        set hero = null
    endfunction
    
    
    private function EndOfLostBattle_Conditions takes nothing returns boolean
        return IsUnitHasAbility(Event_EndOfLostBattle_Hero, ID_ABILITY) and udg_fightmod[3] == false and Aspects_IsHeroAspectActive(Event_EndOfLostBattle_Hero, ASPECT_03) == false
    endfunction
    
    private function EndOfLostBattle takes nothing returns nothing
        local unit hero = Event_EndOfLostBattle_Hero
        local integer level = GetUnitAbilityLevel( hero, ID_ABILITY)
        local integer addedAgility = AGILITY_BONUS_FIRST_LEVEL + (level * AGILITY_BONUS_LEVEL_BONUS)
        
        call textst( "|cFF57E5C6 +" + I2S(addedAgility) + " agility", hero, 64, 90, 12, 3 )
        call PlaySpecialEffect(ANIMATION, hero)
        call statst(hero, 0, addedAgility, 0, 0, true)
        
        set hero = null
    endfunction
    
    private function AfterDamageEvent_Conditions takes nothing returns boolean
        if udg_DamageEventAmount <= 0 then
            return false
        elseif IsUnitHasAbility(udg_DamageEventSource, ID_ABILITY) == false then
            return false
        elseif IsNight() == false then
            return false
        elseif udg_IsDamageSpell == true then
            return false
        elseif LuckChance(udg_DamageEventSource, CHANCE_FIRST_LEVEL + ( GetUnitAbilityLevel( udg_DamageEventSource, ID_ABILITY ) * CHANCE_LEVEL_BONUS ) ) == false then
            return false
        endif
    
        return true
    endfunction
    
    private function AfterDamageEvent takes nothing returns nothing
        local unit hero = udg_DamageEventSource
        local integer bonusAgility = LoadInteger(udg_hash, GetHandleId(hero), StringHash( "lcnea" ) ) + AGILITY_BONUS_PER_ATTACK
        local integer agilityBonus = AGILITY_BONUS_PER_ATTACK
        
        if Aspects_IsHeroAspectActive(hero, ASPECT_03) then
            set agilityBonus = agilityBonus + ALT_AGILITY_BONUS_PER_ATTACK
        endif
        
        call statst(hero, 0, agilityBonus, 0, 0, false )
        call SaveInteger(udg_hash, GetHandleId(hero), StringHash( "lcnea" ), bonusAgility )
        
        set hero = null
    endfunction
    
    private function MoonChange_Conditions takes nothing returns boolean
        return LoadInteger(udg_hash, GetHandleId(Event_MoonChange_Unit), StringHash( "lcnea" ) ) > 0 and Event_MoonChange_isNight == false
    endfunction
    
    private function MoonChange takes nothing returns nothing
        local unit hero = Event_MoonChange_Unit
        local integer bonusAgility = LoadInteger(udg_hash, GetHandleId(hero), StringHash( "lcnea" ) )
        
        call statst(hero, 0, -bonusAgility, 0, 0, false )
        call RemoveSavedInteger( udg_hash, GetHandleId( hero ), StringHash( "lcnea" ) )
        
        set hero = null
    endfunction
    
    //===========================================================================
    private function init takes nothing returns nothing
        set gg_trg_LycanthropeE = CreateTrigger(  )
        call TriggerRegisterAnyUnitEventBJ( gg_trg_LycanthropeE, EVENT_PLAYER_HERO_SKILL )
        call TriggerAddCondition( gg_trg_LycanthropeE, Condition( function Trig_LycanthropeE_Conditions ) )
        call TriggerAddAction( gg_trg_LycanthropeE, function Trig_LycanthropeE_Actions )
    
        call CreateEventTrigger( "Event_MoonChange_Real", function MoonChange, function MoonChange_Conditions )
        call CreateEventTrigger( "udg_AfterDamageEvent", function AfterDamageEvent, function AfterDamageEvent_Conditions )
        call CreateEventTrigger( "Event_EndOfLostBattle_Real", function EndOfLostBattle, function EndOfLostBattle_Conditions )
    endfunction

endscope