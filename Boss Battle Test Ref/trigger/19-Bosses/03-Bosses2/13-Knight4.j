function Trig_Knight4_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'h000' and GetUnitLifePercent(udg_DamageEventTarget) <= 25
endfunction

function Trig_Knight4_Actions takes nothing returns nothing
    call DisableTrigger( GetTriggeringTrigger() )
    call SetUnitAbilityLevel(udg_DamageEventTarget, 'A03D', 4)
    call SetUnitAbilityLevel(udg_DamageEventTarget, 'A01E', 4)
    call SetUnitAnimation( udg_DamageEventTarget, "stand victory" )
    call DestroyEffect(AddSpecialEffectTarget( "Abilities\\Spells\\Human\\Thunderclap\\ThunderClapCaster.mdl", udg_DamageEventTarget, "origin") )
endfunction

//===========================================================================
function InitTrig_Knight4 takes nothing returns nothing
    set gg_trg_Knight4 = CreateTrigger()
    call DisableTrigger( gg_trg_Knight4 )
    call TriggerRegisterVariableEvent( gg_trg_Knight4, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Knight4, Condition( function Trig_Knight4_Conditions ) )
    call TriggerAddAction( gg_trg_Knight4, function Trig_Knight4_Actions )
endfunction

