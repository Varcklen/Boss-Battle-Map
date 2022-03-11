function Trig_Pyromant2_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'h00Z' and GetUnitLifePercent(udg_DamageEventTarget) <= 60
endfunction

function Pyro2Cast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local real r = LoadReal( udg_hash, id, StringHash( "bspr3" ) )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bspr3" ) )
    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "bspr3f" ) )
    local real x
    local real y
    
    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call RemoveUnit( dummy )
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        set x = GetUnitX( boss ) + 500 * Cos( r * bj_DEGTORAD)
        set y = GetUnitY( boss ) + 500 * Sin( r * bj_DEGTORAD)
        call SaveReal( udg_hash, id, StringHash( "bspr3" ), r + 5 )
        call SetUnitPosition( dummy, x, y )
        call SetUnitFacing( dummy, 90 + r )
    endif
    
    set boss = null
    set dummy = null
endfunction

function Trig_Pyromant2_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )

    call DisableTrigger( GetTriggeringTrigger() )
    set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( udg_DamageEventTarget ), 'u01L', GetUnitX( udg_DamageEventTarget ), GetUnitY( udg_DamageEventTarget ), GetUnitFacing(udg_DamageEventTarget) )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "bspr3" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bspr3" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bspr3" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bspr3" ), udg_DamageEventTarget )
    call SaveUnitHandle( udg_hash, id, StringHash( "bspr3f" ), bj_lastCreatedUnit )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bspr3" ) ), 0.03, true, function Pyro2Cast )
endfunction

//===========================================================================
function InitTrig_Pyromant2 takes nothing returns nothing
    set gg_trg_Pyromant2 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Pyromant2 )
    call TriggerRegisterVariableEvent( gg_trg_Pyromant2, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Pyromant2, Condition( function Trig_Pyromant2_Conditions ) )
    call TriggerAddAction( gg_trg_Pyromant2, function Trig_Pyromant2_Actions )
endfunction

