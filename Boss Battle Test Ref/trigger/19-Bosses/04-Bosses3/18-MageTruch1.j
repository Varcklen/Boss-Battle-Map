function Trig_gg_trg_MageTruch1_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'n03L'
endfunction

function MageTruch1Cast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bsmtr" ) )
    local integer rand = GetRandomInt( 1, 3 )
    
    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        set udg_RandomLogic = true
        set udg_Caster = boss
        set udg_Level = 2
        call TriggerExecute( udg_DB_Trigger_Two[GetRandomInt( 1, udg_Database_NumberItems[15])] )
    endif
    
    set boss = null
 endfunction  

function Trig_gg_trg_MageTruch1_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )

    call DisableTrigger( GetTriggeringTrigger() )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "bsmtr" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bsmtr" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bsmtr" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bsmtr" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bsmtr" ) ), bosscast(10), true, function MageTruch1Cast )
endfunction

//===========================================================================
function InitTrig_MageTruch1 takes nothing returns nothing
    set gg_trg_MageTruch1 = CreateTrigger()
    call DisableTrigger( gg_trg_MageTruch1 )
    call TriggerRegisterVariableEvent( gg_trg_MageTruch1, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_MageTruch1, Condition( function Trig_gg_trg_MageTruch1_Conditions ) )
    call TriggerAddAction( gg_trg_MageTruch1, function Trig_gg_trg_MageTruch1_Actions )
endfunction

