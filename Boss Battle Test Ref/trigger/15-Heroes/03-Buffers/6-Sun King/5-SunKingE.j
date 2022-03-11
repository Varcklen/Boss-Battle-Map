scope SunKingE initializer init

    globals 
        private constant integer ID_ABILITY = 'A0GQ'
    
        private constant integer BONUS_FIRST_LEVEL = 4
        private constant integer BONUS_LEVEL_BONUS = 4
        
        private constant integer COUNT_FIRST_LEVEL = 1900
        private constant integer COUNT_LEVEL_BONUS = -100
        
        private constant integer MOON_DURATION = 6
        
        private constant string ANIMATION = "Abilities\\Spells\\NightElf\\Starfall\\StarfallCaster.mdl"
    endglobals

    private function SunKingMoonBonus takes unit hero returns real
        local real bonus = 0.01 * ( BONUS_FIRST_LEVEL + ( BONUS_LEVEL_BONUS * GetUnitAbilityLevel( hero, ID_ABILITY) ) )
        
        if Moon_Counter > 0 then
            set bonus = bonus * 2
        endif
        
        set hero = null
        return bonus
    endfunction

    function Trig_SunKingE_Conditions takes nothing returns boolean
        return GetLearnedSkill() == ID_ABILITY
    endfunction

    function Trig_SunKingE_Actions takes nothing returns nothing
        local unit hero = GetLearningUnit()
        local integer lvl = GetUnitAbilityLevel(hero, GetLearnedSkill())
        
        call SaveReal(udg_hash, GetHandleId(hero), StringHash( "snke" ), COUNT_FIRST_LEVEL + (COUNT_LEVEL_BONUS*lvl) )
        if lvl == 1 then
            call spdst( hero, BONUS_FIRST_LEVEL )
        endif
        call spdst( hero, BONUS_LEVEL_BONUS )
        
        if Moon_Counter > 0 then
            if lvl == 1 then
                call spdst( hero, BONUS_FIRST_LEVEL )
            endif
            call spdst( hero, BONUS_LEVEL_BONUS )
        endif
        
        set hero = null
    endfunction
    
    private function NullingAbility_Conditions takes nothing returns boolean
        return GetUnitAbilityLevel( udg_Event_NullingAbility_Unit, ID_ABILITY) > 0
    endfunction

    private function NullingAbility takes nothing returns nothing
        local unit hero = udg_Event_NullingAbility_Unit
        local integer lvl = GetUnitAbilityLevel( hero, ID_ABILITY)
        local integer bonus = BONUS_FIRST_LEVEL+(BONUS_LEVEL_BONUS*lvl)
        
        call spdst( hero, -bonus )
        if Moon_Counter > 0 then
            call spdst( hero, -bonus )
        endif

        set hero = null
    endfunction
    
    private function MoonChange_Conditions takes nothing returns boolean
        return GetUnitAbilityLevel( Event_MoonChange_Unit, ID_ABILITY) > 0
    endfunction
    
    private function MoonChange takes nothing returns nothing
        local unit hero = Event_MoonChange_Unit
        local integer lvl = GetUnitAbilityLevel( hero, ID_ABILITY)
        local integer bonus = BONUS_FIRST_LEVEL+(BONUS_LEVEL_BONUS*lvl)
        
        if Event_MoonChange_isNight then
            call spdst( hero, bonus )
        else
            call spdst( hero, -bonus )
        endif

        set hero = null
    endfunction
    
    private function MoonEnd takes nothing returns nothing
        call moonst( -1 )
    endfunction
    
    private function UseMoon takes unit caster returns nothing
        call moonst( 1 )
        call spectime( ANIMATION, GetUnitX(caster), GetUnitY(caster), MOON_DURATION )
        call TimerStart( CreateTimer(), MOON_DURATION, false, function MoonEnd )
    
        set caster = null
    endfunction
    
    private function CountUsed takes unit caster, real addCount returns nothing
        local integer casterId = GetHandleId(caster)
        local real count = LoadReal(udg_hash, casterId, StringHash( "snke" ) )
        local real countCurrent = LoadReal(udg_hash, casterId, StringHash( "snkec" ) )
        
        set countCurrent = countCurrent + addCount
        if countCurrent >= count then
            set countCurrent = countCurrent - count
            call UseMoon(caster)
        endif
        call SaveReal(udg_hash, casterId, StringHash( "snkec" ), countCurrent )
    
        set caster = null
    endfunction
    
    
    private function OnHealChange_Conditions takes nothing returns boolean
        return GetUnitAbilityLevel( Event_OnHealChange_Caster, ID_ABILITY) > 0
    endfunction
    
    private function OnHealChange takes nothing returns nothing
        set Event_OnHealChange_Heal = Event_OnHealChange_Heal + ( Event_OnHealChange_StaticHeal * SunKingMoonBonus(Event_OnHealChange_Caster))
    endfunction
    
    private function OnDamageChange_Conditions takes nothing returns boolean
        return GetUnitAbilityLevel( udg_DamageEventSource, ID_ABILITY) > 0
    endfunction
    
    private function OnDamageChange takes nothing returns nothing
        set udg_DamageEventAmount = udg_DamageEventAmount + ( Event_OnDamageChange_StaticDamage * SunKingMoonBonus(udg_DamageEventSource))
    endfunction
    
    
    private function AfterHeal_Conditions takes nothing returns boolean
        return IsUnitHasAbility( Event_AfterHeal_Caster, ID_ABILITY) and combat(Event_AfterHeal_Caster, false, 0) and Event_AfterHeal_Heal > 0
    endfunction
    
    private function AfterHeal takes nothing returns nothing
        call CountUsed( Event_AfterHeal_Caster, Event_AfterHeal_Heal )
    endfunction
    
    private function AfterDamageEvent_Conditions takes nothing returns boolean
        return IsUnitHasAbility( udg_DamageEventSource, ID_ABILITY) and combat(udg_DamageEventSource, false, 0) and udg_DamageEventAmount > 0
    endfunction
    
    private function AfterDamageEvent takes nothing returns nothing
        call CountUsed( udg_DamageEventSource, udg_DamageEventAmount )
    endfunction

    //===========================================================================
    private function init takes nothing returns nothing
        set gg_trg_SunKingE = CreateTrigger()
        call TriggerRegisterAnyUnitEventBJ( gg_trg_SunKingE, EVENT_PLAYER_HERO_SKILL )
        call TriggerAddCondition( gg_trg_SunKingE, Condition( function Trig_SunKingE_Conditions ) )
        call TriggerAddAction( gg_trg_SunKingE, function Trig_SunKingE_Actions )
        
        call CreateEventTrigger( "Event_MoonChange_Real", function MoonChange, function MoonChange_Conditions )
        call CreateEventTrigger( "udg_Event_NullingAbility_Real", function NullingAbility, function NullingAbility_Conditions )
        
        call CreateEventTrigger( "Event_OnDamageChange_Real", function OnDamageChange, function OnDamageChange_Conditions )
        call CreateEventTrigger( "Event_OnHealChange_Real", function OnHealChange, function OnHealChange_Conditions )
        
        call CreateEventTrigger( "udg_AfterDamageEvent", function AfterDamageEvent, function AfterDamageEvent_Conditions )
        call CreateEventTrigger( "Event_AfterHeal_Real", function AfterHeal, function AfterHeal_Conditions )
    endfunction

endscope
