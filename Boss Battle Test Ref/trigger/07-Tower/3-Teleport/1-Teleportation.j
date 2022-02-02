function Trig_Teleportation_Conditions takes nothing returns boolean
    return IsUnitInGroup(GetEnteringUnit(), udg_heroinfo)
endfunction

function Trig_Teleportation_Actions takes nothing returns nothing
    local integer i = GetPlayerId(GetOwningPlayer(GetEnteringUnit())) + 1

    call SetUnitPosition(GetEnteringUnit(), GetLocationX(udg_point[i + 21]), GetLocationY(udg_point[i + 21]) )
    call SetUnitFacing(GetEnteringUnit(), 90 )
    call PanCameraToTimedLocForPlayer( GetOwningPlayer(GetEnteringUnit()), udg_point[i + 21], 0.00 )
    call DestroyEffect( AddSpecialEffect("Void Teleport Caster.mdx", GetLocationX(udg_point[i + 21]), GetLocationY(udg_point[i + 21]) ) )
endfunction

//===========================================================================
function InitTrig_Teleportation takes nothing returns nothing
    set gg_trg_Teleportation = CreateTrigger(  )
    call TriggerRegisterEnterRectSimple( gg_trg_Teleportation, gg_rct_Teleportation )
    call TriggerRegisterEnterRectSimple( gg_trg_Teleportation, gg_rct_Teleportation2 )
    call TriggerRegisterEnterRectSimple( gg_trg_Teleportation, gg_rct_Teleportation3 )
    call TriggerAddCondition( gg_trg_Teleportation, Condition( function Trig_Teleportation_Conditions ) )
    call TriggerAddAction( gg_trg_Teleportation, function Trig_Teleportation_Actions )
endfunction

