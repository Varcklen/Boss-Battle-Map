function Trig_Scarlet_worm_Conditions takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == 'I09X'
endfunction

function Scarlet_wormCast takes nothing returns nothing 
	local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "trstl" ) )
    local real hp = GetUnitState( u, UNIT_STATE_LIFE) / GetUnitState( u, UNIT_STATE_MAX_LIFE) * 100
    local item it = LoadItemHandle( udg_hash, id, StringHash( "trstlt" ) )
    
    if not(UnitHasItem(u,it )) then
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    elseif hp <= 50 and GetUnitState( u, UNIT_STATE_LIFE) > 0.405 then
        call spectimeunit( u, "Abilities\\Spells\\Human\\Heal\\HealTarget.mdl", "origin", 2 )
        call healst( u, null, GetUnitState( u, UNIT_STATE_MAX_LIFE) * 0.02 )
    endif
    
    set u = null
    set it = null
endfunction 

function Trig_Scarlet_worm_Actions takes nothing returns nothing
    local integer id = GetHandleId( GetManipulatedItem() )
	
    if LoadTimerHandle( udg_hash, id, StringHash( "trstl" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "trstl" ), CreateTimer() )
    endif 
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "trstl" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "trstl" ), GetManipulatingUnit() ) 
    call SaveItemHandle( udg_hash, id, StringHash( "trstlt" ), GetManipulatedItem() ) 
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetManipulatedItem() ), StringHash( "trstl" ) ), 2, true, function Scarlet_wormCast )
endfunction

//===========================================================================
function InitTrig_Scarlet_worm takes nothing returns nothing
    set gg_trg_Scarlet_worm = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Scarlet_worm, EVENT_PLAYER_UNIT_PICKUP_ITEM )
    call TriggerAddCondition( gg_trg_Scarlet_worm, Condition( function Trig_Scarlet_worm_Conditions ) )
    call TriggerAddAction( gg_trg_Scarlet_worm, function Trig_Scarlet_worm_Actions )
endfunction

