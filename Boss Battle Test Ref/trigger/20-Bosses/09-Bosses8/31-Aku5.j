function Trig_Aku5_Conditions takes nothing returns boolean
    return GetUnitTypeId( udg_DamageEventTarget ) == 'n04O' and GetUnitLifePercent(udg_DamageEventTarget) <= 50
endfunction

function Trig_Aku5_Actions takes nothing returns nothing
    local integer cyclA = 1

    call DisableTrigger( GetTriggeringTrigger() )
    call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageCaster.mdl", udg_DamageEventTarget, "origin") )
    loop
        exitwhen cyclA > 4
        if GetUnitState( udg_hero[cyclA], UNIT_STATE_LIFE) > 0.405 then
            set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( udg_DamageEventTarget ), 'n04P', GetUnitX( udg_hero[cyclA] ) + GetRandomReal( -120, 120 ), GetUnitY( udg_hero[cyclA] ) + GetRandomReal( -120, 120 ), GetRandomReal(0, 360) )
            call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageCaster.mdl", bj_lastCreatedUnit, "origin") )
            call UnitApplyTimedLife( bj_lastCreatedUnit , 'BTLF', 15 )
            call SetUnitState(bj_lastCreatedUnit, UNIT_STATE_LIFE, GetUnitState(udg_DamageEventTarget, UNIT_STATE_LIFE))
            call IssueTargetOrder( bj_lastCreatedUnit , "attack", udg_hero[cyclA] )
        endif
        set cyclA = cyclA + 1
    endloop
endfunction

//===========================================================================
function InitTrig_Aku5 takes nothing returns nothing
    set gg_trg_Aku5 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Aku5 )
    call TriggerRegisterVariableEvent( gg_trg_Aku5, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Aku5, Condition( function Trig_Aku5_Conditions ) )
    call TriggerAddAction( gg_trg_Aku5, function Trig_Aku5_Actions )
endfunction

