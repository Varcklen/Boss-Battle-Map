function VampLogic takes nothing returns boolean
    local integer cyclA = 1
    local integer cyclAEnd = udg_Database_InfoNumberHeroes
    local boolean l = false

    loop
        exitwhen cyclA > cyclAEnd
        if GetLearnedSkill() == udg_DB_Hero_FirstSpell[cyclA] then
            set l = true
            set cyclA = cyclAEnd
        endif
        set cyclA = cyclA + 1
    endloop
    return l
endfunction

function Trig_DontUse_Conditions takes nothing returns boolean
    if inv(GetLearningUnit(), 'I004') > 0 and VampLogic() then
        return true
    endif
    return false
endfunction

function Trig_DontUse_Actions takes nothing returns nothing
    call UnitRemoveAbility( GetLearningUnit(), GetLearnedSkill() )
    call UnitModifySkillPoints( GetLearningUnit(), 1 )
endfunction

//===========================================================================
function InitTrig_DontUse takes nothing returns nothing
    set gg_trg_DontUse = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_DontUse, EVENT_PLAYER_HERO_SKILL )
    call TriggerAddCondition( gg_trg_DontUse, Condition( function Trig_DontUse_Conditions ) )
    call TriggerAddAction( gg_trg_DontUse, function Trig_DontUse_Actions )
endfunction

