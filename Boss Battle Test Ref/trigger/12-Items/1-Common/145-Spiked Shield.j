function Trig_Spiked_Shield_Conditions takes nothing returns boolean
    return not( udg_IsDamageSpell ) and IsUnitEnemy(udg_DamageEventSource, GetOwningPlayer(udg_DamageEventTarget)) and ( inv(udg_DamageEventTarget, 'I09T') > 0 or ( ( inv( udg_DamageEventTarget, 'I030') > 0 ) and udg_Set_Weapon_Logic[GetPlayerId(GetOwningPlayer(udg_DamageEventTarget)) + 1 + 68] ) )
endfunction

function Spiked_ShieldCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local real dmg = 8
    local unit damager = LoadUnitHandle( udg_hash, id, StringHash( "spshd" ) )
    local unit target = LoadUnitHandle( udg_hash, id, StringHash( "spsh" ) )
    
    call dummyspawn( target, 1, 0, 0, 0 )
    call UnitDamageTarget( bj_lastCreatedUnit, damager, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
    call FlushChildHashtable( udg_hash, id )

    set damager = null
    set target = null
endfunction

function Trig_Spiked_Shield_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )
 
    call SaveTimerHandle( udg_hash, id, StringHash( "spsh" ), CreateTimer() )
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "spsh" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "spsh" ), udg_DamageEventTarget )
    call SaveUnitHandle( udg_hash, id, StringHash( "spshd" ), udg_DamageEventSource )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "spsh" ) ), 0.01, false, function Spiked_ShieldCast )
endfunction

//===========================================================================
function InitTrig_Spiked_Shield takes nothing returns nothing
    set gg_trg_Spiked_Shield = CreateTrigger(  )
    call TriggerRegisterVariableEvent( gg_trg_Spiked_Shield, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Spiked_Shield, Condition( function Trig_Spiked_Shield_Conditions ) )
    call TriggerAddAction( gg_trg_Spiked_Shield, function Trig_Spiked_Shield_Actions )
endfunction

