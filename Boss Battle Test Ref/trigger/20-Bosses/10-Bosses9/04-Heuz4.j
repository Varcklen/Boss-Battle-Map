function Trig_Heuz4_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'e008' and GetUnitLifePercent(udg_DamageEventTarget) <= 25
endfunction

function Trig_Heuz4_Actions takes nothing returns nothing
    call DisableTrigger( GetTriggeringTrigger() )
    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Undead\\DeathPact\\DeathPactTarget.mdl", GetUnitX( udg_DamageEventTarget ), GetUnitY( udg_DamageEventTarget ) ) )
    call UnitAddAbility( udg_DamageEventTarget, 'A05O')
endfunction

//===========================================================================
function InitTrig_Heuz4 takes nothing returns nothing
    set gg_trg_Heuz4 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Heuz4 )
    call TriggerRegisterVariableEvent( gg_trg_Heuz4, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Heuz4, Condition( function Trig_Heuz4_Conditions ) )
    call TriggerAddAction( gg_trg_Heuz4, function Trig_Heuz4_Actions )
endfunction

