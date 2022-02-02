function Trig_Yah_tear_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0QD'
endfunction

function Yah_tearCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "yah" ) )

    if GetUnitState( u, UNIT_STATE_LIFE) > 0.405 and GetUnitAbilityLevel( u, 'A0QQ' ) > 0 then
        call SetUnitState( u, UNIT_STATE_MANA, RMaxBJ(0,GetUnitState(u, UNIT_STATE_MANA) - 25 ))
        if GetUnitState(u, UNIT_STATE_MANA) <= 0 then
            call UnitRemoveAbility( u, 'A0QQ' )
            call FlushChildHashtable( udg_hash, id )
            call DestroyTimer( GetExpiredTimer() )
        endif
    else
        call UnitRemoveAbility( u, 'A0QQ' )
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    endif
    
    set u = null
endfunction

function Trig_Yah_tear_Actions takes nothing returns nothing
    local integer id 
    local unit caster
    
    if CastLogic() then
        set caster = udg_Caster
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( udg_string[0] + GetObjectName('A0QD'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
    endif
    
    set id = GetHandleId( caster )
    call UnitAddAbility( caster, 'A0QQ' )
    call manast( caster, null, GetUnitState(caster, UNIT_STATE_MAX_MANA) )
    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Items\\TomeOfRetraining\\TomeOfRetrainingCaster.mdl", GetUnitX( caster ), GetUnitY( caster ) ) )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "yah" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "yah" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "yah" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "yah" ), caster )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "yah" ) ), 1, true, function Yah_tearCast )
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_Yah_tear takes nothing returns nothing
    set gg_trg_Yah_tear = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Yah_tear, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Yah_tear, Condition( function Trig_Yah_tear_Conditions ) )
    call TriggerAddAction( gg_trg_Yah_tear, function Trig_Yah_tear_Actions )
endfunction

