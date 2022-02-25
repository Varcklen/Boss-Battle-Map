globals
    integer array LastForgeItems[5][4]//playerIndex/item
endglobals

function Trig_Pocket_Galaxy_Conditions takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == 'I0GK'
endfunction

function Trig_Pocket_Galaxy_Actions takes nothing returns nothing
    local integer playerIndex = GetUnitUserData(GetManipulatingUnit())
	call forge( GetManipulatingUnit(), GetManipulatedItem(), LastForgeItems[playerIndex][1], LastForgeItems[playerIndex][2], LastForgeItems[playerIndex][3], true )
endfunction

//===========================================================================
function InitTrig_Pocket_Galaxy takes nothing returns nothing
    set gg_trg_Pocket_Galaxy = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Pocket_Galaxy, EVENT_PLAYER_UNIT_USE_ITEM )
    call TriggerAddCondition( gg_trg_Pocket_Galaxy, Condition( function Trig_Pocket_Galaxy_Conditions ) )
    call TriggerAddAction( gg_trg_Pocket_Galaxy, function Trig_Pocket_Galaxy_Actions )
endfunction

