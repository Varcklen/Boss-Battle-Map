function Trig_OrbMountain_Conditions takes nothing returns boolean 
	return GetItemTypeId(GetManipulatedItem()) == 'I0F2'
endfunction 

function OrbMountainCast takes nothing returns nothing 
	local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit n = LoadUnitHandle( udg_hash, id, StringHash( "orbmn" ) )
    local item it = LoadItemHandle( udg_hash, id, StringHash( "orbmnt" ) )
    
    if not(UnitHasItem(n,it )) then
        call UnitRemoveAbility( n, 'A0WD')
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    elseif GetUnitState( n, UNIT_STATE_LIFE) > 0.405 then
        call shield( n, null, 300, 60 )
        call effst( n, n, null, 1, 60 )       
    endif
    
    set it = null
    set n = null
endfunction 

function Trig_OrbMountain_Actions takes nothing returns nothing 
	local integer id = GetHandleId( GetManipulatedItem() )
	
    if LoadTimerHandle( udg_hash, id, StringHash( "orbmn" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "orbmn" ), CreateTimer() )
    endif 
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "orbmn" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "orbmn" ), GetManipulatingUnit() ) 
    call SaveItemHandle( udg_hash, id, StringHash( "orbmnt" ), GetManipulatedItem() ) 
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetManipulatedItem() ), StringHash( "orbmn" ) ), 25, true, function OrbMountainCast ) 
endfunction 

//=========================================================================== 
function InitTrig_OrbMountain takes nothing returns nothing 
	set gg_trg_OrbMountain = CreateTrigger( ) 
	call TriggerRegisterAnyUnitEventBJ( gg_trg_OrbMountain, EVENT_PLAYER_UNIT_PICKUP_ITEM ) 
	call TriggerAddCondition( gg_trg_OrbMountain, Condition( function Trig_OrbMountain_Conditions ) ) 
	call TriggerAddAction( gg_trg_OrbMountain, function Trig_OrbMountain_Actions ) 
endfunction