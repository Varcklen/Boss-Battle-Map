function Trig_Mirrors_Conditions takes nothing returns boolean
    return GetUnitTypeId(GetDyingUnit()) == 'n04P' or GetUnitTypeId(GetDyingUnit()) == 'e003'
endfunction

function Trig_Mirrors_Actions takes nothing returns nothing
    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageDeathCaster.mdl", GetUnitX( GetDyingUnit() ), GetUnitY( GetDyingUnit() ) ) )
    call ShowUnit( GetDyingUnit(), false)
endfunction

//===========================================================================
function InitTrig_Mirrors takes nothing returns nothing
    set gg_trg_Mirrors = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Mirrors, EVENT_PLAYER_UNIT_DEATH )
    call TriggerAddCondition( gg_trg_Mirrors, Condition( function Trig_Mirrors_Conditions ) )
    call TriggerAddAction( gg_trg_Mirrors, function Trig_Mirrors_Actions )
endfunction

