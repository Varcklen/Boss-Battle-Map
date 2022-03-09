function Trig_Azgalor2_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'h011' and GetUnitLifePercent(udg_DamageEventTarget) <= 75
endfunction

function Azg2End takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local group g = CreateGroup()
    local unit u
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bszg2" ) )
    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "bszg2d" ) )
    local real x = LoadReal( udg_hash, id, StringHash( "bszg2x" ) )
    local real y = LoadReal( udg_hash, id, StringHash( "bszg2y" ) )
    
    if GetUnitState( boss, UNIT_STATE_LIFE) > 0.405 and udg_fightmod[0] then
        call GroupEnumUnitsInRange( g, x, y, 600, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if unitst( u, boss, "enemy" )  then
                call UnitDamageTarget( dummy, u, 200, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )
            endif
            call GroupRemoveUnit(g,u)
        endloop
    endif
    
    call RemoveUnit( dummy )
    call FlushChildHashtable( udg_hash, id )
    
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
    set boss = null
    set dummy = null
endfunction

function Azg2Cast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bszg1" ) )
    local integer id1 = GetHandleId( boss )
    local real x = GetUnitX( boss )
    local real y = GetUnitY( boss )

    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl", boss, "origin") )
        call SetUnitAnimation( boss, "spell slam" )
        call QueueUnitAnimation( boss, "stand" )
        call dummyspawn( boss, 2, 'A0AO', 0, 0 )
        call IssuePointOrder( bj_lastCreatedUnit, "rainoffire", GetUnitX( bj_lastCreatedUnit ), GetUnitY( bj_lastCreatedUnit ) )
        
        if LoadTimerHandle( udg_hash, id1, StringHash( "bszg2" ) ) == null  then
            call SaveTimerHandle( udg_hash, id1, StringHash( "bszg2" ), CreateTimer() )
        endif
        set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "bszg2" ) ) ) 
        call SaveUnitHandle( udg_hash, id1, StringHash( "bszg2" ), boss )
        call SaveUnitHandle( udg_hash, id1, StringHash( "bszg2d" ), bj_lastCreatedUnit )
        call SaveReal( udg_hash, id1, StringHash( "bszg2x" ), x )
        call SaveReal( udg_hash, id1, StringHash( "bszg2y" ), y )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( boss ), StringHash( "bszg2" ) ), 1.25, false, function Azg2End )
    endif
    
    set boss = null
endfunction

function Trig_Azgalor2_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )

    call DisableTrigger( GetTriggeringTrigger() )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "bszg1" ) ) == null then 
        call SaveTimerHandle( udg_hash, id, StringHash( "bszg1" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bszg1" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bszg1" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bszg1" ) ), bosscast(12), true, function Azg2Cast )
endfunction

//===========================================================================
function InitTrig_Azgalor2 takes nothing returns nothing
    set gg_trg_Azgalor2 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Azgalor2 )
    call TriggerRegisterVariableEvent( gg_trg_Azgalor2, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Azgalor2, Condition( function Trig_Azgalor2_Conditions ) )
    call TriggerAddAction( gg_trg_Azgalor2, function Trig_Azgalor2_Actions )
endfunction

