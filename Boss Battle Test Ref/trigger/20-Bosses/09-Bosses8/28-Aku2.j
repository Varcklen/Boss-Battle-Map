function Trig_Aku2_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'n04O'
endfunction

function Aku2End takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local integer counter = LoadInteger( udg_hash, id, StringHash( "bskn1bsdl2" ) )
    local real x = LoadReal( udg_hash, id, StringHash( "bsdl2x" ) )
    local real y = LoadReal( udg_hash, id, StringHash( "bsdl2y" ) )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bsdl2" ) )
    local real angle = Atan2( y - GetUnitY( boss ), x - GetUnitX( boss ) )
    local real NewX = GetUnitX( boss ) + 30 * Cos( angle )
    local real NewY = GetUnitY( boss ) + 30 * Sin( angle )
    local real IfX = ( ( x - GetUnitX( boss ) ) * ( x - GetUnitX( boss ) ) )
    local real IfY = ( ( y - GetUnitY( boss ) ) * ( y - GetUnitY( boss ) ) )
    
    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    elseif SquareRoot( IfX + IfY ) > 100 and counter < 100 then
        call SetUnitPosition( boss, NewX, NewY )
        call SaveInteger( udg_hash, id, StringHash( "bsdl2" ), counter + 1 )
    else
        call SetUnitPathing( boss, true )
        call pausest( boss, -1 )
        call UnitRemoveAbility( boss, 'A0RO' )
        call UnitRemoveAbility( boss, 'B01G' )
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    endif
    
    set boss = null
endfunction

function Aku2Cast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local integer id1
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bsdl1" ) )
    local unit target = LoadUnitHandle( udg_hash, GetHandleId( boss ), StringHash( "bsdl" ) )

    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    elseif GetUnitState( target, UNIT_STATE_LIFE) > 0.405 then
        call UnitAddAbility( boss, 'A0RO' )
        call pausest( boss, 1 )
        call SetUnitPathing( boss, false )
        call SetUnitFacing( boss, AngleBetweenUnits( target, boss ) )
        
        set id1 = GetHandleId( boss )
        call SaveTimerHandle( udg_hash, id1, StringHash( "bsdl2" ), CreateTimer() )
        set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "bsdl2" ) ) ) 
        call SaveUnitHandle( udg_hash, id1, StringHash( "bsdl2" ), boss )
        call SaveReal( udg_hash, id1, StringHash( "bsdl2x" ), GetUnitX( target ) )
        call SaveReal( udg_hash, id1, StringHash( "bsdl2y" ), GetUnitY( target ) )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( boss ), StringHash( "bsdl2" ) ), 0.04, true, function Aku2End )
    endif
    
    set boss = null
    set target = null
endfunction

function Trig_Aku2_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )
    
    call DisableTrigger( GetTriggeringTrigger() )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "bsdl1" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bsdl1" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bsdl1" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bsdl1" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bsdl1" ) ), bosscast(10), true, function Aku2Cast )
endfunction

//===========================================================================
function InitTrig_Aku2 takes nothing returns nothing
    set gg_trg_Aku2 = CreateTrigger()
    call DisableTrigger( gg_trg_Aku2 )
    call TriggerRegisterVariableEvent( gg_trg_Aku2, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Aku2, Condition( function Trig_Aku2_Conditions ) )
    call TriggerAddAction( gg_trg_Aku2, function Trig_Aku2_Actions )
endfunction

