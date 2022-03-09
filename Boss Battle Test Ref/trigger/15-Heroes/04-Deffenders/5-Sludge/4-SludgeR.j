function Trig_SludgeR_Conditions takes nothing returns boolean
    return GetLearnedSkill() == 'A0T8'
endfunction

function Trig_SludgeR_Actions takes nothing returns nothing
    if GetUnitAbilityLevel( GetLearningUnit(), 'A0T8') == 1 then
		call SetPlayerTechResearchedSwap( 'R004', 1, GetOwningPlayer(GetLearningUnit()) )
    elseif GetUnitAbilityLevel( GetLearningUnit(), 'A0T8') == 2 then
        call UnitAddAbility( GetLearningUnit(), 'A0S6')
	elseif GetUnitAbilityLevel( GetLearningUnit(), 'A0T8') == 3 then
        call UnitAddAbility( GetLearningUnit(), 'A0RW')
	elseif GetUnitAbilityLevel( GetLearningUnit(), 'A0T8') == 4 then
        call UnitAddAbility( GetLearningUnit(), 'A0SD')
	endif
endfunction

//===========================================================================
function InitTrig_SludgeR takes nothing returns nothing
    set gg_trg_SludgeR = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_SludgeR, EVENT_PLAYER_HERO_SKILL )
    call TriggerAddCondition( gg_trg_SludgeR, Condition( function Trig_SludgeR_Conditions ) )
    call TriggerAddAction( gg_trg_SludgeR, function Trig_SludgeR_Actions )
endfunction

