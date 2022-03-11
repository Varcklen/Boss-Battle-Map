function Trig_PeacelockE_Conditions takes nothing returns boolean
    return GetLearnedSkill() == 'A04X'
endfunction

function Trig_PeacelockE_Actions takes nothing returns nothing
	set udg_real[2] = 0.25 + (0.15*GetUnitAbilityLevel( GetLearningUnit(), 'A04X'))
    set udg_unit[0] = GetLearningUnit()
endfunction

//===========================================================================
function InitTrig_PeacelockE takes nothing returns nothing
    set gg_trg_PeacelockE = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_PeacelockE, EVENT_PLAYER_HERO_SKILL )
    call TriggerAddCondition( gg_trg_PeacelockE, Condition( function Trig_PeacelockE_Conditions ) )
    call TriggerAddAction( gg_trg_PeacelockE, function Trig_PeacelockE_Actions )
endfunction

