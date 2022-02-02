function Trig_Soulfiend3_Conditions takes nothing returns boolean
    return GetUnitTypeId( udg_DamageEventTarget ) == 'n04F' and GetUnitLifePercent(udg_DamageEventTarget) <= 50
endfunction

function Trig_Soulfiend3_Actions takes nothing returns nothing
    call DisableTrigger( GetTriggeringTrigger() )
    call Soulfiend2_CastCurse()
endfunction

//===========================================================================
function InitTrig_Soulfiend3 takes nothing returns nothing
    set gg_trg_Soulfiend3 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Soulfiend3 )
    call TriggerRegisterVariableEvent( gg_trg_Soulfiend3, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Soulfiend3, Condition( function Trig_Soulfiend3_Conditions ) )
    call TriggerAddAction( gg_trg_Soulfiend3, function Trig_Soulfiend3_Actions )
endfunction

