function Trig_Wolf2_Conditions takes nothing returns boolean
    return GetUnitTypeId( udg_DamageEventTarget ) == 'o009' and GetUnitLifePercent(udg_DamageEventTarget) <= 75
endfunction

function Trig_Wolf2_Actions takes nothing returns nothing
    local integer cyclA = 1
    call DisableTrigger( GetTriggeringTrigger() )
    loop
        exitwhen cyclA > 2
        set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( udg_DamageEventTarget ), 'o00A', GetUnitX( udg_DamageEventTarget ) + GetRandomReal( -120, 120 ), GetUnitY( udg_DamageEventTarget ) + GetRandomReal( -120, 120 ), GetRandomReal(0, 360) )
        call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Orc\\FeralSpirit\\feralspirittarget.mdl", bj_lastCreatedUnit, "origin") )
        set cyclA = cyclA + 1
    endloop
endfunction

//===========================================================================
function InitTrig_Wolf2 takes nothing returns nothing
    set gg_trg_Wolf2 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Wolf2 )
    call TriggerRegisterVariableEvent( gg_trg_Wolf2, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Wolf2, Condition( function Trig_Wolf2_Conditions ) )
    call TriggerAddAction( gg_trg_Wolf2, function Trig_Wolf2_Actions )
endfunction

