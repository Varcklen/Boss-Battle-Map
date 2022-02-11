function Trig_OrbFire_Conditions takes nothing returns boolean
    return udg_DamageEventAmount > 0 and not( udg_IsDamageSpell ) and inv( udg_DamageEventSource, 'I08Z') > 0
endfunction

function OrbFireCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit target = LoadUnitHandle( udg_hash, id, StringHash( "orbf" ) )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "orbfc" ) )
    local real dmg = LoadReal( udg_hash, id, StringHash( "orbf" ) )
    local group g = CreateGroup()
    local unit u

    if GetUnitState( target, UNIT_STATE_LIFE) > 0.405 then
        call dummyspawn( caster, 1, 0, 0, 0 )
        call GroupEnumUnitsInRange( g, GetUnitX( target ), GetUnitY( target ), 300, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if unitst( u, caster, "enemy" ) then
                call UnitDamageTarget( bj_lastCreatedUnit, u, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )
            endif
            call GroupRemoveUnit(g,u)
            set u = FirstOfGroup(g)
        endloop
    endif
    call FlushChildHashtable( udg_hash, id )

    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
    set target = null
    set caster = null
endfunction

function Trig_OrbFire_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "orbf" ) ) == null then
        call SaveTimerHandle( udg_hash, id, StringHash( "orbf" ), CreateTimer() )
    endif
    set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "orbf" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "orbf" ), udg_DamageEventTarget )
    call SaveUnitHandle( udg_hash, id, StringHash( "orbfc" ), udg_DamageEventSource )
    call SaveReal( udg_hash, id, StringHash( "orbf" ), udg_DamageEventAmount*0.2 )
    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "orbf" ) ), 0.01, false, function OrbFireCast )
endfunction

//===========================================================================
function InitTrig_OrbFire takes nothing returns nothing
    set gg_trg_OrbFire = CreateTrigger(  )
    call TriggerRegisterVariableEvent( gg_trg_OrbFire, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_OrbFire, Condition( function Trig_OrbFire_Conditions ) )
    call TriggerAddAction( gg_trg_OrbFire, function Trig_OrbFire_Actions )
endfunction

