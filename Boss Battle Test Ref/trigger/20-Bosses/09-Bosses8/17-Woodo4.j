function Trig_Woodo4_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'o000' and GetUnitLifePercent(udg_DamageEventTarget) <= 50
endfunction

function Trig_Woodo4_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )

    call DisableTrigger( GetTriggeringTrigger() )
    call CreateUnit( GetOwningPlayer(udg_DamageEventTarget), 'o00P', GetUnitX( udg_DamageEventTarget ) + GetRandomReal(-400, 400), GetUnitY( udg_DamageEventTarget ) + GetRandomReal(-400, 400), GetRandomReal( 0, 360 ) )
endfunction

//===========================================================================
function InitTrig_Woodo4 takes nothing returns nothing
    set gg_trg_Woodo4 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Woodo4 )
    call TriggerRegisterVariableEvent( gg_trg_Woodo4, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Woodo4, Condition( function Trig_Woodo4_Conditions ) )
    call TriggerAddAction( gg_trg_Woodo4, function Trig_Woodo4_Actions )
endfunction

