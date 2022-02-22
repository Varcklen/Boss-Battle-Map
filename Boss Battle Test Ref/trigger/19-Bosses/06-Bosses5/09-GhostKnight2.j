function Trig_GhostKnight2_Conditions takes nothing returns boolean
    return GetUnitTypeId( udg_DamageEventTarget ) == 'n008' and GetUnitLifePercent(udg_DamageEventTarget) <= 50
endfunction

function Trig_GhostKnight2_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )

    call DisableTrigger( GetTriggeringTrigger() )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "bsgk1" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bsgk1" ), CreateTimer() )
    endif
    set id = GetHandleId( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bsgk1" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bsgk1" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bsgk1" ) ), bosscast(3), true, function GhostKnightCast1 )
endfunction

//===========================================================================
function InitTrig_GhostKnight2 takes nothing returns nothing
    set gg_trg_GhostKnight2 = CreateTrigger(  )
    call DisableTrigger( gg_trg_GhostKnight2 )
    call TriggerRegisterVariableEvent( gg_trg_GhostKnight2, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_GhostKnight2, Condition( function Trig_GhostKnight2_Conditions ) )
    call TriggerAddAction( gg_trg_GhostKnight2, function Trig_GhostKnight2_Actions )
endfunction

