function Trig_Box_Mage_Conditions takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == 'I02T'
endfunction

function Trig_Box_Mage_Actions takes nothing returns nothing
	call forge( GetManipulatingUnit(), GetManipulatedItem(), 'I02Q', 'I02J', 'I02D', true )
endfunction

//===========================================================================
function InitTrig_Box_Mage takes nothing returns nothing
    set gg_trg_Box_Mage = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Box_Mage, EVENT_PLAYER_UNIT_USE_ITEM )
    call TriggerAddCondition( gg_trg_Box_Mage, Condition( function Trig_Box_Mage_Conditions ) )
    call TriggerAddAction( gg_trg_Box_Mage, function Trig_Box_Mage_Actions )
endfunction

