function Trig_Soulfiend4_Conditions takes nothing returns boolean
    return GetUnitTypeId( udg_DamageEventTarget ) == 'n04F' and GetUnitLifePercent(udg_DamageEventTarget) <= 30
endfunction

function Trig_Soulfiend4_Actions takes nothing returns nothing
    call DisableTrigger( GetTriggeringTrigger() )
    call Soulfiend2_CastCurse()
endfunction

//===========================================================================
function InitTrig_Soulfiend4 takes nothing returns nothing
    set gg_trg_Soulfiend4 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Soulfiend4 )
    call TriggerRegisterVariableEvent( gg_trg_Soulfiend4, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Soulfiend4, Condition( function Trig_Soulfiend4_Conditions ) )
    call TriggerAddAction( gg_trg_Soulfiend4, function Trig_Soulfiend4_Actions )
endfunction

