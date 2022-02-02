function Trig_Bob4_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'n00A' and GetUnitLifePercent(udg_DamageEventTarget) <= 30
endfunction

function Bob4Cast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "bbbb1" ) )

    call UnitRemoveAbility( u, 'A096' )
    call UnitRemoveAbility( u, 'B05Z' )
    call FlushChildHashtable( udg_hash, id )

	set u = null
endfunction

function Trig_Bob4_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )
    
    call DisableTrigger( GetTriggeringTrigger() )
    call TransmissionFromUnitWithNameBJ( bj_FORCE_ALL_PLAYERS, udg_DamageEventTarget, GetUnitName(udg_DamageEventTarget), null, "GAAAAH!", bj_TIMETYPE_SET, 3, false )
    call DestroyEffect(AddSpecialEffectTarget( "Abilities\\Spells\\NightElf\\Taunt\\TauntCaster.mdl", udg_DamageEventTarget, "origin") )
    call UnitAddAbility( udg_DamageEventTarget, 'A096' )

    	if LoadTimerHandle( udg_hash, id, StringHash( "bbbb6" ) ) == null  then
        	call SaveTimerHandle( udg_hash, id, StringHash( "bbbb6" ), CreateTimer() )
    	endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bbbb6" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "bbbb6" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bbbb6" ) ), 60, false, function Bob4Cast )
endfunction

//===========================================================================
function InitTrig_Bob4 takes nothing returns nothing
    set gg_trg_Bob4 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Bob4 )
    call TriggerRegisterVariableEvent( gg_trg_Bob4, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Bob4, Condition( function Trig_Bob4_Conditions ) )
    call TriggerAddAction( gg_trg_Bob4, function Trig_Bob4_Actions )
endfunction

