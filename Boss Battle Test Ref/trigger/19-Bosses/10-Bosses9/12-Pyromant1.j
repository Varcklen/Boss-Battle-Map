function Trig_Pyromant1_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'h00Z' and GetUnitLifePercent(udg_DamageEventTarget) <= 90
endfunction

function PyroEnd takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bspr1" ) )
    local integer cyclA = 1
    local real NewX
    local real NewY
    local real x = LoadReal( udg_hash, id, StringHash( "bspr1x" ) )
    local real y = LoadReal( udg_hash, id, StringHash( "bspr1y" ) )
    
    call PauseUnit( boss, false )
    if GetUnitState( boss, UNIT_STATE_LIFE) > 0.405 and ( udg_fightmod[0] ) then
        loop
            exitwhen cyclA > 5
            set NewX = x + 500 * Cos( 72 * cyclA * 0.0174 )
            set NewY = y + 500 * Sin( 72 * cyclA * 0.0174 )
            set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( boss ), 'u01J', NewX, NewY, 72 * cyclA )
            call UnitApplyTimedLife( bj_lastCreatedUnit, 'BTLF', 1)
            call IssuePointOrder( bj_lastCreatedUnit, "carrionswarm", x, y )
            set cyclA = cyclA + 1
        endloop
    endif
    call FlushChildHashtable( udg_hash, id )
    
    set boss = null
endfunction

function PyroCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bspr" ) )
    local integer id1 = GetHandleId( boss )

    if GetUnitLifePercent( boss ) <= 25 or not( udg_fightmod[0] ) then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        call PauseUnit( boss, true )
        call SetUnitAnimation( boss, "spell" )
        set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( boss ), 'u000', GetUnitX( boss ), GetUnitY( boss ), 270 )
        call SetUnitScale(bj_lastCreatedUnit, 3, 3, 3 )
        call UnitAddAbility( bj_lastCreatedUnit, 'A136')
        call UnitApplyTimedLife(bj_lastCreatedUnit, 'BTLF', 1.5)
        
        if LoadTimerHandle( udg_hash, id1, StringHash( "bspr1" ) ) == null  then
            call SaveTimerHandle( udg_hash, id1, StringHash( "bspr1" ), CreateTimer() )
        endif
        set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "bspr1" ) ) ) 
        call SaveUnitHandle( udg_hash, id1, StringHash( "bspr1" ), boss )
        call SaveReal( udg_hash, id1, StringHash( "bspr1x" ), GetUnitX( boss ) )
        call SaveReal( udg_hash, id1, StringHash( "bspr1y" ), GetUnitY( boss ) )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( boss ), StringHash( "bspr1" ) ), bosscast(1.5), false, function PyroEnd )
    endif
    
    set boss = null
endfunction

function Trig_Pyromant1_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )

    call DisableTrigger( GetTriggeringTrigger() )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "bspr" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bspr" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bspr" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bspr" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bspr" ) ), bosscast(10), true, function PyroCast )
endfunction

//===========================================================================
function InitTrig_Pyromant1 takes nothing returns nothing
    set gg_trg_Pyromant1 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Pyromant1 )
    call TriggerRegisterVariableEvent( gg_trg_Pyromant1, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Pyromant1, Condition( function Trig_Pyromant1_Conditions ) )
    call TriggerAddAction( gg_trg_Pyromant1, function Trig_Pyromant1_Actions )
endfunction

