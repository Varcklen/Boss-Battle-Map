function Trig_PhoenixEgg_Conditions takes nothing returns boolean
    return inv(GetDyingUnit(), 'I05U') > 0 and GetUnitAbilityLevel( GetDyingUnit(), 'B047' ) == 0 and not(LoadBoolean( udg_hash, GetHandleId( GetDyingUnit() ), StringHash( "pheg" ) ) ) and combat( GetDyingUnit(), false, 0 ) and not( IsUnitInGroup(GetDyingUnit(), udg_Return) ) and udg_Heroes_Ressurect_Battle <= 0 and GetPlayerSlotState(GetOwningPlayer(GetDyingUnit())) == PLAYER_SLOT_STATE_PLAYING
endfunction

function Trig_PhoenixEgg_Actions takes nothing returns nothing
    set bj_lastCreatedUnit = CreateUnit( Player(PLAYER_NEUTRAL_AGGRESSIVE), 'h012', GetUnitX( GetDyingUnit() ), GetUnitY( GetDyingUnit() ), 270 )
    call spectime("Abilities\\Spells\\Other\\BreathOfFire\\BreathOfFireMissile.mdl", GetUnitX( GetDyingUnit() ), GetUnitY( GetDyingUnit() ), 1 )
    call SaveUnitHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "fnx" ), GetDyingUnit() )
endfunction

//===========================================================================
function InitTrig_PhoenixEgg takes nothing returns nothing
    set gg_trg_PhoenixEgg = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_PhoenixEgg, EVENT_PLAYER_UNIT_DEATH )
    call TriggerAddCondition( gg_trg_PhoenixEgg, Condition( function Trig_PhoenixEgg_Conditions ) )
    call TriggerAddAction( gg_trg_PhoenixEgg, function Trig_PhoenixEgg_Actions )
endfunction

