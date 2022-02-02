function Trig_Wiz_Conditions takes nothing returns boolean 
	return GetItemTypeId(GetManipulatedItem()) == 'I0BL'
endfunction 

function WizCast takes nothing returns nothing 
	local integer id = GetHandleId( GetExpiredTimer() )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "wiz" ) )
    local item it = LoadItemHandle( udg_hash, id, StringHash( "wizt" ) )
    
    if not(UnitHasItem(u,it )) then
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    elseif GetUnitState( u, UNIT_STATE_LIFE) > 0.405 then
        call healst( u, null, GetUnitState( u, UNIT_STATE_MAX_LIFE) )
        call manast( u, null, GetUnitState( u, UNIT_STATE_MAX_MANA) )
        call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\Human\\ReviveHuman\\ReviveHuman.mdl", u, "origin" ) )
    endif
    
    set u = null
endfunction 

function Trig_Wiz_Actions takes nothing returns nothing 
	local integer id = GetHandleId( GetManipulatedItem() )
	
    if LoadTimerHandle( udg_hash, id, StringHash( "wiz" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "wiz" ), CreateTimer() )
    endif 
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "wiz" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "wiz" ), GetManipulatingUnit() ) 
    call SaveItemHandle( udg_hash, id, StringHash( "wizt" ), GetManipulatedItem() ) 
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetManipulatedItem() ), StringHash( "wiz" ) ), 60, true, function WizCast )
endfunction 

//=========================================================================== 
function InitTrig_Wiz takes nothing returns nothing 
	set gg_trg_Wiz = CreateTrigger( ) 
	call TriggerRegisterAnyUnitEventBJ( gg_trg_Wiz, EVENT_PLAYER_UNIT_PICKUP_ITEM ) 
	call TriggerAddCondition( gg_trg_Wiz, Condition( function Trig_Wiz_Conditions ) ) 
	call TriggerAddAction( gg_trg_Wiz, function Trig_Wiz_Actions ) 
endfunction