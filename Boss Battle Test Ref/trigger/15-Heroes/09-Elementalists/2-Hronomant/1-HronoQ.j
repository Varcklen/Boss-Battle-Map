function Trig_HronoQ_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A09L'
endfunction

function HronoQCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local real counter = LoadReal( udg_hash, id, StringHash( "hrnq2" ) )
    local real dmg = LoadReal( udg_hash, id, StringHash( "hrnq" ) )
    local unit target = LoadUnitHandle( udg_hash, id, StringHash( "hrnq" ) )
    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "hrnq1" ) )
    
    if GetUnitState( target, UNIT_STATE_LIFE) > 0.405 then
        call UnitDamageTarget( dummy, target, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )
    endif
    
    if GetUnitState(target, UNIT_STATE_LIFE) > 0.405 and counter > 0 and GetUnitAbilityLevel( target, 'B02P') > 0 then
        call SaveReal( udg_hash, id, StringHash( "hrnq2" ), counter - 1 )
    else
        call UnitRemoveAbility( target, 'A0PX' )
        call UnitRemoveAbility( target, 'B02P' )
        call SaveInteger( udg_hash, GetHandleId( target ), StringHash( "hrnqs" ), 0 )
        call RemoveUnit( dummy )
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    endif
    
    set target = null
    set dummy = null
endfunction

function Trig_HronoQ_Actions takes nothing returns nothing
    local unit dummy
    local integer id
    local real dmg
    local integer stack
    local unit caster
    local unit target
    local integer lvl
    local real t
    local boolean l = false
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
        set lvl = udg_Level
        set t = udg_Time
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "enemy", "", "", "", "" )
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A09L'), caster, 64, 90, 10, 1.5 )
        set t = 15
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
        set t = 15
    endif
    set t = timebonus(caster, t)

    set stack = LoadInteger( udg_hash, GetHandleId( target ), StringHash( "hrnqs" ) ) + 1
    if stack > 3 then
        set stack = 3
    endif
    call SaveInteger( udg_hash, GetHandleId( target ), StringHash( "hrnqs" ), stack )
    call textst( "|cf0FF1765" + I2S(stack), target, 64, GetRandomReal( 80, 100 ), 12, 1 )

    call UnitAddAbility( target, 'A0PX')
    set dmg = stack * ( 4 + ( 3 * lvl ) ) * GetUnitSpellPower(caster)
    
    set id = GetHandleId( target )
    if LoadTimerHandle( udg_hash, id, StringHash( "hrnq" ) ) == null then
        call SaveTimerHandle( udg_hash, id, StringHash( "hrnq" ), CreateTimer() )
        set l = true
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "hrnq" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "hrnq" ), target )
    call SaveReal( udg_hash, id, StringHash( "hrnq2" ), t )
    call SaveReal( udg_hash, id, StringHash( "hrnq" ), dmg )
    if l then
        call dummyspawn( caster, 0, 0, 0, 0 )
        call SaveUnitHandle( udg_hash, id, StringHash( "hrnq1" ), bj_lastCreatedUnit )
    endif
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( target ), StringHash( "hrnq" ) ), 1, true, function HronoQCast )
    
    call debuffst( caster, target, null, lvl, t )
    
    set dummy = null
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_HronoQ takes nothing returns nothing
    set gg_trg_HronoQ = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_HronoQ, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_HronoQ, Condition( function Trig_HronoQ_Conditions ) )
    call TriggerAddAction( gg_trg_HronoQ, function Trig_HronoQ_Actions )
endfunction

