function Trig_Bear2_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'n010' and GetUnitLifePercent(udg_DamageEventTarget) <= 40
endfunction

function Trig_Bear2_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )

    call DisableTrigger( GetTriggeringTrigger() )
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Human\\Thunderclap\\ThunderClapCaster.mdl", udg_DamageEventTarget, "origin") )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "bsbr" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bsbr" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bsbr" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bsbr" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bsbr" ) ), bosscast(7), true, function BearCast )
endfunction

//===========================================================================
function InitTrig_Bear2 takes nothing returns nothing
    set gg_trg_Bear2 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Bear2 )
    call TriggerRegisterVariableEvent( gg_trg_Bear2, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Bear2, Condition( function Trig_Bear2_Conditions ) )
    call TriggerAddAction( gg_trg_Bear2, function Trig_Bear2_Actions )
endfunction

