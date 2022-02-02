function Trig_DarkWarlock1_Conditions takes nothing returns boolean
    return GetUnitTypeId( udg_DamageEventTarget ) == 'e00D' and GetUnitLifePercent(udg_DamageEventTarget) <= 90
endfunction

function DarkWarDamage takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "bsdwd" ) )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bsdwdb" ) )
    local group g = CreateGroup()
    local unit u
    
    if GetUnitState( dummy, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) or GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 then
        call RemoveUnit(dummy)
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        call GroupEnumUnitsInRange( g, GetUnitX( dummy ), GetUnitY( dummy ), 125, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if unitst( u, dummy, "enemy" )  then
                call UnitDamageTarget( dummy, u, 30, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
            endif
            call GroupRemoveUnit(g,u)
            set u = FirstOfGroup(g)
        endloop
    endif
    
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
    set dummy = null
    set boss = null
endfunction

function DarkWarSpawn takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local integer id1
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bsdw" ) )
    local unit target = GroupPickRandomUnit(udg_otryad)
    
    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( boss ), 'u000', GetUnitX( target ), GetUnitY( target ), 270 )
        call UnitAddAbility( bj_lastCreatedUnit, 'A07O' )
        
        set id1 = GetHandleId( bj_lastCreatedUnit )
        if LoadTimerHandle( udg_hash, id1, StringHash( "bsdwd" ) ) == null  then
            call SaveTimerHandle( udg_hash, id1, StringHash( "bsdwd" ), CreateTimer() )
        endif
        set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "bsdwd" ) ) ) 
        call SaveUnitHandle( udg_hash, id1, StringHash( "bsdwd" ), bj_lastCreatedUnit )
        call SaveUnitHandle( udg_hash, id1, StringHash( "bsdwdb" ), boss )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "bsdwd" ) ), 1, true, function DarkWarDamage )     
    endif
    
    set boss = null
    set target = null
endfunction

function Trig_DarkWarlock1_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )
    
    call DisableTrigger( GetTriggeringTrigger() )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "bsdw" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bsdw" ), CreateTimer() )
    endif
    set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bsdw" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bsdw" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bsdw" ) ), bosscast(7), true, function DarkWarSpawn )
endfunction

//===========================================================================
function InitTrig_DarkWarlock1 takes nothing returns nothing
    set gg_trg_DarkWarlock1 = CreateTrigger(  )
    call DisableTrigger( gg_trg_DarkWarlock1 )
    call TriggerRegisterVariableEvent( gg_trg_DarkWarlock1, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_DarkWarlock1, Condition( function Trig_DarkWarlock1_Conditions ) )
    call TriggerAddAction( gg_trg_DarkWarlock1, function Trig_DarkWarlock1_Actions )
endfunction

