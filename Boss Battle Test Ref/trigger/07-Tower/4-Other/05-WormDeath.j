function Trig_WormDeath_Conditions takes nothing returns boolean
    return GetUnitTypeId(GetDyingUnit()) == 'n043'
endfunction

function Trig_WormDeath_Actions takes nothing returns nothing
    call CreateItem( 'III4', GetUnitX( GetDyingUnit() ), GetUnitY( GetDyingUnit() ) )
endfunction

//===========================================================================
function InitTrig_WormDeath takes nothing returns nothing
    set gg_trg_WormDeath = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_WormDeath, EVENT_PLAYER_UNIT_DEATH )
    call TriggerAddCondition( gg_trg_WormDeath, Condition( function Trig_WormDeath_Conditions ) )
    call TriggerAddAction( gg_trg_WormDeath, function Trig_WormDeath_Actions )
endfunction

