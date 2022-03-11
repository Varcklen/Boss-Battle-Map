function Trig_Blademaster2_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'e001' and GetUnitLifePercent(udg_DamageEventTarget) <= 90
endfunction

function Blademaster2Run takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bsbm2" ) )
    local unit target = LoadUnitHandle( udg_hash, id, StringHash( "bsbm2t" ) )
    local integer counter = LoadInteger( udg_hash, id, StringHash( "bsbm2" ) ) + 1
    local real x = GetUnitX( target )
    local real y = GetUnitY( target )
    local real angle = Atan2( y - GetUnitY( boss ), x - GetUnitX( boss ) )
    local real NewX = GetUnitX( boss ) + 30 * Cos( angle )
    local real NewY = GetUnitY( boss ) + 30 * Sin( angle )
    
    if counter == 10 then
        call SetUnitFlyHeight( boss, -200, 500 )
    endif

    if counter == 20 or GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call SetUnitPathing( boss, true )
        call UnitRemoveAbility( boss, 'Amrf' )
        call pausest(boss, -1)
        if GetUnitState( target, UNIT_STATE_LIFE) > 0.405 then
            call dummyspawn( boss, 1, 0, 0, 0 )
            call DestroyEffect( AddSpecialEffect( "Objects\\Spawnmodels\\Human\\HumanLargeDeathExplode\\HumanLargeDeathExplode.mdl", GetUnitX( target ), GetUnitY( target ) ) )
            call UnitDamageTarget( bj_lastCreatedUnit, target, 100, true, false, ATTACK_TYPE_HERO, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS)
        endif
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id ) 
    else 
        call SaveInteger( udg_hash, id, StringHash( "bsbm2" ), counter )
        call SetUnitPosition( boss, NewX, NewY )
    endif
    
    set boss = null
    set target = null
endfunction

function Blademaster2Cast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bsbm1" ))
    local integer id1 = GetHandleId( boss )
    local unit target
    local real x
    local real y

    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        set target = randomtarget( boss, 600, "enemy", "", "", "", "" )
        if target != null then
            set x = GetUnitX( target )
            set y = GetUnitY( target )
            call SetUnitFacing( boss, AngleBetweenUnits( target, boss ) )
            call pausest(boss, 1)
            call UnitAddAbility( boss, 'Amrf' )
            call SetUnitFlyHeight( boss, 200, 500 )
            call SetUnitPathing( boss, true )

            if LoadTimerHandle( udg_hash, id1, StringHash( "bsbm2" ) ) == null  then
                call SaveTimerHandle( udg_hash, id1, StringHash( "bsbm2" ), CreateTimer() )
            endif
            set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "bsbm2" ) ) )
            call SaveUnitHandle( udg_hash, id1, StringHash( "bsbm2" ), boss )
            call SaveUnitHandle( udg_hash, id1, StringHash( "bsbm2t" ), target )
            call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( boss ), StringHash( "bsbm2" ) ), 0.02, true, function Blademaster2Run ) 
        endif
    endif
    
    set boss = null
    set target = null
endfunction

function Trig_Blademaster2_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )

    call DisableTrigger( GetTriggeringTrigger() )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "bsbm1" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bsbm1" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bsbm1" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bsbm1" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bsbm1" ) ), bosscast(8), true, function Blademaster2Cast )
endfunction

//===========================================================================
function InitTrig_Blademaster2 takes nothing returns nothing
    set gg_trg_Blademaster2 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Blademaster2 )
    call TriggerRegisterVariableEvent( gg_trg_Blademaster2, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Blademaster2, Condition( function Trig_Blademaster2_Conditions ) )
    call TriggerAddAction( gg_trg_Blademaster2, function Trig_Blademaster2_Actions )
endfunction