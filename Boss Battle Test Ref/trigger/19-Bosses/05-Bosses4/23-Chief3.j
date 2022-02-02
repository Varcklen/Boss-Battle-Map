function Trig_Chief3_Conditions takes nothing returns boolean
    return GetUnitTypeId( udg_DamageEventTarget ) == 'h01X'
endfunction

function Chief3Exp takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "bscf1" ) )
    local unit target = LoadUnitHandle( udg_hash, id, StringHash( "bscf1t" ) )
    local group g = CreateGroup()
    local unit u
    
    call GroupEnumUnitsInRange( g, GetUnitX( dummy ), GetUnitY( dummy ), 300, null )
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if unitst( u, dummy, "enemy" ) and u != target then
    		call DestroyEffect( AddSpecialEffect( "Objects\\Spawnmodels\\NightElf\\NECancelDeath\\NECancelDeath.mdl", GetUnitX( u ), GetUnitY( u ) ) )
        	call SetUnitState( u, UNIT_STATE_MANA, RMaxBJ(0,GetUnitState( u, UNIT_STATE_MANA) - (udg_SpellDamage[0]*0.4*GetUnitState( u, UNIT_STATE_MAX_MANA)) ))
		if not(IsUnitType( u, UNIT_TYPE_HERO)) and not(IsUnitType( u, UNIT_TYPE_ANCIENT)) then
			call KillUnit( u )
		endif
        endif
        call GroupRemoveUnit(g,u)
        set u = FirstOfGroup(g)
    endloop

    call RemoveUnit( dummy )
    call FlushChildHashtable( udg_hash, id )
    
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
    set dummy = null
    set target = null
endfunction

function Chief3Move takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "bscf2" ) )
    local unit target = LoadUnitHandle( udg_hash, id, StringHash( "bscf2t" ) )

    if GetUnitState( target, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) or GetUnitState( dummy, UNIT_STATE_LIFE) <= 0.405 then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        call IssuePointOrder( dummy, "move", GetUnitX( target ), GetUnitY( target ) )
    endif
    
    set dummy = null
    set target = null
endfunction

function Chief3Cast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local integer id1
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bscf" ) )
    local unit target = GroupPickRandomUnit(udg_otryad)

    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        call dummyspawn( boss, 5, 'A16Y', 0, 'A136' )
        call SetUnitScale(bj_lastCreatedUnit, 3, 3, 3 )
        call IssuePointOrder( bj_lastCreatedUnit, "move", GetUnitX( target ), GetUnitY( target ) )
        
        set id1 = GetHandleId( bj_lastCreatedUnit )
        if LoadTimerHandle( udg_hash, id1, StringHash( "bscf1" ) ) == null  then
            call SaveTimerHandle( udg_hash, id1, StringHash( "bscf1" ), CreateTimer() )
        endif
        set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "bscf1" ) ) ) 
        call SaveUnitHandle( udg_hash, id1, StringHash( "bscf1" ), bj_lastCreatedUnit )
        call SaveUnitHandle( udg_hash, id1, StringHash( "bscf1t" ), target )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "bscf1" ) ), bosscast(3), false, function Chief3Exp )

        set id1 = GetHandleId( bj_lastCreatedUnit )
        if LoadTimerHandle( udg_hash, id1, StringHash( "bscf2" ) ) == null  then
            call SaveTimerHandle( udg_hash, id1, StringHash( "bscf2" ), CreateTimer() )
        endif
        set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "bscf2" ) ) ) 
        call SaveUnitHandle( udg_hash, id1, StringHash( "bscf2" ), bj_lastCreatedUnit )
        call SaveUnitHandle( udg_hash, id1, StringHash( "bscf2t" ), target )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "bscf2" ) ), 0.5, true, function Chief3Move )
    endif
    
    set boss = null
    set target = null
endfunction

function Trig_Chief3_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )
    
    call DisableTrigger( GetTriggeringTrigger() )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "bscf" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bscf" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bscf" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bscf" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bscf" ) ), bosscast(12), true, function Chief3Cast )
endfunction

//===========================================================================
function InitTrig_Chief3 takes nothing returns nothing
    set gg_trg_Chief3 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Chief3 )
    call TriggerRegisterVariableEvent( gg_trg_Chief3, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Chief3, Condition( function Trig_Chief3_Conditions ) )
    call TriggerAddAction( gg_trg_Chief3, function Trig_Chief3_Actions )
endfunction

