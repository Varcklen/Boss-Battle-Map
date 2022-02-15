function Trig_ShamanR_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0XH'
endfunction

function ShamanREnd takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local real dmg = LoadReal( udg_hash, id, StringHash( "shmr1" ) )
    local unit target = LoadUnitHandle( udg_hash, id, StringHash( "shmr1" ) )
    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "shmr1d" ) )
    
    if GetUnitState( target, UNIT_STATE_LIFE) > 0.405 and GetUnitAbilityLevel( target, 'A0N4') > 0 then
        call UnitDamageTarget( dummy, target, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )
    else
        call UnitRemoveAbility( target, 'A0N4' )
        call UnitRemoveAbility( target, 'B06P' )
        call RemoveUnit( dummy )
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    endif
    
    set target = null
    set dummy = null
endfunction

function ShamanRSpell takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local integer t = LoadInteger( udg_hash, id, StringHash( "shmr" ) ) - 1
    local real dmg = LoadReal( udg_hash, id, StringHash( "shmr" ) )
	local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "shmrc" ) )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "shmr" ) )
    local unit target = randomtarget( u, 500, "enemy", "", "", "", "" )
	local integer id1

    if GetUnitState( target, UNIT_STATE_LIFE) > 0.405 and target != null then
        if GetUnitAbilityLevel( target, 'A0N4') == 0 then
            call bufst( caster, target, 'A0N4', 'B06P', "shmr2", 5 )
            call dummyspawn( caster, 0, 'A0N5', 0, 0 )
            set id1 = GetHandleId( target )
            if LoadTimerHandle( udg_hash, id1, StringHash( "shmr1" ) ) == null  then
                call SaveTimerHandle( udg_hash, id1, StringHash( "shmr1" ), CreateTimer() )
            endif
            set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "shmr1" ) ) ) 
            call SaveUnitHandle( udg_hash, id1, StringHash( "shmr1" ), target )
            call SaveUnitHandle( udg_hash, id1, StringHash( "shmr1d" ), bj_lastCreatedUnit )
            call SaveReal( udg_hash, id1, StringHash( "shmr1" ), dmg )
            call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( target ), StringHash( "shmr1" ) ), 0.5, true, function ShamanREnd )
        endif
        call debuffst( caster, target, null, 1, t )
    endif
    
    if t > 0 and GetUnitState( u, UNIT_STATE_LIFE) > 0.405 and GetUnitAbilityLevel( u, 'A05C') > 0 then
        call SaveInteger( udg_hash, id, StringHash( "shmr" ), t )
    else
        call UnitRemoveAbility( u, 'A05C' )
        call UnitRemoveAbility( u, 'B06O' )
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    endif
    
	set caster = null
    set target = null
    set u = null
endfunction

function Trig_ShamanR_Actions takes nothing returns nothing
    local integer id 
    local unit caster
    local unit target
    local integer lvl
    local real t
    local real mdmg
    local real dmg
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
        set lvl = udg_Level
        set t = udg_Time
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "ally", "", "", "", "" )
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A0XH'), caster, 64, 90, 10, 1.5 )
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
    
    set mdmg = 1 - ( 0.05 + ( 0.05*lvl) )
    set dmg = (25 + (lvl*50)) * GetUnitSpellPower(caster) /10
    set id = GetHandleId( target )
    
    call UnitAddAbility( target, 'A05C' )

    set id = GetHandleId( target )
    if LoadTimerHandle( udg_hash, id, StringHash( "shmr" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "shmr" ), CreateTimer() )
    endif
    set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "shmr" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "shmr" ), target )
	call SaveUnitHandle( udg_hash, id, StringHash( "shmrc" ), caster )
    call SaveReal( udg_hash, GetHandleId( target ), StringHash( "shmrd" ), mdmg )
    call SaveInteger( udg_hash, id, StringHash( "shmr" ), R2I(t/0.5) )
	call SaveReal( udg_hash, id, StringHash( "shmr" ), dmg )
    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( target ), StringHash( "shmr" ) ), 0.5, true, function ShamanRSpell )

    call effst( caster, target, null, lvl, t )

    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_ShamanR takes nothing returns nothing
    set gg_trg_ShamanR = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_ShamanR, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_ShamanR, Condition( function Trig_ShamanR_Conditions ) )
    call TriggerAddAction( gg_trg_ShamanR, function Trig_ShamanR_Actions )
endfunction

