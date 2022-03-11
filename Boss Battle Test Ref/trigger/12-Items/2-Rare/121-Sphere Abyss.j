function Trig_Sphere_Abyss_Conditions takes nothing returns boolean
    return GetUnitAbilityLevel(GetDyingUnit(), 'B047') == 0 and inv(GetDyingUnit(), 'I0AQ') > 0 and udg_Heroes_Amount > 1 and udg_number[GetPlayerId(GetOwningPlayer(GetDyingUnit())) + 1 + 78] == 0 and combat( GetDyingUnit(), false, 0 ) and not( udg_fightmod[3] ) and not( IsUnitInGroup(GetDyingUnit(), udg_Return) ) and udg_Heroes_Ressurect_Battle <= 0 and GetPlayerSlotState(GetOwningPlayer(GetDyingUnit())) == PLAYER_SLOT_STATE_PLAYING
endfunction 

function Trig_Sphere_Abyss_Actions takes nothing returns nothing
    set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( GetDyingUnit() ), 'h01M', GetUnitX( GetDyingUnit() ), GetUnitY( GetDyingUnit() ), 270 )
    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Other\\HowlOfTerror\\HowlCaster.mdl", GetUnitX( GetDyingUnit() ), GetUnitY( GetDyingUnit() ) ) )
    call SaveInteger( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "sfab" ), GetPlayerId(GetOwningPlayer(GetDyingUnit())) + 1 )
    call SaveUnitHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "sfab" ), bj_lastCreatedUnit )
endfunction

//===========================================================================
function InitTrig_Sphere_Abyss takes nothing returns nothing
    set gg_trg_Sphere_Abyss = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Sphere_Abyss, EVENT_PLAYER_UNIT_DEATH )
    call TriggerAddCondition( gg_trg_Sphere_Abyss, Condition( function Trig_Sphere_Abyss_Conditions ) )
    call TriggerAddAction( gg_trg_Sphere_Abyss, function Trig_Sphere_Abyss_Actions )
endfunction

