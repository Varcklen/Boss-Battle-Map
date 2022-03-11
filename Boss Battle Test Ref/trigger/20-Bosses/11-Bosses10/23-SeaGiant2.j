function Trig_SeaGiant2_Conditions takes nothing returns boolean
    return GetUnitTypeId( udg_DamageEventTarget ) == 'n00W' and GetUnitLifePercent(udg_DamageEventTarget) <= 80
endfunction

function Trig_SeaGiant2_Actions takes nothing returns nothing
    call DisableTrigger( GetTriggeringTrigger() )
    call UnitAddAbility( udg_DamageEventTarget, 'A0DG')
    call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\Human\\ControlMagic\\ControlMagicTarget.mdl", udg_DamageEventTarget, "overhead") )
endfunction

//===========================================================================
function InitTrig_SeaGiant2 takes nothing returns nothing
    set gg_trg_SeaGiant2 = CreateTrigger(  )
    call DisableTrigger( gg_trg_SeaGiant2 )
    call TriggerRegisterVariableEvent( gg_trg_SeaGiant2, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_SeaGiant2, Condition( function Trig_SeaGiant2_Conditions ) )
    call TriggerAddAction( gg_trg_SeaGiant2, function Trig_SeaGiant2_Actions )
endfunction

