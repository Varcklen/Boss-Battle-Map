function Trig_Ifleave_Conditions takes nothing returns boolean
    return GetUnitTypeId( GetLeavingUnit() ) == 'n031' or GetUnitTypeId( GetLeavingUnit() ) == 'n05B' or GetUnitTypeId( GetLeavingUnit() ) == 'n04S' or GetUnitTypeId( GetLeavingUnit() ) == 'n01K' or GetUnitTypeId(GetLeavingUnit()) == 'n042' or GetUnitTypeId(GetLeavingUnit()) == 'n043' or GetUnitTypeId(GetLeavingUnit()) == 'n044' or GetUnitTypeId(GetLeavingUnit()) == 'n04G'
endfunction

function Trig_Ifleave_Actions takes nothing returns nothing
    call IssuePointOrderLoc( GetLeavingUnit(), "move", GetRandomLocInRect(gg_rct_Spawn) )
endfunction

//===========================================================================
function InitTrig_Ifleave takes nothing returns nothing
    set gg_trg_Ifleave = CreateTrigger(  )
    call TriggerRegisterLeaveRectSimple( gg_trg_Ifleave, gg_rct_Spawn )
    call TriggerAddCondition( gg_trg_Ifleave, Condition( function Trig_Ifleave_Conditions ) )
    call TriggerAddAction( gg_trg_Ifleave, function Trig_Ifleave_Actions )
endfunction

