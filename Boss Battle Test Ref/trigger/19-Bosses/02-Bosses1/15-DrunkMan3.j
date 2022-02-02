//TESH.scrollpos=0
//TESH.alwaysfold=0
function Trig_DrunkMan3_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'n02U' and GetUnitLifePercent(udg_DamageEventTarget) <= 25
endfunction

function Trig_DrunkMan3_Actions takes nothing returns nothing
    call DisableTrigger( GetTriggeringTrigger() )
    call DestroyEffect(AddSpecialEffectTarget( "Abilities\\Spells\\NightElf\\Taunt\\TauntCaster.mdl", udg_DamageEventTarget, "origin") )
    call UnitAddAbility( udg_DamageEventTarget, 'A13Q' )
endfunction

//===========================================================================
function InitTrig_DrunkMan3 takes nothing returns nothing
    set gg_trg_DrunkMan3 = CreateTrigger(  )
    call DisableTrigger( gg_trg_DrunkMan3 )
    call TriggerRegisterVariableEvent( gg_trg_DrunkMan3, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_DrunkMan3, Condition( function Trig_DrunkMan3_Conditions ) )
    call TriggerAddAction( gg_trg_DrunkMan3, function Trig_DrunkMan3_Actions )
endfunction

