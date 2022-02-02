function Trig_MarshalE_Conditions takes nothing returns boolean
    return GetLearnedSkill() == 'A0F7'
endfunction

function Trig_MarshalE_Actions takes nothing returns nothing
    local unit hero = GetLearningUnit()
    
    if GetUnitAbilityLevel(hero, GetLearnedSkill()) == 1 then
        call BlzSetUnitAttackCooldown( hero, BlzGetUnitAttackCooldown(hero, 0) - 0.07, 0 )
    endif
	call BlzSetUnitAttackCooldown( hero, BlzGetUnitAttackCooldown(hero, 0) - 0.03, 0 )
    
    if LoadInteger( udg_hash, GetHandleId( hero ), StringHash( "killb" ) ) == 0 then
        call UnitAddAbility(hero, 'A0G0')
    endif
    set hero = null
endfunction

//===========================================================================
function InitTrig_MarshalE takes nothing returns nothing
    set gg_trg_MarshalE = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_MarshalE, EVENT_PLAYER_HERO_SKILL )
    call TriggerAddCondition( gg_trg_MarshalE, Condition( function Trig_MarshalE_Conditions ) )
    call TriggerAddAction( gg_trg_MarshalE, function Trig_MarshalE_Actions )
endfunction

scope MarshalE initializer Triggs
    private function Use takes nothing returns nothing
        local unit hero = udg_Event_NullingAbility_Unit
        local integer lvl = GetUnitAbilityLevel( hero, 'A0F7')
        
        call UnitRemoveAbility(hero, 'A0G0')
        call UnitRemoveAbility(hero, 'B06B')
        if lvl > 0 then
            call BlzSetUnitAttackCooldown( hero, BlzGetUnitAttackCooldown(hero, 0) + 0.07, 0 )
            call BlzSetUnitAttackCooldown( hero, BlzGetUnitAttackCooldown(hero, 0) + (0.03*lvl), 0 )
        endif
        
        set hero = null
    endfunction
    
    private function StartFight_Conditions takes nothing returns boolean
        return GetUnitAbilityLevel( udg_FightStart_Unit, 'A0F7') > 0
    endfunction
    
    private function StartFight takes nothing returns nothing
        local unit hero = udg_FightStart_Unit

        call UnitAddAbility(hero, 'A0G0')
        call UnitAddAbility(hero, 'B06B')
        
        set hero = null
    endfunction

    private function Triggs takes nothing returns nothing
        local trigger trig = CreateTrigger()
        call TriggerRegisterVariableEvent( trig, "udg_Event_NullingAbility_Real", EQUAL, 1.00 )
        call TriggerAddAction( trig, function Use)
        
        set trig = CreateTrigger()
        call TriggerRegisterVariableEvent( trig, "udg_FightStart_Real", EQUAL, 1.00 )
        call TriggerAddCondition( trig, Condition( function StartFight_Conditions ) )
        call TriggerAddAction( trig, function StartFight)
        
        set trig = null
    endfunction
endscope
