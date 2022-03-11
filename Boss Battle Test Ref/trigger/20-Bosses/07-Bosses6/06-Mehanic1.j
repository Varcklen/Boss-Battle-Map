function Trig_Mehanic1_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'h010'
endfunction

function MehanicCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bsmc" ) )
    
    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        set udg_Caster = boss
    	set udg_RandomLogic = true
        call TriggerExecute( udg_DB_MechUse[GetRandomInt( 1, udg_Database_NumberItems[35])] )
    endif

    set boss = null
endfunction

function Trig_Mehanic1_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )

    call DisableTrigger( GetTriggeringTrigger() )
    call SetCount_SetPiece( udg_DamageEventTarget, SET_MECH, 3 )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "bsmc" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bsmc" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bsmc" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bsmc" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bsmc" ) ), bosscast(14), true, function MehanicCast )
endfunction

//===========================================================================
function InitTrig_Mehanic1 takes nothing returns nothing
    set gg_trg_Mehanic1 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Mehanic1 )
    call TriggerRegisterVariableEvent( gg_trg_Mehanic1, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Mehanic1, Condition( function Trig_Mehanic1_Conditions ) )
    call TriggerAddAction( gg_trg_Mehanic1, function Trig_Mehanic1_Actions )
endfunction

