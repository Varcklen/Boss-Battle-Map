function Trig_DoctorQ_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A032'
endfunction

function DoctorQCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local real counter = LoadReal( udg_hash, id, StringHash( "dctqt" ) )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "dctq" ) )
    local real dmg = LoadReal( udg_hash, id, StringHash( "dctq" ) )
    
    if GetUnitState( u, UNIT_STATE_LIFE) > 0.405 then
        call SetUnitState(u, UNIT_STATE_LIFE, RMaxBJ(0,GetUnitState(u, UNIT_STATE_LIFE) - dmg ))
    endif

    if counter > 1 and GetUnitState( u, UNIT_STATE_LIFE) > 0.405 and GetUnitAbilityLevel( u, 'A03G' ) > 0 then
        call SaveReal( udg_hash, id, StringHash( "dctqt" ), counter - 1 )
    else
        call UnitRemoveAbility( u, 'A03G' )
        call UnitRemoveAbility( u, 'B00W' )
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    endif
    
    set u = null
endfunction

function Trig_DoctorQ_Actions takes nothing returns nothing
    local integer id
    local integer cyclA = 1
    local real dmg
    local unit caster
    local unit target
    local integer lvl
    local real t

    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
        set lvl = udg_Level
        set t = udg_Time
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "ally", "", "", "", "" )
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A032'), caster, 64, 90, 10, 1.5 )
        set t = 20
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
        set t = 20
    endif
    set t = timebonus(caster, t)
    set dmg = 3 + ( 2 * lvl )
    
    set id = GetHandleId( target )
    call UnitAddAbility( target, 'A03G' )
    call SetUnitAbilityLevel( target, 'A034', lvl )
    call DestroyEffect( AddSpecialEffectTarget("AncientExplode1.mdx", target, "origin" ) )

    if LoadTimerHandle( udg_hash, id, StringHash( "dctq" ) ) == null then
        call SaveTimerHandle( udg_hash, id, StringHash( "dctq" ), CreateTimer() )
    endif
    set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "dctq" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "dctq" ), target )
    call SaveReal( udg_hash, id, StringHash( "dctq" ), dmg )
    call SaveReal( udg_hash, id, StringHash( "dctqt" ), t )
    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( target ), StringHash( "dctq" ) ), 1, true, function DoctorQCast )
    
    call effst( caster, target, null, lvl, t )

    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_DoctorQ takes nothing returns nothing
    set gg_trg_DoctorQ = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_DoctorQ, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_DoctorQ, Condition( function Trig_DoctorQ_Conditions ) )
    call TriggerAddAction( gg_trg_DoctorQ, function Trig_DoctorQ_Actions )
endfunction

