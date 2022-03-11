function Trig_Bob2_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'n00A' and GetUnitLifePercent(udg_DamageEventTarget) <= 80
endfunction

function Bob2Down takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bbbb5" ))
    local unit d = LoadUnitHandle( udg_hash, id, StringHash( "bbbb5d" ))
    local integer id1 = GetHandleId( boss )
    local real x = LoadReal( udg_hash, id, StringHash( "bbbb5x" ) )
    local real y = LoadReal( udg_hash, id, StringHash( "bbbb5y" ) )

    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call RemoveUnit(boss)
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        call SetUnitPathing( boss, true )
        call UnitRemoveAbility( boss, 'Amrf' )
        call pausest( boss, -1 )
        call UnitRemoveAbility( boss, 'A04W' )
        call GroupAoE(boss, d, GetUnitX( boss ), GetUnitY( boss ), 500, 300, "enemy", "Abilities\\Spells\\Human\\ThunderClap\\ThunderClapCaster.mdl", null )
	    call RemoveUnit( d )
        call FlushChildHashtable( udg_hash, id ) 
    endif
    
    set d = null
    set boss = null
endfunction

function Bob2Wait takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bbbb4" ))
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "bbbb4d" ))
    local integer id1 = GetHandleId( boss )
    local real x = LoadReal( udg_hash, id, StringHash( "bbbb4x" ) )
    local real y = LoadReal( udg_hash, id, StringHash( "bbbb4y" ) )

    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call RemoveUnit(boss)
        call FlushChildHashtable( udg_hash, id )
    else
 	    call SetUnitPosition( boss, x, y )
	    call ShowUnitShow( boss )
            call SetUnitFlyHeight( boss, -600, 3000 )
            
            if LoadTimerHandle( udg_hash, id1, StringHash( "bbbb5" ) ) == null  then
                call SaveTimerHandle( udg_hash, id1, StringHash( "bbbb5" ), CreateTimer() )
            endif
            set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "bbbb5" ) ) )
            call SaveUnitHandle( udg_hash, id1, StringHash( "bbbb5" ), boss )
	    call SaveUnitHandle( udg_hash, id1, StringHash( "bbbb5d" ), u )
            call SaveReal( udg_hash, id1, StringHash( "bbbb5x" ), x )
	    call SaveReal( udg_hash, id1, StringHash( "bbbb5y" ), y )
            call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( boss ), StringHash( "bbbb5" ) ), 0.35, false, function Bob2Down ) 
    endif
    
    set boss = null
    set u = null
endfunction

function Bob2Up takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bbbb3" ))
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "bbbb3d" ))
    local integer id1 = GetHandleId( boss )
    local real x = LoadReal( udg_hash, id, StringHash( "bbbb3x" ) )
    local real y = LoadReal( udg_hash, id, StringHash( "bbbb3y" ) )

    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call FlushChildHashtable( udg_hash, id )
    else
        call ShowUnitHide( boss )
            
        if LoadTimerHandle( udg_hash, id1, StringHash( "bbbb4" ) ) == null  then
            call SaveTimerHandle( udg_hash, id1, StringHash( "bbbb4" ), CreateTimer() )
        endif
        set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "bbbb4" ) ) )
        call SaveUnitHandle( udg_hash, id1, StringHash( "bbbb4" ), boss )
	    call SaveUnitHandle( udg_hash, id1, StringHash( "bbbb4d" ), u )
        call SaveReal( udg_hash, id1, StringHash( "bbbb4x" ), x )
	    call SaveReal( udg_hash, id1, StringHash( "bbbb4y" ), y )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( boss ), StringHash( "bbbb4" ) ), 1.7, false, function Bob2Wait ) 
    endif
    
    set boss = null
    set u = null
endfunction

function Bob2Cast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local real x
    local real y
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bbbb2" ))
    local integer id1 = GetHandleId( boss )
    local unit target 

    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call FlushChildHashtable( udg_hash, id )
    else
        set target = GroupPickRandomUnit(udg_otryad)
        if target != null then
            set x = GetUnitX( target ) 
            set y = GetUnitY( target )
    		call pausest( boss, 1 )
            call UnitAddAbility( boss, 'Amrf' )
            call SetUnitFlyHeight( boss, 600, 3000 )
            call SetUnitPathing( boss, true )
            call UnitAddAbility( boss, 'A04W' )
            set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( boss ), 'u000', x, y, 270 )
            call SetUnitScale(bj_lastCreatedUnit, 3, 3, 3 )
            call UnitAddAbility( bj_lastCreatedUnit, 'A136')
            
            if LoadTimerHandle( udg_hash, id1, StringHash( "bbbb3" ) ) == null  then
                call SaveTimerHandle( udg_hash, id1, StringHash( "bbbb3" ), CreateTimer() )
            endif
            set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "bbbb3" ) ) )
            call SaveUnitHandle( udg_hash, id1, StringHash( "bbbb3" ), boss )
            call SaveUnitHandle( udg_hash, id1, StringHash( "bbbb3d" ), bj_lastCreatedUnit )
            call SaveReal( udg_hash, id1, StringHash( "bbbb3x" ), x )
            call SaveReal( udg_hash, id1, StringHash( "bbbb3y" ), y )
            call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( boss ), StringHash( "bbbb3" ) ), 0.35, false, function Bob2Up ) 
        endif
    endif
    
    set boss = null
    set target = null
endfunction

function Trig_Bob2_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )

    call DisableTrigger( GetTriggeringTrigger() )    

    if LoadTimerHandle( udg_hash, id, StringHash( "bbbb2" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bbbb2" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bbbb2" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bbbb2" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bbbb2" ) ), bosscast(15), true, function Bob2Cast )
endfunction

//===========================================================================
function InitTrig_Bob2 takes nothing returns nothing
    set gg_trg_Bob2 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Bob2 )
    call TriggerRegisterVariableEvent( gg_trg_Bob2, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Bob2, Condition( function Trig_Bob2_Conditions ) )
    call TriggerAddAction( gg_trg_Bob2, function Trig_Bob2_Actions )
endfunction

