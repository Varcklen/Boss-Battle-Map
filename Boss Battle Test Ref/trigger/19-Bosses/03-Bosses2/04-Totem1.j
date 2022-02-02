function Trig_Totem1_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'o007' and GetUnitLifePercent( udg_DamageEventTarget ) <= 90
endfunction

function TotemCast1 takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bstm2" ) )
    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "bstm2d" ) )
    local integer counter = LoadInteger( udg_hash, id, StringHash( "bstm2" ) ) + 1
    local group g = CreateGroup()
    local unit u
    
    call SaveInteger( udg_hash, id, StringHash( "bstm2" ), counter )
    if counter >= 8 then
        call RemoveUnit( dummy )
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        call GroupEnumUnitsInRange( g, GetUnitX( dummy ), GetUnitY( dummy ), 200, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if unitst( u, boss, "enemy" ) then
                call UnitDamageTarget( dummy, u, 45, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )
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
    
function TotemCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bstm1" ))
    local integer id1 = GetHandleId( boss )
    
    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( boss ), 'u000', GetUnitX( boss ) + GetRandomReal(-400, 400), GetUnitY( boss ) + GetRandomReal(-400, 400), 270 )
        call spectime("Abilities\\Spells\\Human\\FlameStrike\\FlameStrike1.mdl", GetUnitX( bj_lastCreatedUnit ), GetUnitY( bj_lastCreatedUnit ), 8 )
           
        if LoadTimerHandle( udg_hash, id1, StringHash( "bstm2" ) ) == null  then
            call SaveTimerHandle( udg_hash, id1, StringHash( "bstm2" ), CreateTimer() )
        endif
        set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "bstm2" ) ) ) 
        call SaveUnitHandle( udg_hash, id1, StringHash( "bstm2" ), boss )
        call SaveUnitHandle( udg_hash, id1, StringHash( "bstm2d" ), bj_lastCreatedUnit )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( boss ), StringHash( "bstm2" ) ), 0.5, true, function TotemCast1 )
    endif
    
    set boss = null
endfunction

function Trig_Totem1_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )

    call DisableTrigger( GetTriggeringTrigger() )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "bstm1" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bstm1" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bstm1" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bstm1" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bstm1" ) ), bosscast(5), true, function TotemCast )
endfunction

//===========================================================================
function InitTrig_Totem1 takes nothing returns nothing
    set gg_trg_Totem1 = CreateTrigger()
    call DisableTrigger( gg_trg_Totem1 )
    call TriggerRegisterVariableEvent( gg_trg_Totem1, "udg_DamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Totem1, Condition( function Trig_Totem1_Conditions ) )
    call TriggerAddAction( gg_trg_Totem1, function Trig_Totem1_Actions )
endfunction

