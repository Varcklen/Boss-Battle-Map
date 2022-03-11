function Trig_Woodo6_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'o000' and GetUnitLifePercent(udg_DamageEventTarget) <= 10
endfunction

function Trig_Woodo6_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )

    call DisableTrigger( GetTriggeringTrigger() )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "bswd" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bswd" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bswd" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bswd" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bswd" ) ), bosscast(1.5), true, function WoodoCast )
endfunction

//===========================================================================
function InitTrig_Woodo6 takes nothing returns nothing
    set gg_trg_Woodo6 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Woodo6 )
    call TriggerRegisterVariableEvent( gg_trg_Woodo6, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Woodo6, Condition( function Trig_Woodo6_Conditions ) )
    call TriggerAddAction( gg_trg_Woodo6, function Trig_Woodo6_Actions )
endfunction

