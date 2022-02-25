function Trig_Yoric_Skull_Death_Conditions takes nothing returns boolean
    return IsUnitInGroup(GetDyingUnit(), udg_YoricSkull) and not( IsUnitType( GetDyingUnit(), UNIT_TYPE_HERO) )
endfunction

function Trig_Yoric_Skull_Death_Actions takes nothing returns nothing
    call GroupRemoveUnit( udg_YoricSkull, GetDyingUnit() )
    call UnitRemoveAbility( GetDyingUnit(), 'A0YJ')
    call UnitRemoveAbility( GetDyingUnit(), 'B041')
    set bj_lastCreatedUnit = CreateUnitCopy( GetDyingUnit(), GetUnitX( GetDyingUnit() ), GetUnitY( GetDyingUnit() ), GetUnitFacing(GetDyingUnit()) )
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Undead\\AnimateDead\\AnimateDeadTarget.mdl", bj_lastCreatedUnit, "origin" ) )
    call UnitApplyTimedLife( bj_lastCreatedUnit, 'BTLF', 20 )
endfunction

//===========================================================================
function InitTrig_Yoric_Skull_Death takes nothing returns nothing
    set gg_trg_Yoric_Skull_Death = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Yoric_Skull_Death, EVENT_PLAYER_UNIT_DEATH )
    call TriggerAddCondition( gg_trg_Yoric_Skull_Death, Condition( function Trig_Yoric_Skull_Death_Conditions ) )
    call TriggerAddAction( gg_trg_Yoric_Skull_Death, function Trig_Yoric_Skull_Death_Actions )
endfunction

