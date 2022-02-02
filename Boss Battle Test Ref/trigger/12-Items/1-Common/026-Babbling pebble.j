function Trig_Babbling_pebble_Conditions takes nothing returns boolean 
	return GetItemTypeId(GetManipulatedItem()) == 'I09V'
endfunction 

function Babbling_pebbleCast takes nothing returns nothing 
	local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit n = LoadUnitHandle( udg_hash, id, StringHash( "bbpb" ) )
    local item it = LoadItemHandle( udg_hash, id, StringHash( "bbpbt" ) )
    local real mp 
    
    if not(UnitHasItem(n,it )) then
        call UnitRemoveAbility( n, 'A19O')
        call UnitRemoveAbility( n, 'B035')
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    elseif GetUnitState( n, UNIT_STATE_LIFE) > 0.405 then
        set mp = GetUnitState( n, UNIT_STATE_MANA)/GetUnitState( n, UNIT_STATE_MAX_MANA) * 100
        if mp >= 25 and GetUnitAbilityLevel( n, 'A19O') > 0 then
            call UnitRemoveAbility( n, 'A19O')
            call UnitRemoveAbility( n, 'B035')
        elseif mp <= 25 and GetUnitAbilityLevel( n, 'A19O') == 0 then
            call UnitAddAbility( n, 'A19O')
        endif            
    endif
    
    set it = null
    set n = null
endfunction 

function Trig_Babbling_pebble_Actions takes nothing returns nothing 
	local integer id = GetHandleId( GetManipulatedItem() )
	
    if LoadTimerHandle( udg_hash, id, StringHash( "bbpb" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bbpb" ), CreateTimer() )
    endif 
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bbpb" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "bbpb" ), GetManipulatingUnit() ) 
    call SaveItemHandle( udg_hash, id, StringHash( "bbpbt" ), GetManipulatedItem() ) 
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetManipulatedItem() ), StringHash( "bbpb" ) ), 1, true, function Babbling_pebbleCast ) 
endfunction 

//=========================================================================== 
function InitTrig_Babbling_pebble takes nothing returns nothing 
	set gg_trg_Babbling_pebble = CreateTrigger( ) 
	call TriggerRegisterAnyUnitEventBJ( gg_trg_Babbling_pebble, EVENT_PLAYER_UNIT_PICKUP_ITEM ) 
	call TriggerAddCondition( gg_trg_Babbling_pebble, Condition( function Trig_Babbling_pebble_Conditions ) ) 
	call TriggerAddAction( gg_trg_Babbling_pebble, function Trig_Babbling_pebble_Actions ) 
endfunction