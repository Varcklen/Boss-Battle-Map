function Trig_DarkWarlock2_Conditions takes nothing returns boolean
    return GetUnitTypeId( udg_DamageEventTarget ) == 'e00D' and GetUnitLifePercent(udg_DamageEventTarget) <= 60 and GetOwningPlayer(udg_DamageEventTarget) == Player(10)
endfunction

function DarkWar2End takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    
    call UnitRemoveAbility( LoadUnitHandle( udg_hash, id, StringHash( "bsdw2" ) ), 'A0Y0' )
    call UnitRemoveAbility( LoadUnitHandle( udg_hash, id, StringHash( "bsdw2" ) ), 'B03U' )
    call FlushChildHashtable( udg_hash, id )
endfunction

function DarkWar2Cast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit target = GroupPickRandomUnit(udg_otryad)
    local integer id1 = GetHandleId( target )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bsdw1" ) )
    
    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        call UnitAddAbility( target, 'A0Y0')
        
        if LoadTimerHandle( udg_hash, id1, StringHash( "bsdw2" ) ) == null  then
            call SaveTimerHandle( udg_hash, id1, StringHash( "bsdw2" ), CreateTimer() )
        endif
        set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "bsdw2" ) ) ) 
        call SaveUnitHandle( udg_hash, id1, StringHash( "bsdw2" ), target )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( target ), StringHash( "bsdw2" ) ), 10, true, function DarkWar2End )
    endif
endfunction

function Trig_DarkWarlock2_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )

    call DisableTrigger( GetTriggeringTrigger() )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "bsdw1" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bsdw1" ), CreateTimer() )
    endif
    set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bsdw1" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bsdw1" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bsdw1" ) ), bosscast(18), true, function DarkWar2Cast )
endfunction

//===========================================================================
function InitTrig_DarkWarlock2 takes nothing returns nothing
    set gg_trg_DarkWarlock2 = CreateTrigger(  )
    call DisableTrigger( gg_trg_DarkWarlock2 )
    call TriggerRegisterVariableEvent( gg_trg_DarkWarlock2, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_DarkWarlock2, Condition( function Trig_DarkWarlock2_Conditions ) )
    call TriggerAddAction( gg_trg_DarkWarlock2, function Trig_DarkWarlock2_Actions )
endfunction

