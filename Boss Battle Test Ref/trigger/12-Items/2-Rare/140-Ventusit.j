function Trig_Ventusit_Conditions takes nothing returns boolean 
	return GetItemTypeId(GetManipulatedItem()) == 'I088'
endfunction 

function VentusitCast takes nothing returns nothing 
	local integer id = GetHandleId( GetExpiredTimer() )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "vent" ) )
    local real x = LoadReal( udg_hash, id, StringHash( "ventx" ) )
    local real y = LoadReal( udg_hash, id, StringHash( "venty" ) )
    local item it = LoadItemHandle( udg_hash, id, StringHash( "ventt" ) )
    
    if not(UnitHasItem(u,it )) then
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    elseif GetUnitState( u, UNIT_STATE_LIFE) > 0.405 and udg_combatlogic[GetPlayerId( GetOwningPlayer( u ) ) + 1] then
        if x != GetUnitX(u) or y != GetUnitY(u) then
            call shield( u, u, 10, 60 )
        endif
        
        call SaveReal( udg_hash, id, StringHash( "ventx" ), GetUnitX(u) ) 
        call SaveReal( udg_hash, id, StringHash( "venty" ), GetUnitY(u) )
    endif
    
    set u = null
    set it = null
endfunction 

function Trig_Ventusit_Actions takes nothing returns nothing 
    local integer id = GetHandleId( GetManipulatedItem() )
	
    if LoadTimerHandle( udg_hash, id, StringHash( "vent" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "vent" ), CreateTimer() )
    endif 
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "vent" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "vent" ), GetManipulatingUnit() ) 
    call SaveItemHandle( udg_hash, id, StringHash( "ventt" ), GetManipulatedItem() )
    call SaveReal( udg_hash, id, StringHash( "ventx" ), GetUnitX(GetManipulatingUnit()) ) 
    call SaveReal( udg_hash, id, StringHash( "venty" ), GetUnitY(GetManipulatingUnit()) ) 
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetManipulatedItem() ), StringHash( "vent" ) ), 1, true, function VentusitCast ) 
endfunction 

//=========================================================================== 
function InitTrig_Ventusit takes nothing returns nothing 
	set gg_trg_Ventusit = CreateTrigger( ) 
	call TriggerRegisterAnyUnitEventBJ( gg_trg_Ventusit, EVENT_PLAYER_UNIT_PICKUP_ITEM ) 
	call TriggerAddCondition( gg_trg_Ventusit, Condition( function Trig_Ventusit_Conditions ) ) 
	call TriggerAddAction( gg_trg_Ventusit, function Trig_Ventusit_Actions ) 
endfunction