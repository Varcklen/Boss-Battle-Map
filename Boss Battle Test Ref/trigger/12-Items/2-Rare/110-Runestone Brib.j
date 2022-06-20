function Trig_Runestone_Brib_Conditions takes nothing returns boolean
    if udg_logic[36] then
        return false
    elseif GetItemTypeId(GetManipulatedItem()) == 'I01C' then
        return false
    elseif inv( GetManipulatingUnit(), 'I01C' ) == 0 then
        return false
    elseif udg_logic[GetPlayerId(GetOwningPlayer(GetManipulatingUnit())) + 1 + 26] then
        return false
    elseif LoadBoolean( udg_hash, GetHandleId( GetManipulatedItem() ), StringHash( "jule" ) ) then
        return false
    elseif SubString(BlzGetItemExtendedTooltip(GetManipulatedItem()), 0, 18) == "|cffC71585Cursed|r" then
        return false
    endif
    return true
endfunction 

function Trig_Runestone_Brib_Actions takes nothing returns nothing 
    call BlzSetItemIconPath( GetManipulatedItem(), "|cffC71585Cursed|r|n" + BlzGetItemExtendedTooltip(GetManipulatedItem()) )
endfunction 

//=========================================================================== 
function InitTrig_Runestone_Brib takes nothing returns nothing 
	set gg_trg_Runestone_Brib = CreateTrigger( ) 
	call TriggerRegisterAnyUnitEventBJ( gg_trg_Runestone_Brib, EVENT_PLAYER_UNIT_PICKUP_ITEM ) 
	call TriggerAddCondition( gg_trg_Runestone_Brib, Condition( function Trig_Runestone_Brib_Conditions ) ) 
	call TriggerAddAction( gg_trg_Runestone_Brib, function Trig_Runestone_Brib_Actions ) 
endfunction