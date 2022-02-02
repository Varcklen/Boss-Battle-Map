function Trig_Money_BagE_Conditions takes nothing returns boolean
    return GetLearnedSkill() == 'A17W'
endfunction

function Trig_Money_BagE_Actions takes nothing returns nothing
    call UnitAddAbility( GetLearningUnit(), 'A17X')
    call SetUnitAbilityLevel(GetLearningUnit(), 'A17X', GetUnitAbilityLevel(GetLearningUnit(), 'A17W') )
endfunction

//===========================================================================
function InitTrig_Money_BagE takes nothing returns nothing
    set gg_trg_Money_BagE = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Money_BagE, EVENT_PLAYER_HERO_SKILL )
    call TriggerAddCondition( gg_trg_Money_BagE, Condition( function Trig_Money_BagE_Conditions ) )
    call TriggerAddAction( gg_trg_Money_BagE, function Trig_Money_BagE_Actions )
endfunction