function Trig_Prophet_Mask_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A17B'
endfunction

function Prophet_maskCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "pphm" ) )
    
    if GetUnitAbilityLevel( u, 'B08O') == 0 or GetUnitState( u, UNIT_STATE_LIFE) <= 0.405 then
        call UnitRemoveAbility( u, 'A17Q' )
        call UnitRemoveAbility( u, 'B08O' )
        call UnitRemoveAbility( u, 'A181' )
        call UnitRemoveAbility( u, 'A180' )
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    else
        call SetUnitState( u, UNIT_STATE_LIFE, RMaxBJ( 0, GetUnitState( u, UNIT_STATE_LIFE) - (GetUnitState( u, UNIT_STATE_MAX_LIFE) * 0.02) ) )
    endif

    set u = null
endfunction

function Trig_Prophet_Mask_Actions takes nothing returns nothing
    local integer id
    local unit caster
    local real t
    
    if CastLogic() then
        set caster = udg_Caster
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( udg_string[0] + GetObjectName('A17B'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
    endif
    call eyest( caster )
    if GetUnitAbilityLevel( caster, 'B08O') == 0 then
        call UnitAddAbility( caster, 'A17Q' )
        call UnitAddAbility( caster, 'A181' )
        call UnitAddAbility( caster, 'A180' )
        
        set id = GetHandleId( caster )
        if LoadTimerHandle( udg_hash, id, StringHash( "pphm" ) ) == null then
            call SaveTimerHandle( udg_hash, id, StringHash( "pphm" ), CreateTimer() )
        endif
        set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "pphm" ) ) ) 
        call SaveUnitHandle( udg_hash, id, StringHash( "pphm" ), caster )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "pphm" ) ), 1, true, function Prophet_maskCast )
    else
        call UnitRemoveAbility( caster, 'A17Q' )
        call UnitRemoveAbility( caster, 'B08O' )
        call UnitRemoveAbility( caster, 'A181' )
        call UnitRemoveAbility( caster, 'A180' )
    endif
    call DestroyEffect( AddSpecialEffectTarget( "Blood Explosion.mdx", caster, "origin") )
    call SetUnitState( caster, UNIT_STATE_LIFE, RMaxBJ( 0, GetUnitState( caster, UNIT_STATE_LIFE) - 75 ) )
    
    set caster = null
endfunction


//===========================================================================
function InitTrig_Prophet_Mask takes nothing returns nothing
    set gg_trg_Prophet_Mask = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Prophet_Mask, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Prophet_Mask, Condition( function Trig_Prophet_Mask_Conditions ) )
    call TriggerAddAction( gg_trg_Prophet_Mask, function Trig_Prophet_Mask_Actions )
endfunction

