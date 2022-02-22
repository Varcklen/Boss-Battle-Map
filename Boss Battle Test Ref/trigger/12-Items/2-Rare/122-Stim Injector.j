function Trig_Stim_Injector_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A16T'
endfunction

function Stim_InjectorCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "stmi" ) )
    
    call UnitRemoveAbility( u, 'A18L' )
    call UnitRemoveAbility( u, 'A18M' )
    call UnitRemoveAbility( u, 'A17P' )
    call UnitRemoveAbility( u, 'A17N' )
    call UnitRemoveAbility( u, 'B09I' )
    call FlushChildHashtable( udg_hash, id )
    
    set u = null
endfunction

function Trig_Stim_Injector_Actions takes nothing returns nothing
    local integer id 
    local unit caster
    local real t
    local integer k
    
    if CastLogic() then
        set caster = udg_Caster
        set t = udg_Time
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( udg_string[0] + GetObjectName('A16T'), caster, 64, 90, 10, 1.5 )
        set t = 20
    else
        set caster = GetSpellAbilityUnit()
        set t = 20
    endif
    set t = timebonus(caster, t)
    call eyest( caster )
    call UnitAddAbility( caster, 'A17P' )
    call UnitAddAbility( caster, 'A17N' )
    set k = SetCount_GetPieces(caster, SET_MECH)
    if k > 10 then
        set k = 10
    endif
    call UnitAddAbility( caster, 'A18L' )
    call UnitAddAbility( caster, 'A18M' )
    call SetUnitAbilityLevel( caster, 'A18L', k )
    call SetUnitAbilityLevel( caster, 'A18M', k )
    
    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\NightElf\\BattleRoar\\RoarCaster.mdl", GetUnitX( caster ), GetUnitY( caster ) ) )
    
    set id = GetHandleId( caster )
    if LoadTimerHandle( udg_hash, id, StringHash( "stmi" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "stmi" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "stmi" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "stmi" ), caster )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "stmi" ) ), t, false, function Stim_InjectorCast )
    
    call SetUnitState( caster, UNIT_STATE_LIFE, RMaxBJ(0,GetUnitState( caster, UNIT_STATE_LIFE) - 150 ))
    
    call effst( caster, caster, null, 1, t )
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_Stim_Injector takes nothing returns nothing
    set gg_trg_Stim_Injector = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Stim_Injector, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Stim_Injector, Condition( function Trig_Stim_Injector_Conditions ) )
    call TriggerAddAction( gg_trg_Stim_Injector, function Trig_Stim_Injector_Actions )
endfunction

