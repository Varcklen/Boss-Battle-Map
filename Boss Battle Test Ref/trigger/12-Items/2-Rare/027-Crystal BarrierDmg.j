function Trig_Crystal_BarrierDmg_Conditions takes nothing returns boolean
    return not( udg_IsDamageSpell ) and IsUnitEnemy(udg_DamageEventSource, GetOwningPlayer(udg_DamageEventTarget)) and GetUnitAbilityLevel(udg_DamageEventTarget, 'B08Q') > 0
endfunction

function Crystal_BarrierEnd takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local real dmg = LoadReal( udg_hash, id, StringHash( "crbr" ))
    local unit damager = LoadUnitHandle( udg_hash, id, StringHash( "crbrd" ) )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "crbr" ) )
    
    call dummyspawn( caster, 1, 0, 0, 0 )
    call UnitDamageTarget( bj_lastCreatedUnit, damager, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
    call FlushChildHashtable( udg_hash, id )

    set damager = null
    set caster = null
endfunction

function Trig_Crystal_BarrierDmg_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )
 
    if LoadTimerHandle( udg_hash, id, StringHash( "crbr" ) ) == null then
        call SaveTimerHandle( udg_hash, id, StringHash( "crbr" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "crbr" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "crbr" ), udg_DamageEventTarget )
    call SaveUnitHandle( udg_hash, id, StringHash( "crbrd" ), udg_DamageEventSource )
    call SaveReal( udg_hash, id, StringHash( "crbr" ), udg_DamageEventAmount )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "crbr" ) ), 0.01, false, function Crystal_BarrierEnd )
endfunction

//===========================================================================
function InitTrig_Crystal_BarrierDmg takes nothing returns nothing
    set gg_trg_Crystal_BarrierDmg = CreateTrigger(  )
    call TriggerRegisterVariableEvent( gg_trg_Crystal_BarrierDmg, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Crystal_BarrierDmg, Condition( function Trig_Crystal_BarrierDmg_Conditions ) )
    call TriggerAddAction( gg_trg_Crystal_BarrierDmg, function Trig_Crystal_BarrierDmg_Actions )
endfunction

