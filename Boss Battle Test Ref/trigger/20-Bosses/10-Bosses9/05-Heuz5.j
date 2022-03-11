function Trig_Heuz5_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'e008'
endfunction

function Trig_Heuz5_Actions takes nothing returns nothing
    set heuz = udg_DamageEventTarget
    call DisableTrigger( GetTriggeringTrigger() )
endfunction

//===========================================================================
function InitTrig_Heuz5 takes nothing returns nothing
    set gg_trg_Heuz5 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Heuz5 )
    call TriggerRegisterVariableEvent( gg_trg_Heuz5, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Heuz5, Condition( function Trig_Heuz5_Conditions ) )
    call TriggerAddAction( gg_trg_Heuz5, function Trig_Heuz5_Actions )
endfunction

