function Trig_Box_Knight_Conditions takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == 'I08F'
endfunction

function Trig_Box_Knight_Actions takes nothing returns nothing
	call forge( GetManipulatingUnit(), GetManipulatedItem(), 'I000', 'I001', 'I002', true )
endfunction

//===========================================================================
function InitTrig_Box_Knight takes nothing returns nothing
    set gg_trg_Box_Knight = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Box_Knight, EVENT_PLAYER_UNIT_USE_ITEM )
    call TriggerAddCondition( gg_trg_Box_Knight, Condition( function Trig_Box_Knight_Conditions ) )
    call TriggerAddAction( gg_trg_Box_Knight, function Trig_Box_Knight_Actions )
endfunction

