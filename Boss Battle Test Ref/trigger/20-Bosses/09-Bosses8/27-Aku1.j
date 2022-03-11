function Trig_Aku1_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'n04O'
endfunction

function Aku1Cast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bsdl" ))
    local integer id1
    local unit c = LoadUnitHandle( udg_hash, GetHandleId( boss ), StringHash( "bsdl" ) )
    local real r = LoadReal( udg_hash, id, StringHash( "bsdl" ) )

    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    elseif GetUnitState( c, UNIT_STATE_LIFE) <= 0.405 or c == null then
        set c = randomtarget( boss, r, "enemy", "hero", "", "", "" )
        if c != null then
            call DisplayTimedTextToForce( bj_FORCE_ALL_PLAYERS, 8, "|cffffcc00CHAMPION: " +udg_Player_Color[GetPlayerId(GetOwningPlayer(c)) + 1]+ GetUnitName(c) + "|r." )
            call SaveUnitHandle( udg_hash, GetHandleId( boss ), StringHash( "bsdl" ), c )
        else
            call SaveReal( udg_hash, id, StringHash( "bsdl" ), r + 50 )
        endif
    else
        call IssueTargetOrder( boss, "attack", c )
    endif

    set boss = null
    set c = null
endfunction

function Trig_Aku1_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )
    
    call DisableTrigger( GetTriggeringTrigger() )
    if LoadTimerHandle( udg_hash, id, StringHash( "bsdl" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bsdl" ), CreateTimer() )
    endif
    set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bsdl" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bsdl" ), udg_DamageEventTarget )
    call SaveReal( udg_hash, id, StringHash( "bsdl" ), 600 )
    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bsdl" ) ), 1, true, function Aku1Cast )
endfunction

//===========================================================================
function InitTrig_Aku1 takes nothing returns nothing
    set gg_trg_Aku1 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Aku1 )
    call TriggerRegisterVariableEvent( gg_trg_Aku1, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Aku1, Condition( function Trig_Aku1_Conditions ) )
    call TriggerAddAction( gg_trg_Aku1, function Trig_Aku1_Actions )
endfunction

