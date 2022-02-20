function Trig_Poison_Conditions takes nothing returns boolean
    return not( udg_IsDamageSpell ) and inv(udg_DamageEventSource, 'I01B' ) > 0
endfunction

function PoisonCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local integer counter = LoadInteger( udg_hash, id, StringHash( "pois" ) ) + 1
    local real t = LoadReal( udg_hash, id, StringHash( "poist" ) )
    local real dmg = LoadReal( udg_hash, id, StringHash( "pois" ) )
    local unit target = LoadUnitHandle( udg_hash, id, StringHash( "pois" ) )
    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "poisd" ) )
    
    if GetUnitState( target, UNIT_STATE_LIFE) <= 0.405 or GetUnitState( dummy, UNIT_STATE_LIFE) <= 0.405 or GetUnitAbilityLevel( target, 'A02O') == 0 then
        call RemoveUnit( dummy )
        call UnitRemoveAbility( target, 'A02O' )
        call UnitRemoveAbility( target, 'B00D' )
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    else
        call UnitDamageTarget( dummy, target, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )
    endif
    
    set dummy = null
    set target = null
endfunction

function Trig_Poison_Actions takes nothing returns nothing
    local integer id 
    local unit target = udg_DamageEventTarget
    local unit caster = udg_DamageEventSource
    local real t = timebonus(caster, 15)

    if GetUnitAbilityLevel( target, 'A02O') == 0 then
        call dummyspawn( caster, 0, 0, 'A0N5', 0 )
        
        set id = GetHandleId( target )
        if LoadTimerHandle( udg_hash, id, StringHash( "pois" ) ) == null then
            call SaveTimerHandle( udg_hash, id, StringHash( "pois" ), CreateTimer() )
        endif
        set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "pois" ) ) ) 
        call SaveUnitHandle( udg_hash, id, StringHash( "pois" ), target )
        call SaveUnitHandle( udg_hash, id, StringHash( "poisd" ), bj_lastCreatedUnit )
        call SaveReal( udg_hash, id, StringHash( "poist" ), t )
        call SaveReal( udg_hash, id, StringHash( "pois" ), 15 * GetUnitSpellPower(caster) )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( target ), StringHash( "pois" ) ), 1, true, function PoisonCast ) 
    endif
    call bufst( caster, target, 'A02O', 'B00D', "pois1", t )
    call debuffst( caster, target, null, 1, t )
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_Poison takes nothing returns nothing
    set gg_trg_Poison = CreateTrigger(  )
    call TriggerRegisterVariableEvent( gg_trg_Poison, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Poison, Condition( function Trig_Poison_Conditions ) )
    call TriggerAddAction( gg_trg_Poison, function Trig_Poison_Actions )
endfunction

