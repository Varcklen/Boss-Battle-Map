scope War04 initializer init

    globals
        private constant integer HEALTH_CHECK = 50
        private constant integer SUMMONED_MINION = 'n03U'
        private constant integer SUMMON_DEVIATION = 400
        
        private constant string ANIMATION = "Abilities\\Spells\\NightElf\\BattleRoar\\RoarCaster.mdl"
    endglobals

    function Trig_War4_Conditions takes nothing returns boolean
        return GetUnitTypeId( udg_DamageEventTarget ) == War01_ID_BOSS and GetUnitLifePercent(udg_DamageEventTarget) <= HEALTH_CHECK
    endfunction

    function Trig_War4_Actions takes nothing returns nothing
        call DisableTrigger( GetTriggeringTrigger() )
        set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( udg_DamageEventTarget ), SUMMONED_MINION, Math_GetUnitRandomX(udg_DamageEventTarget, SUMMON_DEVIATION), Math_GetUnitRandomY(udg_DamageEventTarget, SUMMON_DEVIATION), GetRandomReal( 0, 360 ) )
        call PlaySpecialEffect(ANIMATION, bj_lastCreatedUnit)
    endfunction

    //===========================================================================
    private function init takes nothing returns nothing
        set gg_trg_War4 = CreateEventTrigger( "udg_AfterDamageEvent", function Trig_War4_Actions, function Trig_War4_Conditions )
        call DisableTrigger( gg_trg_War4 )
    endfunction

endscope