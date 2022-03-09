function Trig_Heuz3_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'e008' and GetUnitLifePercent(udg_DamageEventTarget) <= 50
endfunction

function HeuzCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local integer counter = LoadInteger( udg_hash, id, StringHash( "bshz" ) ) + 1
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bshzbs" ) )
    local unit target = LoadUnitHandle( udg_hash, id, StringHash( "bshz" ) )
    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "bshzd" ) )

    if GetUnitState( dummy, UNIT_STATE_LIFE) <= 0.405 or GetUnitState( target, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) or counter >= 60 or GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or GetUnitAbilityLevel( target, 'A090' ) == 0 then
        call UnitRemoveAbility( target, 'A090' )
        call RemoveUnit( dummy )
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else    
        call UnitDamageTarget( dummy, target, 50, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )
        call SaveInteger( udg_hash, id, StringHash( "bshz" ), counter )
    endif
    
    set boss = null
    set target = null
    set dummy = null
endfunction

function Trig_Heuz3_Actions takes nothing returns nothing
    local integer id
    local integer cyclA = 1

    call DisableTrigger( GetTriggeringTrigger() )
    loop
        exitwhen cyclA > 4
        if GetUnitState(udg_hero[cyclA], UNIT_STATE_LIFE) > 0.405 then
            call dummyspawn( udg_DamageEventTarget, 0, 0, 0, 0 )
            call UnitAddAbility( udg_hero[cyclA], 'A090' )
            set id = GetHandleId( udg_hero[cyclA] )
            call SaveTimerHandle( udg_hash, id, StringHash( "bshz" ), CreateTimer() )
            set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bshz" ) ) ) 
            call SaveUnitHandle( udg_hash, id, StringHash( "bshz" ), udg_hero[cyclA] )
            call SaveUnitHandle( udg_hash, id, StringHash( "bshzd" ), bj_lastCreatedUnit )
            call SaveUnitHandle( udg_hash, id, StringHash( "bshzbs" ), udg_DamageEventTarget )
            call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_hero[cyclA] ), StringHash( "bshz" ) ), 1, true, function HeuzCast )
        endif
        set cyclA = cyclA + 1
    endloop
endfunction

//===========================================================================
function InitTrig_Heuz3 takes nothing returns nothing
    set gg_trg_Heuz3 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Heuz3 )
    call TriggerRegisterVariableEvent( gg_trg_Heuz3, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Heuz3, Condition( function Trig_Heuz3_Conditions ) )
    call TriggerAddAction( gg_trg_Heuz3, function Trig_Heuz3_Actions )
endfunction

