function Trig_OrbRagnaros_Conditions takes nothing returns boolean
    return udg_DamageEventAmount > 0 and not( udg_IsDamageSpell ) and inv( udg_DamageEventSource, 'I091') > 0
endfunction

function OrbRagnarosCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit target = LoadUnitHandle( udg_hash, id, StringHash( "orbrg" ) )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "orbrgc" ) )
    local real dmg = LoadReal( udg_hash, id, StringHash( "orbrg" ) )
    local group g = CreateGroup()
    local unit u

    if GetUnitState( target, UNIT_STATE_LIFE) > 0.405 then
        call bufallst( caster, target, 'A0ES', 'A0EZ', 0, 0, 0, 'B091', "orbrgb", 4 )

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

function Trig_OrbRagnaros_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "orbrg" ) ) == null then
        call SaveTimerHandle( udg_hash, id, StringHash( "orbrg" ), CreateTimer() )
    endif
    set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "orbrg" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "orbrg" ), udg_DamageEventTarget )
    call SaveUnitHandle( udg_hash, id, StringHash( "orbrgc" ), udg_DamageEventSource )
    call SaveReal( udg_hash, id, StringHash( "orbrg" ), udg_DamageEventAmount*0.5 )
    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "orbrg" ) ), 0.01, false, function OrbRagnarosCast )
endfunction

//===========================================================================
function InitTrig_OrbRagnaros takes nothing returns nothing
    set gg_trg_OrbRagnaros = CreateTrigger(  )
    call TriggerRegisterVariableEvent( gg_trg_OrbRagnaros, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_OrbRagnaros, Condition( function Trig_OrbRagnaros_Conditions ) )
    call TriggerAddAction( gg_trg_OrbRagnaros, function Trig_OrbRagnaros_Actions )
endfunction

