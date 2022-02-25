function Trig_SilverLeaf_Conditions takes nothing returns boolean 
	return GetItemTypeId(GetManipulatedItem()) == 'I02F'
endfunction 

function ArgenLeafCast takes nothing returns nothing 
	local integer id = GetHandleId( GetExpiredTimer() )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "al" ) )
	local item it = LoadItemHandle( udg_hash, id, StringHash( "alt" ) )
    
    if not(UnitHasItem(u,it )) then
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    elseif GetUnitState( u, UNIT_STATE_LIFE) != GetUnitState( u, UNIT_STATE_MAX_LIFE) and GetUnitState( u, UNIT_STATE_LIFE) > 0.405 then
        call healst( u, null, GetUnitState( u, UNIT_STATE_MAX_LIFE) * 0.03 )
        call spectimeunit( u, "Abilities\\Spells\\Human\\Heal\\HealTarget.mdl", "origin", 2 )
    endif
    
    set u = null
    set it = null
endfunction 

function Trig_SilverLeaf_Actions takes nothing returns nothing 
	local integer id = GetHandleId( GetManipulatingUnit() )
	
    if LoadTimerHandle( udg_hash, id, StringHash( "al" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "al" ), CreateTimer() )
    endif 
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "al" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "al" ), GetManipulatingUnit() ) 
    call SaveItemHandle( udg_hash, id, StringHash( "alt" ), GetManipulatedItem() ) 
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetManipulatedItem() ), StringHash( "al" ) ), 12, true, function ArgenLeafCast )
endfunction 

//=========================================================================== 
function InitTrig_SilverLeaf takes nothing returns nothing 
	set gg_trg_SilverLeaf = CreateTrigger( ) 
	call TriggerRegisterAnyUnitEventBJ( gg_trg_SilverLeaf, EVENT_PLAYER_UNIT_PICKUP_ITEM ) 
	call TriggerAddCondition( gg_trg_SilverLeaf, Condition( function Trig_SilverLeaf_Conditions ) ) 
	call TriggerAddAction( gg_trg_SilverLeaf, function Trig_SilverLeaf_Actions ) 
endfunction