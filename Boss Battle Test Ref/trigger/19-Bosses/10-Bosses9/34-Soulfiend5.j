function Trig_Soulfiend5_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'n04F' and GetUnitLifePercent(udg_DamageEventTarget) <= 20
endfunction

function Trig_Soulfiend5_Actions takes nothing returns nothing
    call DestroyEffect( AddSpecialEffect( "CallOfAggression.mdx", GetUnitX( udg_DamageEventTarget ), GetUnitY( udg_DamageEventTarget ) ) )
    call DisableTrigger( GetTriggeringTrigger() )
    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bssf1" ) ), bosscast(5), true, function Soulfiend1Cast )
endfunction

//===========================================================================
function InitTrig_Soulfiend5 takes nothing returns nothing
    set gg_trg_Soulfiend5 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Soulfiend5 )
    call TriggerRegisterVariableEvent( gg_trg_Soulfiend5, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Soulfiend5, Condition( function Trig_Soulfiend5_Conditions ) )
    call TriggerAddAction( gg_trg_Soulfiend5, function Trig_Soulfiend5_Actions )
endfunction

