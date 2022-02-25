function Trig_GhostKnight3_Conditions takes nothing returns boolean
    return GetUnitTypeId( udg_DamageEventTarget ) == 'n008' and GetUnitLifePercent(udg_DamageEventTarget) <= 25
endfunction

function Trig_GhostKnight3_Actions takes nothing returns nothing
    call DisableTrigger( GetTriggeringTrigger() )
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Undead\\DarkRitual\\DarkRitualTarget.mdl", udg_DamageEventTarget, "origin") )
    call UnitAddAbility( udg_DamageEventTarget, 'A0M6' )
    call UnitAddAbility( udg_DamageEventTarget, 'A01T' )
endfunction

//===========================================================================
function InitTrig_GhostKnight3 takes nothing returns nothing
    set gg_trg_GhostKnight3 = CreateTrigger(  )
    call DisableTrigger( gg_trg_GhostKnight3 )
    call TriggerRegisterVariableEvent( gg_trg_GhostKnight3, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_GhostKnight3, Condition( function Trig_GhostKnight3_Conditions ) )
    call TriggerAddAction( gg_trg_GhostKnight3, function Trig_GhostKnight3_Actions )
endfunction

