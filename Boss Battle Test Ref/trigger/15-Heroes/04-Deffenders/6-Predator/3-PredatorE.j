function Trig_PredatorE_Conditions takes nothing returns boolean
    return GetLearnedSkill() == 'A15Q'
endfunction

function Trig_PredatorE_Actions takes nothing returns nothing
    local unit hero = GetLearningUnit()
    
    if GetUnitAbilityLevel(hero, GetLearnedSkill()) == 1 then
        call UnitAddAbility(hero, 'A0G6')
    endif
	call SetUnitAbilityLevel( hero, 'A0G6', GetUnitAbilityLevel(hero, GetLearnedSkill()) )

    set hero = null
endfunction

//===========================================================================
function InitTrig_PredatorE takes nothing returns nothing
    set gg_trg_PredatorE = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_PredatorE, EVENT_PLAYER_HERO_SKILL )
    call TriggerAddCondition( gg_trg_PredatorE, Condition( function Trig_PredatorE_Conditions ) )
    call TriggerAddAction( gg_trg_PredatorE, function Trig_PredatorE_Actions )
endfunction

scope PredatorE initializer Triggs
    private function Use takes nothing returns nothing
        local unit hero = udg_Event_NullingAbility_Unit
        local integer lvl = GetUnitAbilityLevel( hero, 'A15Q')
        
        call UnitRemoveAbility(hero, 'A0G6')
        
        set hero = null
    endfunction

    private function Triggs takes nothing returns nothing
        local trigger trig = CreateTrigger()
        call TriggerRegisterVariableEvent( trig, "udg_Event_NullingAbility_Real", EQUAL, 1.00 )
        call TriggerAddAction( trig, function Use)
        

        set trig = null
    endfunction
endscope
