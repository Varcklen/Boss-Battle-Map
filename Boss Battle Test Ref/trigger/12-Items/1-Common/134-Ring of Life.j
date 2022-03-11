function Trig_Ring_of_Life_Conditions takes nothing returns boolean 
	return GetItemTypeId(GetManipulatedItem()) == 'I0EH'
endfunction 

function LifeRingCast takes nothing returns nothing 
	local integer id = GetHandleId( GetExpiredTimer() )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "lr" ) )
    local item it = LoadItemHandle( udg_hash, id, StringHash( "lrt" ) )
	
    if not(UnitHasItem(u,it )) then
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    elseif GetUnitState( u, UNIT_STATE_LIFE) > 0.405 then
        call healst( u, null, GetUnitState( u, UNIT_STATE_MAX_LIFE) * 0.05 )
        call manast( u, null, GetUnitState( u, UNIT_STATE_MAX_MANA) * 0.05 )
        call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Undead\\VampiricAura\\VampiricAuraTarget.mdl", u, "origin") )
    endif
    
    set it = null
    set u = null
endfunction 

function Trig_Ring_of_Life_Actions takes nothing returns nothing 
	local integer id = GetHandleId( GetManipulatedItem() )
	
    if LoadTimerHandle( udg_hash, id, StringHash( "lr" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "lr" ), CreateTimer() )
    endif 
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "lr" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "lr" ), GetManipulatingUnit() ) 
    call SaveItemHandle( udg_hash, id, StringHash( "lrt" ), GetManipulatedItem() ) 
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetManipulatedItem() ), StringHash( "lr" ) ), 15, true, function LifeRingCast ) 
endfunction 

//=========================================================================== 
function InitTrig_Ring_of_Life takes nothing returns nothing 
	set gg_trg_Ring_of_Life = CreateTrigger( ) 
	call TriggerRegisterAnyUnitEventBJ( gg_trg_Ring_of_Life, EVENT_PLAYER_UNIT_PICKUP_ITEM ) 
	call TriggerAddCondition( gg_trg_Ring_of_Life, Condition( function Trig_Ring_of_Life_Conditions ) ) 
	call TriggerAddAction( gg_trg_Ring_of_Life, function Trig_Ring_of_Life_Actions ) 
endfunction