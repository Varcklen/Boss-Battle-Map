scope Totem4 initializer init

    globals
        private constant integer HEALTH_CHECK = 25
    endglobals

    function Trig_Totem4_Conditions takes nothing returns boolean
        return GetUnitTypeId( udg_DamageEventTarget ) == Totem1_ID_BOSS and GetUnitLifePercent( udg_DamageEventTarget ) <= HEALTH_CHECK
    endfunction

    function Trig_Totem4_Actions takes nothing returns nothing
        call DisableTrigger( GetTriggeringTrigger() )
        call Totem2_SpawnShadows(udg_DamageEventTarget)
    endfunction

    //===========================================================================
    private function init takes nothing returns nothing
        set gg_trg_Totem4 = CreateEventTrigger( "udg_AfterDamageEvent", function Trig_Totem4_Actions, function Trig_Totem4_Conditions )
        call DisableTrigger( gg_trg_Totem4 )
    endfunction

endscope