function Trig_Chief4_Conditions takes nothing returns boolean
    return GetUnitTypeId( udg_DamageEventTarget ) == 'h01X' and GetUnitLifePercent(udg_DamageEventTarget) <= 35
endfunction

function Trig_Chief4_Actions takes nothing returns nothing
    call DisableTrigger( GetTriggeringTrigger() )
    call UnitAddAbility( udg_DamageEventTarget, 'A16X' )
    call DestroyEffect(AddSpecialEffectTarget( "Abilities\\Spells\\Human\\Thunderclap\\ThunderClapCaster.mdl", udg_DamageEventTarget, "origin") )
endfunction

//===========================================================================
function InitTrig_Chief4 takes nothing returns nothing
    set gg_trg_Chief4 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Chief4 )
    call TriggerRegisterVariableEvent( gg_trg_Chief4, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Chief4, Condition( function Trig_Chief4_Conditions ) )
    call TriggerAddAction( gg_trg_Chief4, function Trig_Chief4_Actions )
endfunction

