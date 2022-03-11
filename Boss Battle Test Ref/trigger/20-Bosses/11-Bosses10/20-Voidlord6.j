function Trig_Voidlord6_Conditions takes nothing returns boolean
    return GetUnitTypeId( udg_DamageEventTarget ) == 'n00C' and GetUnitLifePercent(udg_DamageEventTarget) <= 10
endfunction

function Trig_Voidlord6_Actions takes nothing returns nothing
    local integer cyclA = 1
    local integer id

    call DisableTrigger( GetTriggeringTrigger() )
    call TransmissionFromUnitWithNameBJ( bj_FORCE_ALL_PLAYERS, udg_DamageEventTarget, GetUnitName(udg_DamageEventTarget), null, "For the void!", bj_TIMETYPE_SET, 3, false )
	loop
		exitwhen cyclA > 4
		if GetUnitState( udg_hero[cyclA], UNIT_STATE_LIFE) > 0.405 then
			set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( udg_DamageEventTarget ), 'u000', GetUnitX( udg_hero[cyclA] ), GetUnitY( udg_hero[cyclA] ), 270 )
        		call SetUnitScale(bj_lastCreatedUnit, 3, 3, 3 )
        		call UnitAddAbility( bj_lastCreatedUnit, 'A136')
        
        		set id = GetHandleId( bj_lastCreatedUnit )
        		if LoadTimerHandle( udg_hash, id, StringHash( "bbvd2" ) ) == null  then
            			call SaveTimerHandle( udg_hash, id, StringHash( "bbvd2" ), CreateTimer() )
        		endif
        		set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bbvd2" ) ) ) 
        		call SaveUnitHandle( udg_hash, id, StringHash( "bbvd2" ), bj_lastCreatedUnit )
        		call SaveUnitHandle( udg_hash, id, StringHash( "bbvd2u" ), udg_DamageEventTarget )
        		call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "bbvd2" ) ), bosscast(5), false, function Voidlord4End )
		endif
		set cyclA = cyclA + 1
	endloop
endfunction

//===========================================================================
function InitTrig_Voidlord6 takes nothing returns nothing
    set gg_trg_Voidlord6 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Voidlord6 )
    call TriggerRegisterVariableEvent( gg_trg_Voidlord6, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Voidlord6, Condition( function Trig_Voidlord6_Conditions ) )
    call TriggerAddAction( gg_trg_Voidlord6, function Trig_Voidlord6_Actions )
endfunction

