function Trig_WandererEHP_Conditions takes nothing returns boolean
    return GetLearnedSkill() == 'A0LD'
endfunction

function Trig_WandererEHP_Actions takes nothing returns nothing
	if GetUnitAbilityLevel( GetLearningUnit(), 'A0LD') == 1 then
        call BlzSetUnitMaxHP( GetLearningUnit(), BlzGetUnitMaxHP(GetLearningUnit()) + 50 )
	endif
    call BlzSetUnitMaxHP( GetLearningUnit(), BlzGetUnitMaxHP(GetLearningUnit()) + 30 )
endfunction

//===========================================================================
function InitTrig_WandererEHP takes nothing returns nothing
    set gg_trg_WandererEHP = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_WandererEHP, EVENT_PLAYER_HERO_SKILL )
    call TriggerAddCondition( gg_trg_WandererEHP, Condition( function Trig_WandererEHP_Conditions ) )
    call TriggerAddAction( gg_trg_WandererEHP, function Trig_WandererEHP_Actions )
endfunction

