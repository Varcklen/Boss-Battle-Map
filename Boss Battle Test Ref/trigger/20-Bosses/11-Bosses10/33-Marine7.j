function Trig_Marine7_Conditions takes nothing returns boolean
    return GetUnitTypeId( udg_DamageEventTarget ) == 'n04N' and GetUnitLifePercent(udg_DamageEventTarget) <= 30
endfunction

function Trig_Marine7_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )

    call DisableTrigger( GetTriggeringTrigger() )
    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bsmr" ) ), bosscast(6), true, function Marine2Cast )
    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bsmr4" ) ), bosscast(4), true, function Marine3Cast )
    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bsmr7" ) ), bosscast(8), true, function Marine4Cast )
    
    call TransmissionFromUnitWithNameBJ( bj_FORCE_ALL_PLAYERS, udg_DamageEventTarget, GetUnitName(udg_DamageEventTarget), null, "Not again!", bj_TIMETYPE_SET, 3, false )
    call UnitAddAbility( udg_DamageEventTarget, 'A0SB' )
    call UnitAddAbility( udg_DamageEventTarget, 'A0SE' )
    call pausest( udg_DamageEventTarget, 1 )
    call SetUnitAnimation( udg_DamageEventTarget, "death" )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "bsmr8" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bsmr8" ), CreateTimer() )
    endif
    set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bsmr8" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bsmr8" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bsmr8" ) ), 5, false, function Marine5Cast )
    
    set id = GetHandleId( udg_DamageEventTarget )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "bsmr9" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bsmr9" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bsmr9" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bsmr9" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bsmr9" ) ), bosscast(0.5), true, function Marine5Boom )
endfunction

//===========================================================================
function InitTrig_Marine7 takes nothing returns nothing
    set gg_trg_Marine7 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Marine7 )
    call TriggerRegisterVariableEvent( gg_trg_Marine7, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Marine7, Condition( function Trig_Marine7_Conditions ) )
    call TriggerAddAction( gg_trg_Marine7, function Trig_Marine7_Actions )
endfunction

