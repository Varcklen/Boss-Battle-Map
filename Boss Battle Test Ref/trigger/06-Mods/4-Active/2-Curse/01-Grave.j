function Trig_Grave_Conditions takes nothing returns boolean
    return IsUnitInGroup(GetDyingUnit(), udg_heroinfo) and not( udg_fightmod[3] ) and combat( GetDyingUnit(), false, 0 )
endfunction

function Trig_Grave_Actions takes nothing returns nothing
    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Items\\AIso\\AIsoTarget.mdl", GetUnitX( GetDyingUnit() ), GetUnitY( GetDyingUnit() ) ) )
    call SetPlayerState( GetOwningPlayer( GetDyingUnit() ), PLAYER_STATE_RESOURCE_GOLD, IMaxBJ( 0, GetPlayerState( GetOwningPlayer( GetDyingUnit() ), PLAYER_STATE_RESOURCE_GOLD) - 75 ) )
endfunction

//===========================================================================
function InitTrig_Grave takes nothing returns nothing
    set gg_trg_Grave = CreateTrigger(  )
    call DisableTrigger( gg_trg_Grave )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Grave, EVENT_PLAYER_UNIT_DEATH )
    call TriggerAddCondition( gg_trg_Grave, Condition( function Trig_Grave_Conditions ) )
    call TriggerAddAction( gg_trg_Grave, function Trig_Grave_Actions )
endfunction

