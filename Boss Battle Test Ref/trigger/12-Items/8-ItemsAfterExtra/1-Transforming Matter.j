function Trig_Transforming_Matter_Conditions takes nothing returns boolean
    return inv(GetManipulatingUnit(), 'I0D8') > 0 and GetItemTypeId(GetManipulatedItem()) != null and udg_logic[36] == false
endfunction

function Trig_Transforming_Matter_Actions takes nothing returns nothing
	local unit u = GetManipulatingUnit()
	local item it = GetManipulatedItem()

	if not(AlchemyLogic(it)) and GetItemType(it) != ITEM_TYPE_POWERUP and GetItemType(it) != ITEM_TYPE_PURCHASABLE then
		call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\Polymorph\\PolyMorphDoneGround.mdl", GetUnitX( u ), GetUnitY( u ) ) )
        call Inventory_ReplaceItemByNew(u, it, DB_SetItems[8][GetRandomInt( 1, udg_DB_SetItems_Num[8] )])
	endif

	set u = null
	set it = null
endfunction

//===========================================================================
function InitTrig_Transforming_Matter takes nothing returns nothing
    set gg_trg_Transforming_Matter = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Transforming_Matter, EVENT_PLAYER_UNIT_PICKUP_ITEM )
    call TriggerAddCondition( gg_trg_Transforming_Matter, Condition( function Trig_Transforming_Matter_Conditions ) )
    call TriggerAddAction( gg_trg_Transforming_Matter, function Trig_Transforming_Matter_Actions )
endfunction

