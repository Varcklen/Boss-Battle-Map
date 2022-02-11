function Trig_OrbFrostFire_Conditions takes nothing returns boolean 
	return GetItemTypeId(GetManipulatedItem()) == 'I0AH'
endfunction 

function OrbFrostFireCast takes nothing returns nothing 
	local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit n = LoadUnitHandle( udg_hash, id, StringHash( "orbfr" ) )
    local item it = LoadItemHandle( udg_hash, id, StringHash( "orbfrt" ) )
    local group g = CreateGroup()
    local unit u
    
    if not(UnitHasItem(n,it )) then
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    elseif GetUnitState( n, UNIT_STATE_LIFE) > 0.405 then
        call dummyspawn( n, 1, 0, 0, 0 )
        call GroupEnumUnitsInRange( g, GetUnitX(n), GetUnitY(n), 400, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if unitst( u, n, "enemy" ) then
                call UnitDamageTarget( bj_lastCreatedUnit, u, 20, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_FIRE, WEAPON_TYPE_WHOKNOWS )
                call bufst( n, u, 'A0DS', 'B090', "orbf", 4 )
                call debuffst( n, u, null, 1, 1 )
            endif
            call GroupRemoveUnit(g,u)
            set u = FirstOfGroup(g)
        endloop
    endif
    
    call GroupClear( g )
    call DestroyGroup( g )
    set g = null
    set u = null
    set it = null
    set n = null
endfunction

function Trig_OrbFrostFire_Actions takes nothing returns nothing 
	local integer id = GetHandleId( GetManipulatedItem() )
	
    if LoadTimerHandle( udg_hash, id, StringHash( "orbfr" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "orbfr" ), CreateTimer() )
    endif 
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "orbfr" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "orbfr" ), GetManipulatingUnit() ) 
    call SaveItemHandle( udg_hash, id, StringHash( "orbfrt" ), GetManipulatedItem() ) 
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetManipulatedItem() ), StringHash( "orbfr" ) ), 1, true, function OrbFrostFireCast ) 
endfunction 

//=========================================================================== 
function InitTrig_OrbFrostFire takes nothing returns nothing 
	set gg_trg_OrbFrostFire = CreateTrigger( ) 
	call TriggerRegisterAnyUnitEventBJ( gg_trg_OrbFrostFire, EVENT_PLAYER_UNIT_PICKUP_ITEM ) 
	call TriggerAddCondition( gg_trg_OrbFrostFire, Condition( function Trig_OrbFrostFire_Conditions ) ) 
	call TriggerAddAction( gg_trg_OrbFrostFire, function Trig_OrbFrostFire_Actions ) 
endfunction