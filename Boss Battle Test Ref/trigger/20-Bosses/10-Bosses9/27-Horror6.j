function Trig_Horror6_Conditions takes nothing returns boolean
    return GetUnitTypeId( udg_DamageEventTarget ) == 'e002' and GetUnitLifePercent(udg_DamageEventTarget) <= 40
endfunction

function Trig_Horror6_Actions takes nothing returns nothing
    local integer cyclA = 1
    local integer id

    call DisableTrigger( GetTriggeringTrigger() )
    
	loop
		exitwhen cyclA > 4
		if GetUnitState( udg_hero[cyclA], UNIT_STATE_LIFE) > 0.405 then
			call PingMinimapLocForForceEx( bj_FORCE_ALL_PLAYERS, GetUnitLoc( udg_hero[cyclA] ), 2., bj_MINIMAPPINGSTYLE_ATTACK, 0, 0, 0 )
    			call UnitAddAbility( udg_hero[cyclA], 'A092')
        		set id = GetHandleId( udg_hero[cyclA] )
        		if LoadTimerHandle( udg_hash, id, StringHash( "bshr5" ) ) == null  then
            			call SaveTimerHandle( udg_hash, id, StringHash( "bshr5" ), CreateTimer() )
        		endif
        		set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bshr5" ) ) ) 
        		call SaveUnitHandle( udg_hash, id, StringHash( "bshr5" ), udg_hero[cyclA] )
			call SaveUnitHandle( udg_hash, id, StringHash( "bshr5b" ), udg_DamageEventTarget )
        		call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_hero[cyclA] ), StringHash( "bshr5" ) ), bosscast(5), false, function Horror5End )
		endif
		set cyclA = cyclA + 1
	endloop
endfunction

//===========================================================================
function InitTrig_Horror6 takes nothing returns nothing
    set gg_trg_Horror6 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Horror6 )
    call TriggerRegisterVariableEvent( gg_trg_Horror6, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Horror6, Condition( function Trig_Horror6_Conditions ) )
    call TriggerAddAction( gg_trg_Horror6, function Trig_Horror6_Actions )
endfunction

