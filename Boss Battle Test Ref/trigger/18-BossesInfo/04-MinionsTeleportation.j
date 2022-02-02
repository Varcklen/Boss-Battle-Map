function Trig_MinionsTeleportation_Conditions takes nothing returns boolean
    return udg_fightmod[1] and not(udg_fightmod[3]) and not( RectContainsUnit(udg_Boss_Rect, GetEnteringUnit()) ) and not( IsUnitType(GetEnteringUnit(), UNIT_TYPE_HERO) ) and GetOwningPlayer(GetEnteringUnit()) != Player(4) and GetUnitTypeId(GetEnteringUnit()) != 'h009' and GetUnitTypeId(GetEnteringUnit()) != 'h01F'
endfunction

function Trig_MinionsTeleportation_Actions takes nothing returns nothing
    call SetUnitPositionLoc( GetEnteringUnit(), GetUnitLoc(GroupPickRandomUnit(udg_otryad)) )
endfunction

//===========================================================================
function InitTrig_MinionsTeleportation takes nothing returns nothing
    set gg_trg_MinionsTeleportation = CreateTrigger(  )
    call DisableTrigger( gg_trg_MinionsTeleportation )
    call TriggerRegisterEnterRectSimple( gg_trg_MinionsTeleportation, GetWorldBounds() )
    call TriggerAddCondition( gg_trg_MinionsTeleportation, Condition( function Trig_MinionsTeleportation_Conditions ) )
    call TriggerAddAction( gg_trg_MinionsTeleportation, function Trig_MinionsTeleportation_Actions )
endfunction