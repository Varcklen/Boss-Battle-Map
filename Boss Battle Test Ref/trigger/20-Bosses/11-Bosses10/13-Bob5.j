function Trig_Bob5_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'n00A' and not(IsUnitHidden(udg_DamageEventTarget))
endfunction

function Bob1Spawn takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "bbbb" ) )
        
    if GetUnitState( u, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call RemoveUnit( u )
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( u ), udg_Database_IA_Unit[GetRandomInt( 1, udg_Database_NumberItems[33] )], GetUnitX( u ), GetUnitY( u ), GetRandomReal( 0, 360 ) )
        call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Orc\\FeralSpirit\\feralspirittarget.mdl", bj_lastCreatedUnit, "origin") )
    endif

    set u = null
endfunction

function Bob1Cast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "bbbb1" ) )

    call UnitRemoveAbility( u, 'A096' )
    call UnitRemoveAbility( u, 'B05Z' )
    call FlushChildHashtable( udg_hash, id )

	set u = null
endfunction

function Trig_Bob5_Actions takes nothing returns nothing
    local unit u = udg_DamageEventTarget
    local integer id = GetHandleId( u )
    local real x
    local real y
    local integer id1
    local integer cyclA

    call DisableTrigger( GetTriggeringTrigger() )  
	call UnitAddAbility( u, 'A096' )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "bbbb1" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bbbb1" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bbbb1" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "bbbb1" ), u )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( u ), StringHash( "bbbb1" ) ), 20, false, function Bob1Cast )

    set cyclA = 1
    loop
        exitwhen cyclA > 4
        set x = GetRectCenterX( udg_Boss_Rect ) + 2500 * Cos( ( 135 + ( 90 * cyclA ) ) * bj_DEGTORAD )
        set y = GetRectCenterY( udg_Boss_Rect ) + 2500 * Sin( ( 135 + ( 90 * cyclA ) ) * bj_DEGTORAD )
        set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( u ), 'h00J', x, y, (90 * cyclA)-45 )
        call SetUnitAnimation( bj_lastCreatedUnit, "birth" )

        set id1 = GetHandleId( bj_lastCreatedUnit )
        if LoadTimerHandle( udg_hash, id1, StringHash( "bbbb" ) ) == null  then
                call SaveTimerHandle( udg_hash, id1, StringHash( "bbbb" ), CreateTimer() )
        endif
        set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "bbbb" ) ) ) 
        call SaveUnitHandle( udg_hash, id1, StringHash( "bbbb" ), bj_lastCreatedUnit )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "bbbb" ) ), bosscast(15), true, function Bob1Spawn )
        set cyclA = cyclA + 1
    endloop
    
    set u = null
endfunction

//===========================================================================
function InitTrig_Bob5 takes nothing returns nothing
    set gg_trg_Bob5 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Bob5 )
    call TriggerRegisterVariableEvent( gg_trg_Bob5, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Bob5, Condition( function Trig_Bob5_Conditions ) )
    call TriggerAddAction( gg_trg_Bob5, function Trig_Bob5_Actions )
endfunction

