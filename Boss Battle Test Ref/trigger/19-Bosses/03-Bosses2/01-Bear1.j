function Trig_Bear1_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'n010'
endfunction

function BearDealDamage takes unit boss returns nothing
    local group g = CreateGroup()
    local unit u

    call GroupEnumUnitsInRange( g, GetUnitX( boss ), GetUnitY( boss ), 300, null )
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if unitst( u, boss, "enemy" ) then
            call dummyspawn( boss, 1, 'A0AJ', 0, 0 )
            call IssueTargetOrder( bj_lastCreatedUnit, "thunderbolt", u )
        endif
        call GroupRemoveUnit(g,u)
    endloop

    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
    set boss = null
endfunction

function BearRun takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bsbr1" ) )
    local unit target = LoadUnitHandle( udg_hash, id, StringHash( "bsbr1trg" ) )
    local integer counter = LoadInteger( udg_hash, id, StringHash( "bsbr1" ) ) + 1
    local real x = GetUnitX( target )
    local real y = GetUnitY( target )
    local real angle = Atan2( y - GetUnitY( boss ), x - GetUnitX( boss ) )
    local real NewX = GetUnitX( boss ) + 30 * Cos( angle )
    local real NewY = GetUnitY( boss ) + 30 * Sin( angle )
    
    if counter == 10 then
        call SetUnitFlyHeight( boss, -600, 1500 )
    endif

    if counter == 20 or GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        if GetUnitState( boss, UNIT_STATE_LIFE) > 0.405 then
            call SetUnitPathing( boss, true )
            call UnitRemoveAbility( boss, 'Amrf' )
    		call pausest( boss, -1 )
            call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\ThunderClap\\ThunderClapCaster.mdl", NewX, NewY ) )
            call BearDealDamage(boss)
        endif
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id ) 
    else 
        call SaveInteger( udg_hash, id, StringHash( "bsbr1" ), counter )
        call SetUnitPosition( boss, NewX, NewY )
    endif
    
    
    set boss = null
    set target = null
endfunction

function BearCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local real x
    local real y
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bsbr" ))
    local integer id1 = GetHandleId( boss )
    local unit target
    
    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        set target = randomtarget( boss, 600, "enemy", "", "", "", "" )
        if target != null then
            set x = GetUnitX( target ) + GetRandomReal(-150, 150)
            set y = GetUnitY( target ) + GetRandomReal(-150, 150)
            call SetUnitFacing( boss, Atan2( y - GetUnitY( target ), x - GetUnitX( target ) ) )
    		call pausest( boss, 1 )
            call UnitAddAbility( boss, 'Amrf' )
            call SetUnitFlyHeight( boss, 600, 1500 )
            call SetUnitPathing( boss, true )
            
            if LoadTimerHandle( udg_hash, id1, StringHash( "bsbr1" ) ) == null  then
                call SaveTimerHandle( udg_hash, id1, StringHash( "bsbr1" ), CreateTimer() )
            endif
            set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "bsbr1" ) ) )
            call SaveUnitHandle( udg_hash, id1, StringHash( "bsbr1" ), boss )
            call SaveUnitHandle( udg_hash, id1, StringHash( "bsbr1trg" ), target )
            call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( boss ), StringHash( "bsbr1" ) ), 0.02, true, function BearRun ) 
        endif
    endif
    
    set boss = null
    set target = null
endfunction

function Trig_Bear1_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )

    call DisableTrigger( GetTriggeringTrigger() )    
    
    if LoadTimerHandle( udg_hash, id, StringHash( "bsbr" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bsbr" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bsbr" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bsbr" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bsbr" ) ), bosscast(14), true, function BearCast )
endfunction

//===========================================================================
function InitTrig_Bear1 takes nothing returns nothing
    set gg_trg_Bear1 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Bear1 )
    call TriggerRegisterVariableEvent( gg_trg_Bear1, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Bear1, Condition( function Trig_Bear1_Conditions ) )
    call TriggerAddAction( gg_trg_Bear1, function Trig_Bear1_Actions )
endfunction

