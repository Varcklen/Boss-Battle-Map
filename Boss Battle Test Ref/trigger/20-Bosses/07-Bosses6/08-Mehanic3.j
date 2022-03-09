function Trig_Mehanic3_Conditions takes nothing returns boolean
    return ( GetUnitTypeId( udg_DamageEventTarget ) == 'h010' ) and GetUnitLifePercent(udg_DamageEventTarget) <= 50
endfunction

function Mehanic1Cast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bsmc1" ) )
    local unit target = randomtarget( boss, 600, "enemy", "", "", "", "" )
            
    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    elseif target != null then
        call IssuePointOrder( boss, "clusterrockets", GetUnitX( target ), GetUnitY( target ) )
    endif
    
    set boss = null
    set target = null
endfunction

function Trig_Mehanic3_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )

    call DisableTrigger( GetTriggeringTrigger() )
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Other\\Volcano\\VolcanoDeath.mdl", udg_DamageEventTarget, "origin") )
    call UnitAddAbility(udg_DamageEventTarget, 'A0K2')
    
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bsmc" ) ), bosscast(7), true, function MehanicCast )

    set id = GetHandleId( udg_DamageEventTarget )
    if LoadTimerHandle( udg_hash, id, StringHash( "bsmc1" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bsmc1" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bsmc1" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bsmc1" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bsmc1" ) ), bosscast(5), true, function Mehanic1Cast )
endfunction

//===========================================================================
function InitTrig_Mehanic3 takes nothing returns nothing
    set gg_trg_Mehanic3 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Mehanic3 )
    call TriggerRegisterVariableEvent( gg_trg_Mehanic3, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Mehanic3, Condition( function Trig_Mehanic3_Conditions ) )
    call TriggerAddAction( gg_trg_Mehanic3, function Trig_Mehanic3_Actions )
endfunction

