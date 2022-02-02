function Trig_MinP_Conditions takes nothing returns boolean
    return GetLearnedSkill() == 'A083'
endfunction

function Trig_MinP_Actions takes nothing returns nothing
	if GetUnitAbilityLevel( GetLearningUnit(), 'A083') == 1 then
        call statst( GetLearningUnit(), 2, 1, 1, 0, false )
	endif
    call statst( GetLearningUnit(), 4, 2, 2, 0, false )
endfunction

//===========================================================================
function InitTrig_MinP takes nothing returns nothing
    set gg_trg_MinP = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_MinP, EVENT_PLAYER_HERO_SKILL )
    call TriggerAddCondition( gg_trg_MinP, Condition( function Trig_MinP_Conditions ) )
    call TriggerAddAction( gg_trg_MinP, function Trig_MinP_Actions )
endfunction

