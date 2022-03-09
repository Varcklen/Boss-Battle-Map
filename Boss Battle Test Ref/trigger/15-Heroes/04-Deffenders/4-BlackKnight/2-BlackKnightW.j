function Trig_BlackKnightW_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A04G' 
endfunction

function BlackKnightWCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "bknw" ) )
    
    call UnitRemoveAbility( u, 'A0Y2' )
    call UnitRemoveAbility( u, 'B01V' )
    call FlushChildHashtable( udg_hash, id )
    
    set u = null
endfunction

function Trig_BlackKnightW_Actions takes nothing returns nothing
    local group g = CreateGroup()
    local unit u
    local integer lvl
    local integer id
    local unit caster
    local real t
    
    if CastLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        set t = udg_Time
    elseif RandomLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A04G'), caster, 64, 90, 10, 1.5 )
        set t = 15
    else
        set caster = GetSpellAbilityUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
        set t = 15
    endif
    set t = timebonus(caster, t)

    call UnitAddAbility( caster, 'A0Y2')
    call SetUnitAbilityLevel( caster, 'A11Z', lvl)
    
    set id = GetHandleId( caster )
    if LoadTimerHandle( udg_hash, id, StringHash( "bknw" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bknw" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bknw" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "bknw" ), caster )
	call SaveReal( udg_hash, GetHandleId( caster ), StringHash( "bknw" ), 1-(0.1 + ( 0.1 * lvl )) )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "bknw" ) ), t, false, function BlackKnightWCast )
    
    call effst( caster, caster, null, lvl, t )
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_BlackKnightW takes nothing returns nothing
    set gg_trg_BlackKnightW = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_BlackKnightW, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_BlackKnightW, Condition( function Trig_BlackKnightW_Conditions ) )
    call TriggerAddAction( gg_trg_BlackKnightW, function Trig_BlackKnightW_Actions )
endfunction

