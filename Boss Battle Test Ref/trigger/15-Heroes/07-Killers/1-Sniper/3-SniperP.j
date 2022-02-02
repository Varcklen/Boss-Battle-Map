function Trig_SniperP_Conditions takes nothing returns boolean
    return GetLearnedSkill() == 'A0LA'
endfunction

function SniperPCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "snp" ) )
    local integer lvl = GetUnitAbilityLevel( u, 'A0LA' )
    
    call UnitAddAbility( u, 'A18P' )
    call UnitAddAbility( u, 'A18Q' )
    call UnitAddAbility( u, 'A18R' )
    call SetUnitAbilityLevel( u, 'A18Q', lvl )
    call SetUnitAbilityLevel( u, 'A18R', lvl )
    if GetUnitState( u, UNIT_STATE_LIFE) > 0.405 then
        call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageDeathCaster.mdl", u, "origin" ) )
    endif
    
    set u = null
endfunction

function Trig_SniperP_Actions takes nothing returns nothing
    local integer id = GetHandleId( GetLearningUnit() )
    
    call UnitRemoveAbility( GetLearningUnit(), 'A18P' )
    call UnitRemoveAbility( GetLearningUnit(), 'A18Q' ) 
    call UnitRemoveAbility( GetLearningUnit(), 'A18R' ) 
    call UnitRemoveAbility( GetLearningUnit(), 'B031' ) 
    
    if LoadTimerHandle( udg_hash, id, StringHash( "snp" ) ) == null then
        call SaveTimerHandle( udg_hash, id, StringHash( "snp" ), CreateTimer() )
    endif
	//call SaveTimerHandle( udg_hash, id, StringHash( "snp" ), CreateTimer( ) ) 
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "snp" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "snp" ), GetLearningUnit() ) 
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetLearningUnit() ), StringHash( "snp" ) ), 4, false, function SniperPCast ) 
endfunction

//===========================================================================
function InitTrig_SniperP takes nothing returns nothing
    set gg_trg_SniperP = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_SniperP, EVENT_PLAYER_HERO_SKILL )
    call TriggerAddCondition( gg_trg_SniperP, Condition( function Trig_SniperP_Conditions ) )
    call TriggerAddAction( gg_trg_SniperP, function Trig_SniperP_Actions )
endfunction

