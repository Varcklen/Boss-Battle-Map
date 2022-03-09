function Trig_MiracleBrewP_Conditions takes nothing returns boolean
    return GetLearnedSkill() == 'A0DC'
endfunction

function Trig_MiracleBrewP_Actions takes nothing returns nothing
    local integer i = GetPlayerId( GetOwningPlayer( GetLearningUnit() ) ) + 1
    call SpellPotion(i, 15)
endfunction

//===========================================================================
function InitTrig_MiracleBrewP takes nothing returns nothing
    set gg_trg_MiracleBrewP = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_MiracleBrewP, EVENT_PLAYER_HERO_SKILL )
    call TriggerAddCondition( gg_trg_MiracleBrewP, Condition( function Trig_MiracleBrewP_Conditions ) )
    call TriggerAddAction( gg_trg_MiracleBrewP, function Trig_MiracleBrewP_Actions )
endfunction