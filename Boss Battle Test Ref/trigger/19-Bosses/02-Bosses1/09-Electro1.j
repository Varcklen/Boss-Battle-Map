function Trig_Electro1_Conditions takes nothing returns boolean
    return GetUnitTypeId( udg_DamageEventTarget ) == 'n00Z' and GetUnitLifePercent( udg_DamageEventTarget ) <= 90
endfunction

function Electro1Cast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "bsel2" ))
    local group g = CreateGroup()
    local unit u
    
    if GetUnitState( dummy, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        call GroupEnumUnitsInRange( g, GetUnitX( dummy ), GetUnitY( dummy ), 100, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if unitst( u, dummy, "enemy" ) then
                call UnitDamageTarget( dummy, u, 35, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )
            endif
            call GroupRemoveUnit(g,u)
        endloop
    endif
    
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
    set dummy = null
endfunction

function ElectroCast1 takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bsel1" ))
    local integer id1

    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( boss ), 'u000', GetUnitX( boss ) + GetRandomReal(-400, 400), GetUnitY( boss ) + GetRandomReal(-400, 400), 270 )
        call UnitAddAbility( bj_lastCreatedUnit, 'A072')
        call UnitApplyTimedLife( bj_lastCreatedUnit, 'BTLF', 20)
        call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Other\\Monsoon\\MonsoonBoltTarget.mdl", bj_lastCreatedUnit, "origin") )
        set id1 = GetHandleId( bj_lastCreatedUnit )
        
        call SaveTimerHandle( udg_hash, id1, StringHash( "bsel2" ), CreateTimer() )
        set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "bsel2" ) ) ) 
        call SaveUnitHandle( udg_hash, id1, StringHash( "bsel2" ), bj_lastCreatedUnit )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "bsel2" ) ), 1, true, function Electro1Cast ) 
    endif
    
    set boss = null
endfunction

function Trig_Electro1_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )

    call DisableTrigger( GetTriggeringTrigger() )

    if LoadTimerHandle( udg_hash, id, StringHash( "bsel1" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bsel1" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bsel1" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bsel1" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bsel1" ) ), bosscast(4), true, function ElectroCast1 )
endfunction

//===========================================================================
function InitTrig_Electro1 takes nothing returns nothing
    set gg_trg_Electro1 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Electro1 )
    call TriggerRegisterVariableEvent( gg_trg_Electro1, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Electro1, Condition( function Trig_Electro1_Conditions ) )
    call TriggerAddAction( gg_trg_Electro1, function Trig_Electro1_Actions )
endfunction

