scope Paladin03

    globals
        private constant integer PALADIN_HEALTH_CHECK = 25
        private constant real PALADIN_WAVE_CREATION_COOLDOWN = 0.25
    endglobals

    function Trig_Paladin3_Conditions takes nothing returns boolean
        return GetUnitTypeId( udg_DamageEventTarget ) == 'h00M' and GetUnitLifePercent(udg_DamageEventTarget) <= PALADIN_HEALTH_CHECK
    endfunction

    function Trig_Paladin3_Actions takes nothing returns nothing
        call DisableTrigger( GetTriggeringTrigger() )
        call Paladin01_WaveStart(udg_DamageEventTarget, PALADIN_WAVE_CREATION_COOLDOWN)
    endfunction

    //===========================================================================
    function InitTrig_Paladin3 takes nothing returns nothing
        set gg_trg_Paladin3 = CreateTrigger(  )
        call DisableTrigger( gg_trg_Paladin3 )
        call TriggerRegisterVariableEvent( gg_trg_Paladin3, "udg_AfterDamageEvent", EQUAL, 1.00 )
        call TriggerAddCondition( gg_trg_Paladin3, Condition( function Trig_Paladin3_Conditions ) )
        call TriggerAddAction( gg_trg_Paladin3, function Trig_Paladin3_Actions )
    endfunction

endscope

