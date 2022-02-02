function Trig_War4_Conditions takes nothing returns boolean
    return GetUnitTypeId( udg_DamageEventTarget ) == 'o011' and GetUnitLifePercent(udg_DamageEventTarget) <= 50
endfunction

function Trig_War4_Actions takes nothing returns nothing
    call DisableTrigger( GetTriggeringTrigger() )
    set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( udg_DamageEventTarget ), 'n03U', GetUnitX( udg_DamageEventTarget ) + GetRandomReal(-400, 400), GetUnitY( udg_DamageEventTarget ) + GetRandomReal(-400, 400), GetRandomReal( 0, 360 ) )
    call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\NightElf\\BattleRoar\\RoarCaster.mdl", bj_lastCreatedUnit, "origin" ) )
endfunction

//===========================================================================
function InitTrig_War4 takes nothing returns nothing
    set gg_trg_War4 = CreateTrigger(  )
    call DisableTrigger( gg_trg_War4 )
    call TriggerRegisterVariableEvent( gg_trg_War4, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_War4, Condition( function Trig_War4_Conditions ) )
    call TriggerAddAction( gg_trg_War4, function Trig_War4_Actions )
endfunction

