function Trig_Aku6_Conditions takes nothing returns boolean
    return GetUnitTypeId( udg_DamageEventTarget ) == 'n04O' and GetUnitLifePercent(udg_DamageEventTarget) <= 25
endfunction

function Trig_Aku6_Actions takes nothing returns nothing
    call DisableTrigger( GetTriggeringTrigger() )
    
    set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( udg_DamageEventTarget ), 'n04P', GetUnitX( udg_DamageEventTarget ) + GetRandomReal( -120, 120 ), GetUnitY( udg_DamageEventTarget ) + GetRandomReal( -120, 120 ), GetRandomReal(0, 360) )
    call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageCaster.mdl", bj_lastCreatedUnit, "origin") )
    call UnitApplyTimedLife( bj_lastCreatedUnit , 'BTLF', 25 )
    call SetUnitState(bj_lastCreatedUnit, UNIT_STATE_LIFE, GetUnitState(udg_DamageEventTarget, UNIT_STATE_LIFE))
    call UnitAddAbility( bj_lastCreatedUnit, 'A03O' )
    call IssueImmediateOrder( bj_lastCreatedUnit, "whirlwind" )
endfunction

//===========================================================================
function InitTrig_Aku6 takes nothing returns nothing
    set gg_trg_Aku6 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Aku6 )
    call TriggerRegisterVariableEvent( gg_trg_Aku6, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Aku6, Condition( function Trig_Aku6_Conditions ) )
    call TriggerAddAction( gg_trg_Aku6, function Trig_Aku6_Actions )
endfunction

