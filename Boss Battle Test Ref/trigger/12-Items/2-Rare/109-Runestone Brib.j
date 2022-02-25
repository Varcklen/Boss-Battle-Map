function Trig_Runestone_Brib_Conditions takes nothing returns boolean 
	return GetItemTypeId(GetManipulatedItem()) != 'I01C' and inv( GetManipulatingUnit(), 'I01C' ) > 0 and not(udg_logic[GetPlayerId(GetOwningPlayer(GetManipulatingUnit())) + 1 + 26]) and not(LoadBoolean( udg_hash, GetHandleId( GetManipulatedItem() ), StringHash( "jule" ) ))
endfunction 

function Trig_Runestone_Brib_Actions takes nothing returns nothing 
    if SubString(BlzGetItemExtendedTooltip(GetManipulatedItem()), 0, 18) != "|cffC71585Cursed|r" then 
        call BlzSetItemIconPath( GetManipulatedItem(), "|cffC71585Cursed|r|n" + BlzGetItemExtendedTooltip(GetManipulatedItem()) )
    endif
endfunction 

//=========================================================================== 
function InitTrig_Runestone_Brib takes nothing returns nothing 
	set gg_trg_Runestone_Brib = CreateTrigger( ) 
	call TriggerRegisterAnyUnitEventBJ( gg_trg_Runestone_Brib, EVENT_PLAYER_UNIT_PICKUP_ITEM ) 
	call TriggerAddCondition( gg_trg_Runestone_Brib, Condition( function Trig_Runestone_Brib_Conditions ) ) 
	call TriggerAddAction( gg_trg_Runestone_Brib, function Trig_Runestone_Brib_Actions ) 
endfunction