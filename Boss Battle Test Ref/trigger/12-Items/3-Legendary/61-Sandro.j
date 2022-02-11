function Trig_Sandro_Conditions takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == 'I03F'
endfunction

function Trig_Sandro_Actions takes nothing returns nothing
    call Sandro( GetManipulatingUnit(), GetManipulatedItem() )
endfunction

//===========================================================================
function InitTrig_Sandro takes nothing returns nothing
    set gg_trg_Sandro = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Sandro, EVENT_PLAYER_UNIT_USE_ITEM )
    call TriggerAddCondition( gg_trg_Sandro, Condition( function Trig_Sandro_Conditions ) )
    call TriggerAddAction( gg_trg_Sandro, function Trig_Sandro_Actions )
endfunction

