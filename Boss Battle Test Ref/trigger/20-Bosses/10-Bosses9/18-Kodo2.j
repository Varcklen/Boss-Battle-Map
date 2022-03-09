function Trig_Kodo2_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'h01K'
endfunction

function Kodo2End takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "bsbkd1" ) )
    local boolean l = false
    local group g = CreateGroup()
    local unit u
    
    if GetUnitState( dummy, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        call GroupEnumUnitsInRange( g, GetUnitX( dummy ), GetUnitY( dummy ), 128, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if unitst( u, dummy, "enemy" ) then
                call UnitDamageTarget( dummy, u, 200, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )
                call UnitStun(dummy, u, 5 )
                call DestroyEffect(AddSpecialEffectTarget( "Abilities\\Spells\\Human\\Thunderclap\\ThunderClapCaster.mdl", u, "origin") )
                set l = true
            endif
            call GroupRemoveUnit(g,u)
            set u = FirstOfGroup(g)
        endloop
        if l then
            call RemoveUnit( dummy )
            call DestroyTimer( GetExpiredTimer() )
            call FlushChildHashtable( udg_hash, id )
        endif
    endif
    
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
    set dummy = null
endfunction

function Kodo2Cast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bsbkd" ) )
    local integer id1

    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( boss ), 'u000', GetUnitX( boss ) + GetRandomReal(-900, 900), GetUnitY( boss ) + GetRandomReal(-900, 900), 270 )
        call UnitAddAbility( bj_lastCreatedUnit, 'A0WA')
        call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageDeathCaster.mdl", bj_lastCreatedUnit, "origin") )
        set id1 = GetHandleId( bj_lastCreatedUnit )
        
        if LoadTimerHandle( udg_hash, id1, StringHash( "bsbkd1" ) ) == null  then
            call SaveTimerHandle( udg_hash, id1, StringHash( "bsbkd1" ), CreateTimer() )
        endif
        set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "bsbkd1" ) ) ) 
        call SaveUnitHandle( udg_hash, id1, StringHash( "bsbkd1" ), bj_lastCreatedUnit )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "bsbkd1" ) ), 0.5, true, function Kodo2End )
    endif
    
    set boss = null
endfunction

function Trig_Kodo2_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )

    call DisableTrigger( GetTriggeringTrigger() )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "bsbkd" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bsbkd" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bsbkd" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bsbkd" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bsbkd" ) ), bosscast(8), true, function Kodo2Cast )
endfunction

//===========================================================================
function InitTrig_Kodo2 takes nothing returns nothing
    set gg_trg_Kodo2 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Kodo2 )
    call TriggerRegisterVariableEvent( gg_trg_Kodo2, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Kodo2, Condition( function Trig_Kodo2_Conditions ) )
    call TriggerAddAction( gg_trg_Kodo2, function Trig_Kodo2_Actions )
endfunction

