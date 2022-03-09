function Trig_Fallen_OneQDamage_Conditions takes nothing returns boolean
    return not( udg_IsDamageSpell ) and IsUnitEnemy(udg_DamageEventSource, GetOwningPlayer(udg_DamageEventTarget)) and GetUnitAbilityLevel(udg_DamageEventTarget, 'B08G') > 0
endfunction

function Fallen_OneQDamageCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local real dmg = udg_FallenOneDamage
    local unit damager = LoadUnitHandle( udg_hash, id, StringHash( "flnqdd" ) )
    local unit target = LoadUnitHandle( udg_hash, id, StringHash( "flnqd" ) )
    
    call dummyspawn( target, 1, 0, 0, 0 )
    call UnitDamageTarget( bj_lastCreatedUnit, damager, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
    call FlushChildHashtable( udg_hash, id )

    set damager = null
    set target = null
endfunction

function Trig_Fallen_OneQDamage_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )
 
    if LoadTimerHandle( udg_hash, id, StringHash( "flnqd" ) ) == null then
        call SaveTimerHandle( udg_hash, id, StringHash( "flnqd" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "flnqd" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "flnqd" ), udg_DamageEventTarget )
    call SaveUnitHandle( udg_hash, id, StringHash( "flnqdd" ), udg_DamageEventSource )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "flnqd" ) ), 0.01, false, function Fallen_OneQDamageCast )
endfunction

//===========================================================================
function InitTrig_Fallen_OneQDamage takes nothing returns nothing
    set gg_trg_Fallen_OneQDamage = CreateTrigger(  )
    call TriggerRegisterVariableEvent( gg_trg_Fallen_OneQDamage, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Fallen_OneQDamage, Condition( function Trig_Fallen_OneQDamage_Conditions ) )
    call TriggerAddAction( gg_trg_Fallen_OneQDamage, function Trig_Fallen_OneQDamage_Actions )
endfunction

