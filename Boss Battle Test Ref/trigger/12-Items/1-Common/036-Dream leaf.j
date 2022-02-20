function Trig_Dream_leaf_Conditions takes nothing returns boolean 
	return GetItemTypeId(GetManipulatedItem()) == 'I0CM'
endfunction 

function Sleepy_leafCast takes nothing returns nothing 
	local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "sllf" ) )
    local item it = LoadItemHandle( udg_hash, id, StringHash( "sllft" ) )
    
    if not(UnitHasItem(u,it )) then
        call UnitRemoveAbility( u, 'A15K')
        call UnitRemoveAbility( u, 'B071')
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    elseif GetUnitState( u, UNIT_STATE_LIFE) > 0.405 then
        if GetUnitState( u, UNIT_STATE_LIFE) != GetUnitState( u, UNIT_STATE_MAX_LIFE) and GetUnitAbilityLevel( u, 'B071') > 0 then
            call UnitRemoveAbility( u, 'A15K')
            call UnitRemoveAbility( u, 'B071')
        elseif GetUnitState( u, UNIT_STATE_LIFE) == GetUnitState( u, UNIT_STATE_MAX_LIFE) and GetUnitAbilityLevel( u, 'B071') == 0 then
            call UnitAddAbility( u, 'A15K')
        endif
    endif
    
    set it = null
    set u = null
endfunction 

function Trig_Dream_leaf_Actions takes nothing returns nothing 
	local integer id = GetHandleId( GetManipulatedItem() )
	
    if LoadTimerHandle( udg_hash, id, StringHash( "sllf" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "sllf" ), CreateTimer() )
    endif 
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "sllf" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "sllf" ), GetManipulatingUnit() ) 
    call SaveItemHandle( udg_hash, id, StringHash( "sllft" ), GetManipulatedItem() ) 
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetManipulatedItem() ), StringHash( "sllf" ) ), 1, true, function Sleepy_leafCast )
endfunction 

//=========================================================================== 
function InitTrig_Dream_leaf takes nothing returns nothing 
	set gg_trg_Dream_leaf = CreateTrigger( ) 
	call TriggerRegisterAnyUnitEventBJ( gg_trg_Dream_leaf, EVENT_PLAYER_UNIT_PICKUP_ITEM ) 
	call TriggerAddCondition( gg_trg_Dream_leaf, Condition( function Trig_Dream_leaf_Conditions ) ) 
	call TriggerAddAction( gg_trg_Dream_leaf, function Trig_Dream_leaf_Actions ) 
endfunction