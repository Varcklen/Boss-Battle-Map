//TESH.scrollpos=17
//TESH.alwaysfold=0
function Trig_DrunkMan1_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'n02U'
endfunction

function DrunkMan1Cast1 takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local integer cyclA = 1
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bsdm2" ) )

    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        loop
            exitwhen cyclA > 4
            if GetUnitState( udg_hero[cyclA], UNIT_STATE_LIFE ) > 0.405 and GetUnitAbilityLevel( udg_hero[cyclA], 'BNdh' ) > 0 then
                call IssuePointOrderLoc( udg_hero[cyclA], "move", GetRandomLocInRect(udg_Boss_Rect) )
            endif
            set cyclA = cyclA + 1
        endloop
    endif
    
    set boss = null
endfunction

function DrunkMan1Cast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bsdm1" ) )
    local unit u = randomtarget( boss, 900, "enemy", "", "", "", "" )

    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    elseif u != null then
        call SetUnitAnimation( boss, "attack" )    
        call dummyspawn( boss, 1, 'A0XQ', 0, 0 )
        call IssueTargetOrder( bj_lastCreatedUnit, "drunkenhaze", u )
    endif
    
    set u = null
    set boss = null
endfunction

function Trig_DrunkMan1_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )

    call DisableTrigger( GetTriggeringTrigger() )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "bsdm1" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bsdm1" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bsdm1" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bsdm1" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bsdm1" ) ), bosscast(8), true, function DrunkMan1Cast )
    
    set id = GetHandleId( udg_DamageEventTarget )
    if LoadTimerHandle( udg_hash, id, StringHash( "bsdm2" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bsdm2" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bsdm2" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bsdm2" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bsdm2" ) ), bosscast(4), true, function DrunkMan1Cast1 )
endfunction

//===========================================================================
function InitTrig_DrunkMan1 takes nothing returns nothing
    set gg_trg_DrunkMan1 = CreateTrigger(  )
    call DisableTrigger( gg_trg_DrunkMan1 )
    call TriggerRegisterVariableEvent( gg_trg_DrunkMan1, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_DrunkMan1, Condition( function Trig_DrunkMan1_Conditions ) )
    call TriggerAddAction( gg_trg_DrunkMan1, function Trig_DrunkMan1_Actions )
endfunction

