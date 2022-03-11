function Trig_IA_TPBattle_Conditions takes nothing returns boolean
    return udg_fightmod[2] and not( RectContainsUnit(gg_rct_RandomItem, GetEnteringUnit()) ) and not ( IsUnitType(GetEnteringUnit(), UNIT_TYPE_HERO) ) and ( IsUnitInGroup(udg_hero[GetPlayerId(GetOwningPlayer(GetEnteringUnit())) + 1], udg_heroinfo) or GetOwningPlayer(GetEnteringUnit()) == Player(4) )
endfunction

function Trig_IA_TPBattle_Actions takes nothing returns nothing
    call SetUnitPositionLoc( GetEnteringUnit(), GetUnitLoc(GroupPickRandomUnit(udg_otryad)) )
endfunction

//===========================================================================
function InitTrig_IA_TPBattle takes nothing returns nothing
    set gg_trg_IA_TPBattle = CreateTrigger(  )
    call DisableTrigger( gg_trg_IA_TPBattle )
    call TriggerRegisterEnterRectSimple( gg_trg_IA_TPBattle, GetEntireMapRect() )
    call TriggerAddCondition( gg_trg_IA_TPBattle, Condition( function Trig_IA_TPBattle_Conditions ) )
    call TriggerAddAction( gg_trg_IA_TPBattle, function Trig_IA_TPBattle_Actions )
endfunction

