function Trig_Woodo2_Conditions takes nothing returns boolean
    return GetUnitTypeId(GetEnteringUnit()) == 'o005'
endfunction

function WDTotemCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit totem = LoadUnitHandle( udg_hash, id, StringHash( "bswdmt" ) )
    local unit target = GroupPickRandomUnit(udg_otryad)

    if GetUnitState( totem, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        call UnitPoly( totem, target, 'n02M', 3 )
    endif
    
    set totem = null
    set target = null
endfunction
    
function Trig_Woodo2_Actions takes nothing returns nothing
    local integer id = GetHandleId( GetEnteringUnit() )

    if LoadTimerHandle( udg_hash, id, StringHash( "bswdmt" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bswdmt" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bswdmt" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bswdmt" ), GetEnteringUnit() )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetEnteringUnit() ), StringHash( "bswdmt" ) ), bosscast(8), true, function WDTotemCast )
endfunction

//===========================================================================
function InitTrig_Woodo2 takes nothing returns nothing
    set gg_trg_Woodo2 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Woodo2 )
    call TriggerRegisterEnterRectSimple( gg_trg_Woodo2, gg_rct_ArenaBoss )
    call TriggerAddCondition( gg_trg_Woodo2, Condition( function Trig_Woodo2_Conditions ) )
    call TriggerAddAction( gg_trg_Woodo2, function Trig_Woodo2_Actions )
endfunction

