scope Totem3 initializer init

    globals
        private constant integer HEALTH_CHECK = 50
        private constant integer EXPLODE_COOLDOWN = 3
    endglobals

    private function Trig_Totem3_Conditions takes nothing returns boolean
        return GetUnitTypeId( udg_DamageEventTarget ) == Totem1_ID_BOSS and GetUnitLifePercent( udg_DamageEventTarget ) <= HEALTH_CHECK
    endfunction

    private function Trig_Totem3_Actions takes nothing returns nothing
        call DisableTrigger( GetTriggeringTrigger() )
        call InvokeTimerWithUnit(udg_DamageEventTarget, "bstm1", bosscast(EXPLODE_COOLDOWN), true, function Totem1_TotemCast )
    endfunction

    //===========================================================================
    private function init takes nothing returns nothing
        set gg_trg_Totem3 = CreateEventTrigger( "udg_AfterDamageEvent", function Trig_Totem3_Actions, function Trig_Totem3_Conditions )
        call DisableTrigger( gg_trg_Totem3 )
    endfunction

endscope