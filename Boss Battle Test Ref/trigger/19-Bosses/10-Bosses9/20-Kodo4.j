function Trig_Kodo4_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'h01K' and GetUnitLifePercent(udg_DamageEventTarget) <= 40
endfunction

function Trig_Kodo4_Actions takes nothing returns nothing
    call DisableTrigger( GetTriggeringTrigger() )
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\NightElf\\BattleRoar\\RoarCaster.mdl", udg_DamageEventTarget, "origin") )
    call UnitAddAbility( udg_DamageEventTarget, 'A0WC' )
endfunction

//===========================================================================
function InitTrig_Kodo4 takes nothing returns nothing
    set gg_trg_Kodo4 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Kodo4 )
    call TriggerRegisterVariableEvent( gg_trg_Kodo4, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Kodo4, Condition( function Trig_Kodo4_Conditions ) )
    call TriggerAddAction( gg_trg_Kodo4, function Trig_Kodo4_Actions )
endfunction

