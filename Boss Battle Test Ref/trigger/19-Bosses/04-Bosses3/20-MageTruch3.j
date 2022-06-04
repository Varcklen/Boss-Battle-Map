function Trig_gg_trg_MageTruch3_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'n03L' and GetUnitLifePercent(udg_DamageEventTarget) <= 25
endfunction

function Trig_gg_trg_MageTruch3_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )

    call DisableTrigger( GetTriggeringTrigger() )
    
    call shield( udg_DamageEventTarget, udg_DamageEventTarget, 1000, 180 )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "bsmtr" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bsmtr" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bsmtr" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bsmtr" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bsmtr" ) ), bosscast(4), true, function MageTruch1Cast )
endfunction

//===========================================================================
function InitTrig_MageTruch3 takes nothing returns nothing
    set gg_trg_MageTruch3 = CreateTrigger()
    call DisableTrigger( gg_trg_MageTruch3 )
    call TriggerRegisterVariableEvent( gg_trg_MageTruch3, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_MageTruch3, Condition( function Trig_gg_trg_MageTruch3_Conditions ) )
    call TriggerAddAction( gg_trg_MageTruch3, function Trig_gg_trg_MageTruch3_Actions )
endfunction

