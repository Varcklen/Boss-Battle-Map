function Trig_GrandMage1_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'h003'
endfunction

function GrandMageCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bsgm" ) )

    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( boss ), 'u016', GetUnitX( boss ) + GetRandomReal( -300, 300 ), GetUnitY( boss ) + GetRandomReal( -300, 300 ), GetRandomReal( 0, 360 ) )
        call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Human\\ThunderClap\\ThunderClapCaster.mdl", bj_lastCreatedUnit, "origin") )
    endif
    
    set boss = null
endfunction

function Trig_GrandMage1_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )
    
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Weapons\\Bolt\\BoltImpact.mdl", udg_DamageEventTarget, "origin") )
    call DisableTrigger( GetTriggeringTrigger() )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "bsgm" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bsgm" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bsgm" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bsgm" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bsgm" ) ), bosscast(10), true, function GrandMageCast )
endfunction

//===========================================================================
function InitTrig_GrandMage1 takes nothing returns nothing
    set gg_trg_GrandMage1 = CreateTrigger(  )
    call DisableTrigger( gg_trg_GrandMage1 )
    call TriggerRegisterVariableEvent( gg_trg_GrandMage1, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_GrandMage1, Condition( function Trig_GrandMage1_Conditions ) )
    call TriggerAddAction( gg_trg_GrandMage1, function Trig_GrandMage1_Actions )
endfunction

