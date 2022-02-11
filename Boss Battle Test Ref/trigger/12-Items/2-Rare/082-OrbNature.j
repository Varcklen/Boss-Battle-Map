function Trig_OrbNature_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A10S'
endfunction

function OrbNatureCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local real counter = LoadReal( udg_hash, id, StringHash( "orbnt" ) )
    local real heal = LoadReal( udg_hash, id, StringHash( "orbn" ) )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "orbn" ) )
    
    if GetUnitState( u, UNIT_STATE_LIFE) > 0.405 then
        call healst( u, null, heal )
    endif
    
    if counter > 1 and GetUnitState( u, UNIT_STATE_LIFE) > 0.405 and GetUnitAbilityLevel(u, 'B09E') > 0 then
        call SaveReal( udg_hash, id, StringHash( "orbnt" ), counter - 1 )
    else
        call UnitRemoveAbility( u, 'A12C' )
        call UnitRemoveAbility( u, 'B09E' )
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    endif
    
    set u = null
endfunction

function Trig_OrbNature_Actions takes nothing returns nothing
    local integer id
    local unit caster
    local real heal
    local real t
    
    if CastLogic() then
        set caster = udg_Caster
        set t = udg_Time
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( udg_string[0] + GetObjectName('A10S'), caster, 64, 90, 10, 1.5 )
        set t = 10
    else
        set caster = GetSpellAbilityUnit()
        set t = 10
    endif
    set t = timebonus(caster, t)
    call eyest( caster )
    set heal = 40
    call UnitAddAbility( caster, 'A12C' )
    
    if LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "orbn" ) ) == null then
        call SaveTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "orbn" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "orbn" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "orbn" ), caster )
    call SaveReal( udg_hash, id, StringHash( "orbn" ), heal )
    call SaveReal( udg_hash, id, StringHash( "orbnt" ), t )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "orbn" ) ), 1, true, function OrbNatureCast )
    
    call effst( caster, caster, null, 1, t )
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_OrbNature takes nothing returns nothing
    set gg_trg_OrbNature = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_OrbNature, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_OrbNature, Condition( function Trig_OrbNature_Conditions ) )
    call TriggerAddAction( gg_trg_OrbNature, function Trig_OrbNature_Actions )
endfunction

