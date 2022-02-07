function Trig_OrbAvalance_Conditions takes nothing returns boolean 
	return GetItemTypeId(GetManipulatedItem()) == 'I0ES'
endfunction 

function OrbAvalanceCast takes nothing returns nothing 
	local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit n = LoadUnitHandle( udg_hash, id, StringHash( "orbav" ) )
    local item it = LoadItemHandle( udg_hash, id, StringHash( "orbavt" ) )
    local real hp 
    
    if not(UnitHasItem(n,it )) then
        call UnitRemoveAbility( n, 'A0WD')
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    elseif GetUnitState( n, UNIT_STATE_LIFE) > 0.405 then
        set hp = GetUnitState( n, UNIT_STATE_LIFE)/GetUnitState( n, UNIT_STATE_MAX_LIFE) * 100
        if hp >= 50 and GetUnitAbilityLevel( n, 'A0WD') > 0 then
            call UnitRemoveAbility( n, 'A0WD')
        elseif hp <= 50 and hp > 0 and GetUnitAbilityLevel( n, 'A0WD') == 0 then
            call UnitAddAbility( n, 'A0WD')
        endif            
    endif
    
    set it = null
    set n = null
endfunction 

function Trig_OrbAvalance_Actions takes nothing returns nothing 
	local integer id = GetHandleId( GetManipulatedItem() )
	
    if LoadTimerHandle( udg_hash, id, StringHash( "orbav" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "orbav" ), CreateTimer() )
    endif 
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "orbav" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "orbav" ), GetManipulatingUnit() ) 
    call SaveItemHandle( udg_hash, id, StringHash( "orbavt" ), GetManipulatedItem() ) 
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetManipulatedItem() ), StringHash( "orbav" ) ), 1, true, function OrbAvalanceCast ) 
endfunction 

//=========================================================================== 
function InitTrig_OrbAvalance takes nothing returns nothing 
	set gg_trg_OrbAvalance = CreateTrigger( ) 
	call TriggerRegisterAnyUnitEventBJ( gg_trg_OrbAvalance, EVENT_PLAYER_UNIT_PICKUP_ITEM ) 
	call TriggerAddCondition( gg_trg_OrbAvalance, Condition( function Trig_OrbAvalance_Conditions ) ) 
	call TriggerAddAction( gg_trg_OrbAvalance, function Trig_OrbAvalance_Actions ) 
endfunction