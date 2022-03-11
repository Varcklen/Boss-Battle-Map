function Trig_MagnataurB_Conditions takes nothing returns boolean
    return GetLearnedSkill() == 'A0UF' or GetLearnedSkill() == 'A0VG' or GetLearnedSkill() == 'A0WJ'
endfunction

function Trig_MagnataurB_Actions takes nothing returns nothing
    if GetLearnedSkill() == 'A0UF' then
        call UnitRemoveAbility( GetLearningUnit(), 'A0BJ')
        call UnitRemoveAbility( GetLearningUnit(), 'B03M')
        call UnitAddAbility( GetLearningUnit(), 'A0BJ')
        call SetUnitAbilityLevel( GetLearningUnit(), 'A0BC', GetUnitAbilityLevel( GetLearningUnit(), GetLearnedSkill() ) )
    elseif GetLearnedSkill() == 'A0VG' then
        call UnitRemoveAbility( GetLearningUnit(), 'A0AV')
        call UnitRemoveAbility( GetLearningUnit(), 'B03N')
        call UnitAddAbility( GetLearningUnit(), 'A0AV')
        call SetUnitAbilityLevel( GetLearningUnit(), 'A0A8', GetUnitAbilityLevel( GetLearningUnit(), GetLearnedSkill() ) )
    else
        call UnitRemoveAbility( GetLearningUnit(), 'A0B3')
        call UnitRemoveAbility( GetLearningUnit(), 'B03P')
        call UnitAddAbility( GetLearningUnit(), 'A0B3')
        call SetUnitAbilityLevel( GetLearningUnit(), 'A0N6', GetUnitAbilityLevel( GetLearningUnit(), GetLearnedSkill() ) )
    endif
endfunction

//===========================================================================
function InitTrig_MagnataurB takes nothing returns nothing
    set gg_trg_MagnataurB = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_MagnataurB, EVENT_PLAYER_HERO_SKILL )
    call TriggerAddCondition( gg_trg_MagnataurB, Condition( function Trig_MagnataurB_Conditions ) )
    call TriggerAddAction( gg_trg_MagnataurB, function Trig_MagnataurB_Actions )
endfunction

