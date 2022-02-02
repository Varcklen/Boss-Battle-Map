function Trig_Scatter_Conditions takes nothing returns boolean
    return GetOwningPlayer(GetDyingUnit()) == Player(10) and GetUnitName(GetDyingUnit()) != "dummy"
endfunction

function Trig_Scatter_Actions takes nothing returns nothing
    call GroupAoE( GetDyingUnit(), null, GetUnitX( GetDyingUnit() ), GetUnitY( GetDyingUnit() ), 35, 300, "enemy", "war3mapImported\\ArcaneExplosion.mdx", "" )
endfunction

//===========================================================================
function InitTrig_Scatter takes nothing returns nothing
    set gg_trg_Scatter = CreateTrigger(  )
    call DisableTrigger( gg_trg_Scatter )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Scatter, EVENT_PLAYER_UNIT_DEATH )
    call TriggerAddCondition( gg_trg_Scatter, Condition( function Trig_Scatter_Conditions ) )
    call TriggerAddAction( gg_trg_Scatter, function Trig_Scatter_Actions )
endfunction

