function Trig_Fallen_OneAdd_Conditions takes nothing returns boolean
    return GetLearnedSkill() == 'A02T'
endfunction

function Trig_Fallen_OneAdd_Actions takes nothing returns nothing
    local integer lvl = GetUnitAbilityLevel(GetLearningUnit(), 'A02T')
    if lvl > 4 then
        set lvl = 4
    endif

    call UnitAddAbility( GetLearningUnit(), 'A08S')
    set udg_FallenOneDamage = 3 + (3*lvl)
endfunction

//===========================================================================
function InitTrig_Fallen_OneAdd takes nothing returns nothing
    set gg_trg_Fallen_OneAdd = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Fallen_OneAdd, EVENT_PLAYER_HERO_SKILL )
    call TriggerAddCondition( gg_trg_Fallen_OneAdd, Condition( function Trig_Fallen_OneAdd_Conditions ) )
    call TriggerAddAction( gg_trg_Fallen_OneAdd, function Trig_Fallen_OneAdd_Actions )
endfunction

