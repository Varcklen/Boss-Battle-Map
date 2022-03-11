function Trig_Zapper2_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'n00Q' and GetUnitLifePercent(udg_DamageEventTarget) <= 90
endfunction

function Zapper2Move takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local integer counter = LoadInteger( udg_hash, id, StringHash( "bszp2" ) ) + 1
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bszp2b" ) )
    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "bszp2" ) )
    local real x = LoadReal( udg_hash, id, StringHash( "bszp2x" ) )
    local real y = LoadReal( udg_hash, id, StringHash( "bszp2y" ) )
    local real IfX = ( x - GetUnitX( dummy ) ) * ( x - GetUnitX( dummy ) )
    local real IfY = ( y - GetUnitY( dummy ) ) * ( y - GetUnitY( dummy ) )

    if GetUnitState( dummy, UNIT_STATE_LIFE) <= 0.405 or GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call RemoveUnit( dummy )
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    elseif counter >= 5 and SquareRoot( IfX + IfY ) < 100 then
        call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageDeathCaster.mdl", x, y ) )
        call RemoveUnit( dummy )
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        call SaveInteger( udg_hash, id, StringHash( "bszp2" ), counter )
    endif
    
    set dummy = null
    set boss = null
endfunction   

function Zapper2Saw takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local integer id1
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bszp2" ) )
    local unit u = GroupPickRandomUnit(udg_otryad)
    local real x = GetUnitX( u )
    local real y = GetUnitY( u )

    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        call SetUnitAnimation( boss, "attack" )
        call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageDeathCaster.mdl", GetUnitX(boss), GetUnitY(boss) ) )
        call dummyspawn( boss, 0, 'A137', 'A138', 0 )
        call SetUnitScale(bj_lastCreatedUnit, 2, 2, 2 )
        call IssuePointOrder( bj_lastCreatedUnit, "move", x, y )
        
        set id1 = GetHandleId( bj_lastCreatedUnit )
        if LoadTimerHandle( udg_hash, id1, StringHash( "bszp2" ) ) == null  then
            call SaveTimerHandle( udg_hash, id1, StringHash( "bszp2" ), CreateTimer() )
        endif
        set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "bszp2" ) ) ) 
        call SaveUnitHandle( udg_hash, id1, StringHash( "bszp2" ), bj_lastCreatedUnit )
        call SaveUnitHandle( udg_hash, id1, StringHash( "bszp2b" ), boss )
        call SaveReal( udg_hash, id1, StringHash( "bszp2x" ), x )
        call SaveReal( udg_hash, id1, StringHash( "bszp2y" ), y )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "bszp2" ) ), 1, true, function Zapper2Move )
    endif
    
    set u = null
    set boss = null
endfunction
    
function Trig_Zapper2_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )

    call DisableTrigger( GetTriggeringTrigger() )
    if LoadTimerHandle( udg_hash, id, StringHash( "bszp2" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bszp2" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bszp2" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bszp2" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bszp2" ) ), bosscast(10), true, function Zapper2Saw )
endfunction

//===========================================================================
function InitTrig_Zapper2 takes nothing returns nothing
    set gg_trg_Zapper2 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Zapper2 )
    call TriggerRegisterVariableEvent( gg_trg_Zapper2, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Zapper2, Condition( function Trig_Zapper2_Conditions ) )
    call TriggerAddAction( gg_trg_Zapper2, function Trig_Zapper2_Actions )
endfunction

