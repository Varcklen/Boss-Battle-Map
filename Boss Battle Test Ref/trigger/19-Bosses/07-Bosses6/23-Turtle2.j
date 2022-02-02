function Trig_Turtle2_Conditions takes nothing returns boolean
    return GetUnitTypeId( udg_DamageEventTarget ) == 'h01R' and GetUnitLifePercent(udg_DamageEventTarget) <= 90
endfunction

function Turtle2Cast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bstt2" ) )

    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        call dummyspawn( boss, 1, 'A13C', 0, 0 )
        call IssuePointOrderLoc( bj_lastCreatedUnit, "carrionswarm", PolarProjectionBJ(GetUnitLoc(boss), 50, ( GetUnitFacing(boss) + 90 )) )
        call dummyspawn( boss, 1, 'A13C', 0, 0 )
        call IssuePointOrderLoc( bj_lastCreatedUnit, "carrionswarm", PolarProjectionBJ(GetUnitLoc(boss), 50, ( GetUnitFacing(boss) - 90 )) )
    endif
    
    set boss = null
endfunction

function Trig_Turtle2_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )

    call DisableTrigger( GetTriggeringTrigger() )

    if LoadTimerHandle( udg_hash, id, StringHash( "bstt2" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bstt2" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bstt2" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bstt2" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bstt2" ) ), bosscast(7), true, function Turtle2Cast )
endfunction

//===========================================================================
function InitTrig_Turtle2 takes nothing returns nothing
    set gg_trg_Turtle2 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Turtle2 )
    call TriggerRegisterVariableEvent( gg_trg_Turtle2, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Turtle2, Condition( function Trig_Turtle2_Conditions ) )
    call TriggerAddAction( gg_trg_Turtle2, function Trig_Turtle2_Actions )
endfunction

