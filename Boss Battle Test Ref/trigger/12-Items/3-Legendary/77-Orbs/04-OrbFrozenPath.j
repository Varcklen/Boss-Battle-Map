function Trig_OrbFrozenPath_Conditions takes nothing returns boolean 
	return GetItemTypeId(GetManipulatedItem()) == 'I0DJ'
endfunction 

function OrbFrozenPathEnd takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local integer p = LoadInteger( udg_hash, id, StringHash( "orbfp1" ) )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "orbfp1" ) )

    call spdstpl( p, -1 * LoadReal( udg_hash, GetHandleId( u ), StringHash( "orbfp1" ) ) )
    call UnitRemoveAbility( u, 'A0I7' )
    call UnitRemoveAbility( u, 'B093' )
    call RemoveSavedReal( udg_hash, GetHandleId( u ), StringHash( "orbfp1" ) )
    call FlushChildHashtable( udg_hash, id )
    
    set u = null
endfunction

function OrbFrozenPathCast takes nothing returns nothing 
	local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "orbfp" ) )
    local item it = LoadItemHandle( udg_hash, id, StringHash( "orbfpt" ) )
    local real x = LoadReal( udg_hash, id, StringHash( "orbfpx" ) )
    local real y = LoadReal( udg_hash, id, StringHash( "orbfpy" ) )
    local integer id1
    local real isum
    local real t
    
    if not(UnitHasItem(caster,it )) then
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    elseif GetUnitState( caster, UNIT_STATE_LIFE) > 0.405 then
        if x != GetUnitX(caster) or y != GetUnitY(caster) then
            call dummyspawn( caster, 15, 'A0I3', 0, 0 )
            call SetUnitScale( bj_lastCreatedUnit, 2, 2, 2 )
            
            set t = timebonus(caster, 8)
            call UnitAddAbility( caster, 'A0I7')
            call spdst( caster, 3 )
            set isum = LoadReal( udg_hash, GetHandleId( caster ), StringHash( "orbfp1" ) ) + 3
            call SaveReal( udg_hash, GetHandleId( caster ), StringHash( "orbfp1" ), isum )
            
            set id1 = GetHandleId( caster )
            if LoadTimerHandle( udg_hash, id1, StringHash( "orbfp1" ) ) == null then
                call SaveTimerHandle( udg_hash, id1, StringHash( "orbfp1" ), CreateTimer() )
            endif
            set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "orbfp1" ) ) ) 
            call SaveUnitHandle( udg_hash, id1, StringHash( "orbfp1" ), caster )
            call SaveInteger( udg_hash, id1, StringHash( "orbfp1" ), GetPlayerId( GetOwningPlayer( caster ) ) )
            call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "orbfp1" ) ), t, false, function OrbFrozenPathEnd )
        
            call effst( caster, caster, null, 1, t )
        endif
        call SaveReal( udg_hash, id, StringHash( "orbfpx" ), GetUnitX(caster) ) 
        call SaveReal( udg_hash, id, StringHash( "orbfpy" ), GetUnitY(caster) )
    endif
    
    set it = null
    set caster = null
endfunction

function Trig_OrbFrozenPath_Actions takes nothing returns nothing 
	local integer id = GetHandleId( GetManipulatedItem() )
	
    if LoadTimerHandle( udg_hash, id, StringHash( "orbfp" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "orbfp" ), CreateTimer() )
    endif 
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "orbfp" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "orbfp" ), GetManipulatingUnit() ) 
    call SaveItemHandle( udg_hash, id, StringHash( "orbfpt" ), GetManipulatedItem() ) 
    call SaveReal( udg_hash, id, StringHash( "orbfpx" ), GetUnitX(GetManipulatingUnit()) ) 
    call SaveReal( udg_hash, id, StringHash( "orbfpy" ), GetUnitY(GetManipulatingUnit()) ) 
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetManipulatedItem() ), StringHash( "orbfp" ) ), 3, true, function OrbFrozenPathCast ) 
endfunction 

//=========================================================================== 
function InitTrig_OrbFrozenPath takes nothing returns nothing 
	set gg_trg_OrbFrozenPath = CreateTrigger( ) 
	call TriggerRegisterAnyUnitEventBJ( gg_trg_OrbFrozenPath, EVENT_PLAYER_UNIT_PICKUP_ITEM ) 
	call TriggerAddCondition( gg_trg_OrbFrozenPath, Condition( function Trig_OrbFrozenPath_Conditions ) ) 
	call TriggerAddAction( gg_trg_OrbFrozenPath, function Trig_OrbFrozenPath_Actions ) 
endfunction