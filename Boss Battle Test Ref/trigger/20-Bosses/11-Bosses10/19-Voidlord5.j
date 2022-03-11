function Trig_Voidlord5_Conditions takes nothing returns boolean
    return GetUnitTypeId( udg_DamageEventTarget ) == 'n00C' and GetUnitLifePercent(udg_DamageEventTarget) <= 25
endfunction

function Voidlord5End takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "bbvd3" ) )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bbvd3b" ) )
    local integer c = LoadInteger( udg_hash, id, StringHash( "bbvd3" ) ) + 1
    
    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) or DistanceBetweenPoints(GetUnitLoc(boss), GetUnitLoc(u)) >= 800 then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
        call UnitRemoveAbility( u, 'A092' )
    	call UnitRemoveAbility( u, 'B05B' )
    elseif GetUnitAbilityLevel(u, 'B05B') > 0 and c >= 20 then
        if not(IsUnitHiddenBJ(u)) then
            call dummyspawn( boss, 1, 0, 0, 0 )
            call DestroyEffect( AddSpecialEffect( "CallOfAggression.mdx", GetUnitX( u ), GetUnitY( u ) ) )
            call UnitDamageTarget( bj_lastCreatedUnit, u, 1000, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
        endif
        call UnitRemoveAbility( u, 'A092' )
        call UnitRemoveAbility( u, 'B05B' )
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    else
        call SaveInteger( udg_hash, id, StringHash( "bbvd3" ), c )
    endif

    set u = null
    set boss = null
endfunction

function Trig_Voidlord5_Actions takes nothing returns nothing
    local integer cyclA = 1
    local integer id

    call DisableTrigger( GetTriggeringTrigger() )
    call TransmissionFromUnitWithNameBJ( bj_FORCE_ALL_PLAYERS, udg_DamageEventTarget, GetUnitName(udg_DamageEventTarget), null, "To the void!", bj_TIMETYPE_SET, 3, false )
    
	loop
		exitwhen cyclA > 4
		if GetUnitState( udg_hero[cyclA], UNIT_STATE_LIFE) > 0.405 then
			call PingMinimapLocForForceEx( bj_FORCE_ALL_PLAYERS, GetUnitLoc( udg_hero[cyclA] ), 2., bj_MINIMAPPINGSTYLE_ATTACK, 0, 0, 0 )
    			call UnitAddAbility( udg_hero[cyclA], 'A092')
        		set id = GetHandleId( udg_hero[cyclA] )
        		if LoadTimerHandle( udg_hash, id, StringHash( "bbvd3" ) ) == null  then
            			call SaveTimerHandle( udg_hash, id, StringHash( "bbvd3" ), CreateTimer() )
        		endif
        		set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bbvd3" ) ) ) 
        		call SaveUnitHandle( udg_hash, id, StringHash( "bbvd3" ), udg_hero[cyclA] )
			call SaveUnitHandle( udg_hash, id, StringHash( "bbvd3b" ), udg_DamageEventTarget )
        		call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_hero[cyclA] ), StringHash( "bbvd3" ) ), 0.5, true, function Voidlord5End )
		endif
		set cyclA = cyclA + 1
	endloop
endfunction

//===========================================================================
function InitTrig_Voidlord5 takes nothing returns nothing
    set gg_trg_Voidlord5 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Voidlord5 )
    call TriggerRegisterVariableEvent( gg_trg_Voidlord5, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Voidlord5, Condition( function Trig_Voidlord5_Conditions ) )
    call TriggerAddAction( gg_trg_Voidlord5, function Trig_Voidlord5_Actions )
endfunction

