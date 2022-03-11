function Trig_PolyAttackStop_Conditions takes nothing returns boolean
    return GetUnitAbilityLevel(GetAttacker(), 'A1A0') > 0
endfunction

function Trig_PolyAttackStop_Actions takes nothing returns nothing
    call IssueImmediateOrder( GetAttacker(), "stop" )
endfunction

//===========================================================================
function InitTrig_PolyAttackStop takes nothing returns nothing
    set gg_trg_PolyAttackStop = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_PolyAttackStop, EVENT_PLAYER_UNIT_ATTACKED )
    call TriggerAddCondition( gg_trg_PolyAttackStop, Condition( function Trig_PolyAttackStop_Conditions ) )
    call TriggerAddAction( gg_trg_PolyAttackStop, function Trig_PolyAttackStop_Actions )
endfunction

