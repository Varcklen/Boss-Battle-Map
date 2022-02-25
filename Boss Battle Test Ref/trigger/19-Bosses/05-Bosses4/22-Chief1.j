function Trig_Chief1_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventSource) == 'h01X'
endfunction

function Trig_Chief1_Actions takes nothing returns nothing
    set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( udg_DamageEventSource ), 'u000', GetUnitX( udg_DamageEventTarget ), GetUnitY( udg_DamageEventTarget ), 270 )
    call UnitAddAbility( bj_lastCreatedUnit, 'A16V')
    call UnitApplyTimedLife( bj_lastCreatedUnit, 'BTLF', 1)
    call IssuePointOrder( bj_lastCreatedUnit, "silence", GetUnitX( bj_lastCreatedUnit ), GetUnitY( bj_lastCreatedUnit ) )
endfunction

//===========================================================================
function InitTrig_Chief1 takes nothing returns nothing
    set gg_trg_Chief1 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Chief1 )
    call TriggerRegisterVariableEvent( gg_trg_Chief1, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Chief1, Condition( function Trig_Chief1_Conditions ) )
    call TriggerAddAction( gg_trg_Chief1, function Trig_Chief1_Actions )
endfunction

