function Trig_GrandMage2_Conditions takes nothing returns boolean
    return GetUnitTypeId( udg_DamageEventTarget ) == 'h003' and GetUnitLifePercent(udg_DamageEventTarget) <= 80
endfunction

function GrandMage2Exp takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "bsgm1exp" ) )
    local group g = CreateGroup()
    local unit u
    
    call GroupEnumUnitsInRange( g, GetUnitX( dummy ), GetUnitY( dummy ), 200, null )
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if unitst( u, dummy, "enemy" ) then
            call UnitDamageTarget( dummy, u, 250, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
        endif
        call GroupRemoveUnit(g,u)
        set u = FirstOfGroup(g)
    endloop
    
    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Other\\Incinerate\\FireLordDeathExplode.mdl", GetUnitX( dummy ), GetUnitY( dummy ) ) )
    call RemoveUnit( dummy )
    call FlushChildHashtable( udg_hash, id )
    
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
    set dummy = null
endfunction

function GrandMage2Cast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local integer id1
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bsgm1" ) )
    local unit target = GroupPickRandomUnit(udg_otryad)

    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        call dummyspawn( boss, 5, 'A07D', 0, 'A136' )
        call IssuePointOrder( bj_lastCreatedUnit, "move", GetUnitX( target ), GetUnitY( target ) )
        
        set id1 = GetHandleId( bj_lastCreatedUnit )
        if LoadTimerHandle( udg_hash, id1, StringHash( "bsgm1exp" ) ) == null  then
            call SaveTimerHandle( udg_hash, id1, StringHash( "bsgm1exp" ), CreateTimer() )
        endif
        set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "bsgm1exp" ) ) ) 
        call SaveUnitHandle( udg_hash, id1, StringHash( "bsgm1exp" ), bj_lastCreatedUnit )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "bsgm1exp" ) ), bosscast(3), false, function GrandMage2Exp )
    endif
    
    set boss = null
    set target = null
endfunction

function Trig_GrandMage2_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )
    
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Weapons\\Bolt\\BoltImpact.mdl", udg_DamageEventTarget, "origin") )
    call DisableTrigger( GetTriggeringTrigger() )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "bsgm1" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bsgm1" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bsgm1" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bsgm1" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bsgm1" ) ), bosscast(8), true, function GrandMage2Cast )
endfunction

//===========================================================================
function InitTrig_GrandMage2 takes nothing returns nothing
    set gg_trg_GrandMage2 = CreateTrigger(  )
    call DisableTrigger( gg_trg_GrandMage2 )
    call TriggerRegisterVariableEvent( gg_trg_GrandMage2, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_GrandMage2, Condition( function Trig_GrandMage2_Conditions ) )
    call TriggerAddAction( gg_trg_GrandMage2, function Trig_GrandMage2_Actions )
endfunction

