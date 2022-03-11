function Trig_Thief3_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'h015' and GetUnitLifePercent(udg_DamageEventTarget) <= 25 and GetOwningPlayer(udg_DamageEventTarget) == Player(10)
endfunction

function Trig_Thief3_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )

    call DisableTrigger( GetTriggeringTrigger() )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "bsth2" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bsth2" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bsth2" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bsth2" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bsth2" ) ), bosscast(3), true, function Thief2Cast )
endfunction

//===========================================================================
function InitTrig_Thief3 takes nothing returns nothing
    set gg_trg_Thief3 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Thief3 )
    call TriggerRegisterVariableEvent( gg_trg_Thief3, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Thief3, Condition( function Trig_Thief3_Conditions ) )
    call TriggerAddAction( gg_trg_Thief3, function Trig_Thief3_Actions )
endfunction

