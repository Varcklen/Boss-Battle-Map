function Trig_War2_Conditions takes nothing returns boolean
    return GetUnitTypeId( udg_DamageEventTarget ) == 'o011' and GetUnitLifePercent(udg_DamageEventTarget) <= 90
endfunction

function Trig_War2_Actions takes nothing returns nothing
    local integer cyclA = 1

    call DisableTrigger( GetTriggeringTrigger() )
    loop
        exitwhen cyclA > 4
        if GetUnitState( udg_hero[cyclA], UNIT_STATE_LIFE) > 0.405 then
            set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( udg_DamageEventTarget ), 'n03T', GetUnitX( udg_DamageEventTarget ) + GetRandomReal(-400, 400), GetUnitY( udg_DamageEventTarget ) + GetRandomReal(-400, 400), GetRandomReal( 0, 360 ) )
            call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\NightElf\\BattleRoar\\RoarCaster.mdl", bj_lastCreatedUnit, "origin" ) )
        endif
        set cyclA = cyclA + 1
    endloop
endfunction

//===========================================================================
function InitTrig_War2 takes nothing returns nothing
    set gg_trg_War2 = CreateTrigger(  )
    call DisableTrigger( gg_trg_War2 )
    call TriggerRegisterVariableEvent( gg_trg_War2, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_War2, Condition( function Trig_War2_Conditions ) )
    call TriggerAddAction( gg_trg_War2, function Trig_War2_Actions )
endfunction

