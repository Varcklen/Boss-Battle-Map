scope War02 initializer init

    globals
        private constant integer HEALTH_CHECK = 90
        private constant integer SUMMONED_MINION = 'n03T'
        private constant integer SUMMON_DEVIATION = 400
        
        private constant string ANIMATION = "Abilities\\Spells\\NightElf\\BattleRoar\\RoarCaster.mdl"
    endglobals

    function Trig_War2_Conditions takes nothing returns boolean
        return GetUnitTypeId( udg_DamageEventTarget ) == War01_ID_BOSS and GetUnitLifePercent(udg_DamageEventTarget) <= HEALTH_CHECK
    endfunction

    function Trig_War2_Actions takes nothing returns nothing
        local integer i = 1

        call DisableTrigger( GetTriggeringTrigger() )
        loop
            exitwhen i > PLAYERS_LIMIT
            if IsUnitAlive(udg_hero[i]) then
                set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( udg_DamageEventTarget ), SUMMONED_MINION, Math_GetUnitRandomX(udg_DamageEventTarget, SUMMON_DEVIATION), Math_GetUnitRandomY(udg_DamageEventTarget, SUMMON_DEVIATION), GetRandomReal( 0, 360 ) )
                call PlaySpecialEffect(ANIMATION, bj_lastCreatedUnit)
            endif
            set i = i + 1
        endloop
    endfunction

    //===========================================================================
    private function init takes nothing returns nothing
        set gg_trg_War2 = CreateEventTrigger( "udg_AfterDamageEvent", function Trig_War2_Actions, function Trig_War2_Conditions )
        call DisableTrigger( gg_trg_War2 )
    endfunction

endscope