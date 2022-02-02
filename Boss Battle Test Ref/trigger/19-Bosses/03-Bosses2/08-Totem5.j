function Trig_Totem5_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'o007' and GetUnitName(udg_DamageEventSource) != "dummy"
endfunction

function Trig_Totem5_Actions takes nothing returns nothing
    call DestroyEffect(AddSpecialEffectTarget( "Abilities\\Spells\\Undead\\DeathandDecay\\DeathandDecayDamage.mdl", udg_DamageEventSource, "chest") )
    call SetUnitState( udg_DamageEventSource, UNIT_STATE_LIFE, RMaxBJ(0, GetUnitState( udg_DamageEventSource, UNIT_STATE_LIFE ) - 10 ) ) 
endfunction

//===========================================================================
function InitTrig_Totem5 takes nothing returns nothing
    set gg_trg_Totem5 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Totem5 )
    call TriggerRegisterVariableEvent( gg_trg_Totem5, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Totem5, Condition( function Trig_Totem5_Conditions ) )
    call TriggerAddAction( gg_trg_Totem5, function Trig_Totem5_Actions )
endfunction

