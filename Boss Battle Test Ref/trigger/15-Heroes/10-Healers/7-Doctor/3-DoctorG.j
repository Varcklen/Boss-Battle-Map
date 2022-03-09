function Trig_DoctorG_Conditions takes nothing returns boolean
    return GetLearnedSkill() == 'A04L'
endfunction

function Trig_DoctorG_Actions takes nothing returns nothing
	call BlzSetUnitMaxHP( GetLearningUnit(), BlzGetUnitMaxHP(GetLearningUnit()) + 75 )
endfunction

//===========================================================================
function InitTrig_DoctorG takes nothing returns nothing
    set gg_trg_DoctorG = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_DoctorG, EVENT_PLAYER_HERO_SKILL )
    call TriggerAddCondition( gg_trg_DoctorG, Condition( function Trig_DoctorG_Conditions ) )
    call TriggerAddAction( gg_trg_DoctorG, function Trig_DoctorG_Actions )
endfunction

