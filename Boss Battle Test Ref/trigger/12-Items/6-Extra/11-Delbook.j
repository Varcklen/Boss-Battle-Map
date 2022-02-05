function Trig_Delbook_Conditions takes nothing returns boolean
    return IsItemIdPowerup(GetItemTypeId(GetManipulatedItem()))
endfunction

function DelbookCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    call RemoveItem( LoadItemHandle( udg_hash, id, StringHash( "delb" ) ) )
    call FlushChildHashtable( udg_hash, id )
endfunction

function Trig_Delbook_Actions takes nothing returns nothing
    local integer id = GetHandleId( GetManipulatedItem() )
    
    call SaveTimerHandle( udg_hash, GetHandleId( GetManipulatedItem() ), StringHash( "delb" ), CreateTimer() )
	set id = GetHandleId( LoadTimerHandle( udg_hash, GetHandleId( GetManipulatedItem() ), StringHash( "delb" ) ) ) 
	call SaveItemHandle( udg_hash, id, StringHash( "delb" ), GetManipulatedItem() )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetManipulatedItem() ), StringHash( "delb" ) ), 0.1, false, function DelbookCast )
endfunction

//===========================================================================
function InitTrig_Delbook takes nothing returns nothing
    set gg_trg_Delbook = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Delbook, EVENT_PLAYER_UNIT_PICKUP_ITEM )
    call TriggerAddCondition( gg_trg_Delbook, Condition( function Trig_Delbook_Conditions ) )
    call TriggerAddAction( gg_trg_Delbook, function Trig_Delbook_Actions )
endfunction

