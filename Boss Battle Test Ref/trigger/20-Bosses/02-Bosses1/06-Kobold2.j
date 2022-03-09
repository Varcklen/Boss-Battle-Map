function Trig_Kobold2_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'n00P'
endfunction

function CoboldCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bscb" ) )
    local group g = CreateGroup()
    local unit u

    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    else
        call SetUnitAnimationByIndex( boss, 8 )
        call QueueUnitAnimation( boss, "stand" )
        call GroupEnumUnitsInRange( g, GetUnitX( boss ), GetUnitY( boss ), 600, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if unitst( u, udg_DamageEventSource, "enemy" ) then
                call dummyspawn( boss, 1, 'A061', 0, 0 )
                call IssueTargetOrder( bj_lastCreatedUnit, "slow", u )
            endif
            call GroupRemoveUnit(g,u)
        endloop
    endif
    
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
    set boss = null
endfunction

function Trig_Kobold2_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )

    call DisableTrigger( GetTriggeringTrigger() )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "bscb" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bscb" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bscb" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bscb" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bscb" ) ), bosscast(15), true, function CoboldCast )
endfunction

//===========================================================================
function InitTrig_Kobold2 takes nothing returns nothing
    set gg_trg_Kobold2 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Kobold2 )
    call TriggerRegisterVariableEvent( gg_trg_Kobold2, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Kobold2, Condition( function Trig_Kobold2_Conditions ) )
    call TriggerAddAction( gg_trg_Kobold2, function Trig_Kobold2_Actions )
endfunction

