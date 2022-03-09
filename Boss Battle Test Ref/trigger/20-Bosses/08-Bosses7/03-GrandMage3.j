function Trig_GrandMage3_Conditions takes nothing returns boolean
    return GetUnitTypeId( udg_DamageEventTarget ) == 'h003' and GetUnitLifePercent(udg_DamageEventTarget) <= 60
endfunction

function GrandMage3Cast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bsgm2" ) )

    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        call dummyspawn( boss, 12, 'A0AD', 0, 0 )
        call IssuePointOrder( bj_lastCreatedUnit, "blizzard", GetUnitX( boss ) + GetRandomReal( -600, 600 ), GetUnitY( boss ) + GetRandomReal( -600, 600 ) )
    endif
endfunction

function Trig_GrandMage3_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )
    
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Weapons\\Bolt\\BoltImpact.mdl", udg_DamageEventTarget, "origin") )
    call DisableTrigger( GetTriggeringTrigger() )

    if LoadTimerHandle( udg_hash, id, StringHash( "bsgm2" ) ) == null then 
        call SaveTimerHandle( udg_hash, id, StringHash( "bsgm2" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bsgm2" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bsgm2" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bsgm2" ) ), bosscast(6), true, function GrandMage3Cast )
endfunction

//===========================================================================
function InitTrig_GrandMage3 takes nothing returns nothing
    set gg_trg_GrandMage3 = CreateTrigger(  )
    call DisableTrigger( gg_trg_GrandMage3 )
    call TriggerRegisterVariableEvent( gg_trg_GrandMage3, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_GrandMage3, Condition( function Trig_GrandMage3_Conditions ) )
    call TriggerAddAction( gg_trg_GrandMage3, function Trig_GrandMage3_Actions )
endfunction

