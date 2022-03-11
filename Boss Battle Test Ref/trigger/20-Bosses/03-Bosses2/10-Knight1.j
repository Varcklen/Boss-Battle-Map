function Trig_Knight1_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'h000'
endfunction

function Trig_Knight1_Actions takes nothing returns nothing
    call DisableTrigger( GetTriggeringTrigger() )
    call UnitAddAbility( udg_DamageEventTarget, 'A01C' )
    call DestroyEffect(AddSpecialEffectTarget( "Abilities\\Spells\\Human\\Thunderclap\\ThunderClapCaster.mdl", udg_DamageEventTarget, "origin") )
endfunction

//===========================================================================
function InitTrig_Knight1 takes nothing returns nothing
    set gg_trg_Knight1 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Knight1 )
    call TriggerRegisterVariableEvent( gg_trg_Knight1, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Knight1, Condition( function Trig_Knight1_Conditions ) )
    call TriggerAddAction( gg_trg_Knight1, function Trig_Knight1_Actions )
endfunction

