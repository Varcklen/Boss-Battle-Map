function Trig_BlackKnightP_Conditions takes nothing returns boolean
    return GetLearnedSkill() == 'A0ZN'
endfunction

function BlackKnightPCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "bkp" ) )
    local real hp 
    
    if u != null and GetUnitState( u, UNIT_STATE_LIFE) > 0.405 then
        set hp = GetUnitState( u, UNIT_STATE_LIFE) / GetUnitState( u, UNIT_STATE_MAX_LIFE) * 100.0
        if GetUnitAbilityLevel( u, 'A0ZN' ) == 0 then
            call UnitRemoveAbility( u, 'A0ZZ')
            call UnitRemoveAbility( u, 'B049')
            call UnitRemoveAbility( u, 'A0ZY')
            call UnitRemoveAbility( u, 'B048')
            call FlushChildHashtable( udg_hash, id )
            call DestroyTimer( GetExpiredTimer() )
        elseif GetUnitState( u, UNIT_STATE_LIFE) > 0.405 then
            if hp >= 50 and GetUnitAbilityLevel( u, 'B048') == 0 then
                call UnitAddAbility( u, 'A0ZY')
                call SetUnitAbilityLevel( u, 'A09O', GetUnitAbilityLevel( u, 'A0ZN') )
                call UnitRemoveAbility( u, 'A0ZZ')
                call UnitRemoveAbility( u, 'B049')
            elseif hp <= 50 and hp > 0 and GetUnitAbilityLevel( u, 'B049') == 0 then
                call UnitAddAbility( u, 'A0ZZ')
                call SetUnitAbilityLevel( u, 'S005', GetUnitAbilityLevel( u, 'A0ZN'))
                call UnitRemoveAbility( u, 'A0ZY')
                call UnitRemoveAbility( u, 'B048')
            endif            
        endif
    elseif GetUnitState( u, UNIT_STATE_LIFE) <= 0.405 then
        call UnitRemoveAbility( u, 'A0ZZ')
        call UnitRemoveAbility( u, 'B049')
        call UnitRemoveAbility( u, 'A0ZY')
        call UnitRemoveAbility( u, 'B048')
    endif
    
    set u = null
endfunction

function Trig_BlackKnightP_Actions takes nothing returns nothing
    local integer id = GetHandleId( GetLearningUnit() )
    
    call UnitRemoveAbility( GetLearningUnit(), 'A0ZY' )
    call UnitRemoveAbility( GetLearningUnit(), 'A0ZZ' ) 
    call UnitRemoveAbility( GetLearningUnit(), 'A09O' )
    call UnitRemoveAbility( GetLearningUnit(), 'S005' )
    call UnitRemoveAbility( GetLearningUnit(), 'B048' )
    call UnitRemoveAbility( GetLearningUnit(), 'B049' ) 
    
    call DestroyTimer( LoadTimerHandle( udg_hash, GetHandleId( GetLearningUnit() ), StringHash( "bkp" )))
    call RemoveSavedHandle(udg_hash, GetHandleId( GetLearningUnit() ), StringHash( "bkp" ) )
    call UnitRemoveAbility( GetLearningUnit(), 'A0LH' )
    call UnitRemoveAbility( GetLearningUnit(), 'B031' ) 
	call SaveTimerHandle( udg_hash, id, StringHash( "bkp" ), CreateTimer( ) ) 
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bkp" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "bkp" ), GetLearningUnit() ) 
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetLearningUnit() ), StringHash( "bkp" ) ), 1, true, function BlackKnightPCast )
endfunction

//===========================================================================
function InitTrig_BlackKnightP takes nothing returns nothing
    set gg_trg_BlackKnightP = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_BlackKnightP, EVENT_PLAYER_HERO_SKILL )
    call TriggerAddCondition( gg_trg_BlackKnightP, Condition( function Trig_BlackKnightP_Conditions ) )
    call TriggerAddAction( gg_trg_BlackKnightP, function Trig_BlackKnightP_Actions )
endfunction

