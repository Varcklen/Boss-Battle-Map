function Trig_Wolf1_Conditions takes nothing returns boolean
    return GetUnitTypeId( udg_DamageEventTarget ) == 'o009' and GetUnitLifePercent(udg_DamageEventTarget) <= 90
endfunction

function Trig_Wolf1_Actions takes nothing returns nothing
    local integer cyclA = 1

    call DisableTrigger( GetTriggeringTrigger() )
        loop
            exitwhen cyclA > 4
            set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( udg_DamageEventTarget ), 'o00A', GetUnitX( udg_DamageEventTarget ) + GetRandomReal( -120, 120 ), GetUnitY( udg_DamageEventTarget ) + GetRandomReal( -120, 120 ), GetRandomReal(0, 360) )
            call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Orc\\FeralSpirit\\feralspirittarget.mdl", bj_lastCreatedUnit, "origin") )
            call UnitApplyTimedLife( bj_lastCreatedUnit , 'BTLF', 15 )
            set cyclA = cyclA + 1
        endloop
endfunction

//===========================================================================
function InitTrig_Wolf1 takes nothing returns nothing
    set gg_trg_Wolf1 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Wolf1 )
    call TriggerRegisterVariableEvent( gg_trg_Wolf1, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Wolf1, Condition( function Trig_Wolf1_Conditions ) )
    call TriggerAddAction( gg_trg_Wolf1, function Trig_Wolf1_Actions )
endfunction

