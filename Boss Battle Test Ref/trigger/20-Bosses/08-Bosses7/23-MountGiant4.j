function Trig_MountGiant4_Conditions takes nothing returns boolean
    return GetUnitTypeId( udg_DamageEventTarget ) == 'e000' and GetUnitLifePercent(udg_DamageEventTarget) <= 60
endfunction

function Trig_MountGiant4_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )

    call DisableTrigger( GetTriggeringTrigger() )

    if LoadTimerHandle( udg_hash, id, StringHash( "bsmg1" ) ) == null then 
        call SaveTimerHandle( udg_hash, id, StringHash( "bsmg1" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bsmg1" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bsmg1" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bsmg1" ) ), bosscast(6), true, function MountGiant1Cast )
endfunction

//===========================================================================
function InitTrig_MountGiant4 takes nothing returns nothing
    set gg_trg_MountGiant4 = CreateTrigger(  )
    call DisableTrigger( gg_trg_MountGiant4 )
    call TriggerRegisterVariableEvent( gg_trg_MountGiant4, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_MountGiant4, Condition( function Trig_MountGiant4_Conditions ) )
    call TriggerAddAction( gg_trg_MountGiant4, function Trig_MountGiant4_Actions )
endfunction

