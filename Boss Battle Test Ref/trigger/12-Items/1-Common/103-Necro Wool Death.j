function Trig_Necro_Wool_Death_Conditions takes nothing returns boolean
    return IsUnitInGroup(GetDyingUnit(), udg_NecroWool)
endfunction

function Trig_Necro_Wool_Death_Actions takes nothing returns nothing
    call GroupRemoveUnit( udg_NecroWool, GetDyingUnit() )
    call UnitRemoveAbility( GetDyingUnit(), 'A0YO')
    call UnitRemoveAbility( GetDyingUnit(), 'B042')
    set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( GetDyingUnit() ), ID_SHEEP, GetUnitX( GetDyingUnit() ) + GetRandomReal( -200, 200 ), GetUnitY( GetDyingUnit() ) + GetRandomReal( -200, 200 ), GetRandomReal( 0, 360 ) )
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Human\\Polymorph\\PolyMorphDoneGround.mdl", bj_lastCreatedUnit, "origin" ) )
    call UnitApplyTimedLife( bj_lastCreatedUnit, 'BTLF', 30 )
endfunction

//===========================================================================
function InitTrig_Necro_Wool_Death takes nothing returns nothing
    set gg_trg_Necro_Wool_Death = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Necro_Wool_Death, EVENT_PLAYER_UNIT_DEATH )
    call TriggerAddCondition( gg_trg_Necro_Wool_Death, Condition( function Trig_Necro_Wool_Death_Conditions ) )
    call TriggerAddAction( gg_trg_Necro_Wool_Death, function Trig_Necro_Wool_Death_Actions )
endfunction

