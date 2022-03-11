function Trig_Ent4_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'e006' and GetUnitLifePercent(udg_DamageEventTarget) <= 90
endfunction

function Ent4Cast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bsent" ) )
    local unit u = GroupPickRandomUnit( udg_otryad )
    
    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        call dummyspawn( boss, 1, 'A0K0', 0, 0 )
        call IssueTargetOrder( bj_lastCreatedUnit, "entanglingroots", u )
    endif
    
    set u = null
    set boss = null
endfunction 

function Trig_Ent4_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )

    call DisableTrigger( GetTriggeringTrigger() )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "bsent" ) ) == null then 
        call SaveTimerHandle( udg_hash, id, StringHash( "bsent" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bsent" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bsent" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bsent" ) ), bosscast(20), true, function Ent4Cast )
endfunction

//===========================================================================
function InitTrig_Ent4 takes nothing returns nothing
    set gg_trg_Ent4 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Ent4 )
    call TriggerRegisterVariableEvent( gg_trg_Ent4, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Ent4, Condition( function Trig_Ent4_Conditions ) )
    call TriggerAddAction( gg_trg_Ent4, function Trig_Ent4_Actions )
endfunction

