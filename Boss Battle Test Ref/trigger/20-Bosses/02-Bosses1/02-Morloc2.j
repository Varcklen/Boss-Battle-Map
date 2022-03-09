function Trig_Morloc2_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'n005' and GetUnitLifePercent(udg_DamageEventTarget) <= 50.
endfunction

function Trig_Morloc2_Actions takes nothing returns nothing
    call DisableTrigger( GetTriggeringTrigger() )
    call SetUnitAnimation( udg_DamageEventTarget, "spell" )
    call DestroyEffect(AddSpecialEffectTarget( "Abilities\\Spells\\NightElf\\Taunt\\TauntCaster.mdl", udg_DamageEventTarget, "origin") )
    call UnitAddAbility( udg_DamageEventTarget, 'A03C' )
endfunction

//===========================================================================
function InitTrig_Morloc2 takes nothing returns nothing
    set gg_trg_Morloc2 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Morloc2 )
    call TriggerRegisterVariableEvent( gg_trg_Morloc2, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Morloc2, Condition( function Trig_Morloc2_Conditions ) )
    call TriggerAddAction( gg_trg_Morloc2, function Trig_Morloc2_Actions )
endfunction

