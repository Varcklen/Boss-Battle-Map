function Trig_InfernalE_Conditions takes nothing returns boolean
    return GetLearnedSkill() == 'A1A5'
endfunction

function Trig_InfernalE_Actions takes nothing returns nothing
    local unit u = GetLearningUnit()
    local integer lvl = 3+GetUnitAbilityLevel(u, 'A1A5')
    local integer id = GetHandleId(u)
    
    call UnitAddAbility( u, 'A1A6')
    call UnitAddAbility( u, 'A1A7')
    call SetUnitAbilityLevel(u, 'A1A6', lvl )
    
    call textst( "|cFF57E5C6" + I2S(GetUnitAbilityLevel(u, 'A1A6')-1), u, 64, GetRandomReal( 80, 100 ), 12, 1 )
    call SaveReal( udg_hash, id, StringHash( "infe" ), 0 )
    call SaveReal( udg_hash, id, StringHash( "infen" ), GetUnitState( u, UNIT_STATE_MAX_LIFE) * 0.2 )
    
    set u = null
endfunction

//===========================================================================
function InitTrig_InfernalE takes nothing returns nothing
    set gg_trg_InfernalE = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_InfernalE, EVENT_PLAYER_HERO_SKILL )
    call TriggerAddCondition( gg_trg_InfernalE, Condition( function Trig_InfernalE_Conditions ) )
    call TriggerAddAction( gg_trg_InfernalE, function Trig_InfernalE_Actions )
endfunction

