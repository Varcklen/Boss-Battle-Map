function Trig_Pandoras_Box_Conditions takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == 'I067' and not(udg_fightmod[0]) and not(RectContainsUnit(gg_rct_Vision5, GetManipulatingUnit()))
endfunction

function Trig_Pandoras_Box_Actions takes nothing returns nothing
    call SetUnitPosition(GetManipulatingUnit(), GetRectCenterX(gg_rct_Set5), GetRectCenterY(gg_rct_Set5))
    call SetUnitFacing(GetManipulatingUnit(), 270)
    call PanCameraToTimedForPlayer( GetOwningPlayer(GetManipulatingUnit()), GetRectCenterX(gg_rct_Set5), GetRectCenterY(gg_rct_Set5), 0.25 )
    call DestroyEffect( AddSpecialEffectTarget("Void Teleport Caster.mdx", GetManipulatingUnit(), "origin" ) )
    call stazisst( GetManipulatingUnit(), GetManipulatedItem() )
endfunction

//===========================================================================
function InitTrig_Pandoras_Box takes nothing returns nothing
    set gg_trg_Pandoras_Box = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Pandoras_Box, EVENT_PLAYER_UNIT_USE_ITEM )
    call TriggerAddCondition( gg_trg_Pandoras_Box, Condition( function Trig_Pandoras_Box_Conditions ) )
    call TriggerAddAction( gg_trg_Pandoras_Box, function Trig_Pandoras_Box_Actions )
endfunction

scope PandorasBoxInvul initializer Triggs
    private function AddInvul takes nothing returns nothing
        call UnitAddAbility(GetEnteringUnit(), 'A0A2')
    endfunction
    
    private function RemoveInvul takes nothing returns nothing
        call UnitRemoveAbility(GetLeavingUnit(), 'A0A2')
    endfunction
    
    private function RemoveInvulStartFight takes nothing returns nothing
        call UnitRemoveAbility(udg_FightStart_Unit, 'A0A2')
    endfunction

    private function Triggs takes nothing returns nothing
        local trigger trig = CreateTrigger()
        call TriggerRegisterEnterRectSimple( trig, gg_rct_Vision5 )
        call TriggerAddAction( trig, function AddInvul )
        
        set trig = CreateTrigger()
        call TriggerRegisterLeaveRectSimple( trig, gg_rct_Vision5 )
        call TriggerAddAction(  trig, function RemoveInvul )
        
        set trig = CreateTrigger()
        call TriggerRegisterLeaveRectSimple( trig, gg_rct_Vision5 )
        call TriggerRegisterVariableEvent( trig, "udg_FightStart_Real", EQUAL, 1.00 )
        call TriggerAddAction(  trig, function RemoveInvulStartFight )
        
        set trig = null
    endfunction
endscope


