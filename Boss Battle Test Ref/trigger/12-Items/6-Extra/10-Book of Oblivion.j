globals
    unit Event_Book_Of_Oblivion_Used_Unit
    real Event_Book_Of_Oblivion_Used_Real
endglobals

function Trig_Book_of_Oblivion_Conditions takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == 'I03S'
endfunction

function Book_of_OblivionEnd takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local item it = LoadItemHandle( udg_hash, id, StringHash( "bkoo1" ) )
    
    call RemoveItem( it )
    call FlushChildHashtable( udg_hash, id )
    
    set it = null
endfunction

function Book_of_OblivionCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local item it = LoadItemHandle( udg_hash, id, StringHash( "bkoo" ) )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "bkoou" ) )
    local integer id1
    
    call UnitAddItem(u, it)
    call FlushChildHashtable( udg_hash, id )
    
    set id1 = GetHandleId( it )
    call SaveTimerHandle( udg_hash, GetHandleId( it ), StringHash( "bkoo1" ), CreateTimer() )
	set id1 = GetHandleId( LoadTimerHandle( udg_hash, GetHandleId( it ), StringHash( "bkoo1" ) ) ) 
	call SaveItemHandle( udg_hash, id1, StringHash( "bkoo1" ), it )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( it ), StringHash( "bkoo1" ) ), 0.1, false, function Book_of_OblivionEnd )
    
    set it = null
    set u = null
endfunction

function Trig_Book_of_Oblivion_Actions takes nothing returns nothing
    local integer i = GetPlayerId(GetOwningPlayer(GetManipulatingUnit())) + 1
    local integer id
    
    call delspellpas( GetManipulatingUnit() )
    call UnitResetCooldown( GetManipulatingUnit() )
    
    set Event_Book_Of_Oblivion_Used_Unit = GetManipulatingUnit()
    
    set Event_Book_Of_Oblivion_Used_Real = 0.00
    set Event_Book_Of_Oblivion_Used_Real = 1.00
    set Event_Book_Of_Oblivion_Used_Real = 0.00

    set bj_lastCreatedItem = CreateItem( 'I01M', GetUnitX(GetManipulatingUnit()), GetUnitY(GetManipulatingUnit()))

    call SaveTimerHandle( udg_hash, GetHandleId( bj_lastCreatedItem ), StringHash( "bkoo" ), CreateTimer() )
	set id = GetHandleId( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedItem ), StringHash( "bkoo" ) ) ) 
	call SaveItemHandle( udg_hash, id, StringHash( "bkoo" ), bj_lastCreatedItem )
    call SaveUnitHandle( udg_hash, id, StringHash( "bkoou" ), GetManipulatingUnit() )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedItem ), StringHash( "bkoo" ) ), 0.01, false, function Book_of_OblivionCast )
endfunction

//===========================================================================
function InitTrig_Book_of_Oblivion takes nothing returns nothing
    set gg_trg_Book_of_Oblivion = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Book_of_Oblivion, EVENT_PLAYER_UNIT_PICKUP_ITEM )
    call TriggerAddCondition( gg_trg_Book_of_Oblivion, Condition( function Trig_Book_of_Oblivion_Conditions ) )
    call TriggerAddAction( gg_trg_Book_of_Oblivion, function Trig_Book_of_Oblivion_Actions )
endfunction

