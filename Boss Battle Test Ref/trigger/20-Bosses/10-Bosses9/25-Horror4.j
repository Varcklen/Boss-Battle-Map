function Trig_Horror4_Conditions takes nothing returns boolean
    return GetUnitTypeId( udg_DamageEventTarget ) == 'e002' and GetUnitLifePercent(udg_DamageEventTarget) <= 70
endfunction

function Horror4Cast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bshr4" ) )
    local integer i = GetRandomInt(1, 4)
    local real x 
    local real y
    
    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        set x = GetRectCenterX( udg_Boss_Rect ) + 2000 * Cos( ( 45 + ( 90 * i ) ) * bj_DEGTORAD )
        set y = GetRectCenterY( udg_Boss_Rect ) + 2000 * Sin( ( 45 + ( 90 * i ) ) * bj_DEGTORAD )
    	call CreateUnit( GetOwningPlayer( boss ), 'u007', x, y, 270 )	
    endif
    
    set boss = null
endfunction

function Trig_Horror4_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )
    
    call DisableTrigger( GetTriggeringTrigger() )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "bshr4" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bshr4" ), CreateTimer() )
    endif
    set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bshr4" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bshr4" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bshr4" ) ), bosscast(1), true, function Horror4Cast )
endfunction

//===========================================================================
function InitTrig_Horror4 takes nothing returns nothing
    set gg_trg_Horror4 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Horror4 )
    call TriggerRegisterVariableEvent( gg_trg_Horror4, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Horror4, Condition( function Trig_Horror4_Conditions ) )
    call TriggerAddAction( gg_trg_Horror4, function Trig_Horror4_Actions )
endfunction

