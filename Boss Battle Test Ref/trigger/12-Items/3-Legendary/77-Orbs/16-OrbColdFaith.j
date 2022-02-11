function Trig_OrbColdFaith_Conditions takes nothing returns boolean 
	return GetItemTypeId(GetManipulatedItem()) == 'I0FO'
endfunction 

function OrbColdFaithCast takes nothing returns nothing 
	local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit n = LoadUnitHandle( udg_hash, id, StringHash( "orbcf" ) )
    local item it = LoadItemHandle( udg_hash, id, StringHash( "orbcft" ) )
    
    if not(UnitHasItem(n,it )) then
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    elseif GetUnitState( n, UNIT_STATE_LIFE) > 0.405 then
        call dummyspawn( n, 10, 'A0JE', 0, 0 )
        call SetUnitScale( bj_lastCreatedUnit, 3, 3, 3 )
    endif
    
    set it = null
    set n = null
endfunction

function Trig_OrbColdFaith_Actions takes nothing returns nothing 
	local integer id = GetHandleId( GetManipulatedItem() )
	
    if LoadTimerHandle( udg_hash, id, StringHash( "orbcf" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "orbcf" ), CreateTimer() )
    endif 
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "orbcf" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "orbcf" ), GetManipulatingUnit() ) 
    call SaveItemHandle( udg_hash, id, StringHash( "orbcft" ), GetManipulatedItem() ) 
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetManipulatedItem() ), StringHash( "orbcf" ) ), 3, true, function OrbColdFaithCast ) 
endfunction 

//=========================================================================== 
function InitTrig_OrbColdFaith takes nothing returns nothing 
	set gg_trg_OrbColdFaith = CreateTrigger( ) 
	call TriggerRegisterAnyUnitEventBJ( gg_trg_OrbColdFaith, EVENT_PLAYER_UNIT_PICKUP_ITEM ) 
	call TriggerAddCondition( gg_trg_OrbColdFaith, Condition( function Trig_OrbColdFaith_Conditions ) ) 
	call TriggerAddAction( gg_trg_OrbColdFaith, function Trig_OrbColdFaith_Actions ) 
endfunction