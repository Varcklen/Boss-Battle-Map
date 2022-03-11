function Trig_Berserk2_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'e00F' and GetUnitLifePercent(udg_DamageEventTarget) <= 75
endfunction

function BerserkMove takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bsbk2b" ) )
    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "bsbk2" ) )
    local unit target
    local real x = LoadReal( udg_hash, id, StringHash( "bsbk2x" ) )
    local real y = LoadReal( udg_hash, id, StringHash( "bsbk2y" ) )
    local real IfX = ( x - GetUnitX( dummy ) ) * ( x - GetUnitX( dummy ) )
    local real IfY = ( y - GetUnitY( dummy ) ) * ( y - GetUnitY( dummy ) )
    
    if not( udg_fightmod[0] ) or GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 then
        call RemoveUnit( dummy )
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    elseif SquareRoot( IfX + IfY ) < 70 then
        set target = GroupPickRandomUnit(udg_otryad)
        set x = GetUnitX( target )
        set y = GetUnitY( target )
        call SaveReal( udg_hash, id, StringHash( "bsbk2x" ), x )
        call SaveReal( udg_hash, id, StringHash( "bsbk2y" ), y )
        call IssuePointOrder( dummy, "move", x, y )
    endif
    
    set dummy = null
    set target = null
    set boss = null
endfunction   
    
function Trig_Berserk2_Actions takes nothing returns nothing
    local integer id
    local unit u = GroupPickRandomUnit(udg_otryad)
    local real x = GetUnitX( u )
    local real y = GetUnitY( u )

    call DisableTrigger( GetTriggeringTrigger() )
    set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( udg_DamageEventTarget ), 'u000', GetUnitX( udg_DamageEventTarget ), GetUnitY( udg_DamageEventTarget ), 270 )
    call UnitAddAbility( bj_lastCreatedUnit, 'A0Y5')
    call UnitAddAbility( bj_lastCreatedUnit, 'A071')
    call IssuePointOrder( bj_lastCreatedUnit, "move", x, y )
    
    set id = GetHandleId( bj_lastCreatedUnit )
    call DestroyTimer( LoadTimerHandle( udg_hash, id, StringHash( "bsbk2" )))
    call FlushChildHashtable( udg_hash, id )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "bsbk2" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bsbk2" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bsbk2" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bsbk2" ), bj_lastCreatedUnit )
    call SaveUnitHandle( udg_hash, id, StringHash( "bsbk2b" ), udg_DamageEventTarget )
    call SaveReal( udg_hash, id, StringHash( "bsbk2x" ), x )
    call SaveReal( udg_hash, id, StringHash( "bsbk2y" ), y )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "bsbk2" ) ), 0.5, true, function BerserkMove )
    
    set u = null
endfunction

//===========================================================================
function InitTrig_Berserk2 takes nothing returns nothing
    set gg_trg_Berserk2 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Berserk2 )
    call TriggerRegisterVariableEvent( gg_trg_Berserk2, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Berserk2, Condition( function Trig_Berserk2_Conditions ) )
    call TriggerAddAction( gg_trg_Berserk2, function Trig_Berserk2_Actions )
endfunction

