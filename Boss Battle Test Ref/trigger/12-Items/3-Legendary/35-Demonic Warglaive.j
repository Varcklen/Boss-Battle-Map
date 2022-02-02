function Trig_Demonic_Warglaive_Conditions takes nothing returns boolean
    return udg_DamageEventAmount > 0 and not( udg_IsDamageSpell ) and ( inv( udg_DamageEventSource, 'I08T') > 0 or ( inv( udg_DamageEventSource, 'I030') > 0 and udg_Set_Weapon_Logic[GetPlayerId(GetOwningPlayer(udg_DamageEventSource)) + 1 + 100] ) )
endfunction

function Demonic_WarglaiveCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit target = LoadUnitHandle( udg_hash, id, StringHash( "dmwg" ) )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "dmwgc" ) )

    call dummyspawn( caster, 1, 0, 0, 0 )
    call UnitDamageTarget( bj_lastCreatedUnit, target, 20, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )
    call FlushChildHashtable( udg_hash, id )

    set target = null
    set caster = null
endfunction

function Trig_Demonic_Warglaive_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "dmwg" ) ) == null then
        call SaveTimerHandle( udg_hash, id, StringHash( "dmwg" ), CreateTimer() )
    endif
    set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "dmwg" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "dmwg" ), udg_DamageEventTarget )
    call SaveUnitHandle( udg_hash, id, StringHash( "dmwgc" ), udg_DamageEventSource )
    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "dmwg" ) ), 0.01, false, function Demonic_WarglaiveCast )
endfunction

//===========================================================================
function InitTrig_Demonic_Warglaive takes nothing returns nothing
    set gg_trg_Demonic_Warglaive = CreateTrigger(  )
    call TriggerRegisterVariableEvent( gg_trg_Demonic_Warglaive, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Demonic_Warglaive, Condition( function Trig_Demonic_Warglaive_Conditions ) )
    call TriggerAddAction( gg_trg_Demonic_Warglaive, function Trig_Demonic_Warglaive_Actions )
endfunction

