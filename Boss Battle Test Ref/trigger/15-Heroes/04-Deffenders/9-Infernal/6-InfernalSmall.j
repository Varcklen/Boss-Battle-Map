function Trig_InfernalSmall_Conditions takes nothing returns boolean
    return GetUnitTypeId(GetDyingUnit()) == 'n02Y'
endfunction

function Trig_InfernalSmall_Actions takes nothing returns nothing
    set bj_lastCreatedItem = CreateItem('I0G8', GetUnitX( GetDyingUnit() ), GetUnitY( GetDyingUnit() ))
    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageDeathCaster.mdl", GetItemX( bj_lastCreatedItem ), GetItemY( bj_lastCreatedItem ) ) )
endfunction

//===========================================================================
function InitTrig_InfernalSmall takes nothing returns nothing
    set gg_trg_InfernalSmall = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_InfernalSmall, EVENT_PLAYER_UNIT_DEATH )
    call TriggerAddCondition( gg_trg_InfernalSmall, Condition( function Trig_InfernalSmall_Conditions ) )
    call TriggerAddAction( gg_trg_InfernalSmall, function Trig_InfernalSmall_Actions )
endfunction