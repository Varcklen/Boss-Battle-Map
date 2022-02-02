function Trig_Zapper4_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'n00Q' and GetUnitLifePercent(udg_DamageEventTarget) <= 30
endfunction

function Trig_Zapper4_Actions takes nothing returns nothing
    local unit u = udg_DamageEventTarget
    local integer id

    call DisableTrigger( GetTriggeringTrigger() )
    call dummyspawn( u, 10, 'A139', 0, 0 )
    call SetUnitPosition( bj_lastCreatedUnit, GetRectCenterX(udg_Boss_Rect) + 700, GetRectCenterY(udg_Boss_Rect) - 1000 )
    call IssuePointOrder( bj_lastCreatedUnit, "flamestrike", GetRectCenterX(udg_Boss_Rect) + 700, GetRectCenterY(udg_Boss_Rect) - 1000 )
    
    set id = GetHandleId( bj_lastCreatedUnit )
    if LoadTimerHandle( udg_hash, id, StringHash( "bszp3" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bszp3" ), CreateTimer() )
    endif
    set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bszp3" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bszp3" ), u )
    call SaveUnitHandle( udg_hash, id, StringHash( "bszp3d" ), bj_lastCreatedUnit )
    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "bszp3" ) ), 1, true, function Zapper3End )
    
    call dummyspawn( u, 10, 'A139', 0, 0 )
    call SetUnitPosition( bj_lastCreatedUnit, GetRectCenterX(udg_Boss_Rect) - 700, GetRectCenterY(udg_Boss_Rect) - 1000 )
    call IssuePointOrder( bj_lastCreatedUnit, "flamestrike", GetRectCenterX(udg_Boss_Rect) - 700, GetRectCenterY(udg_Boss_Rect) - 1000 )
    
    set id = GetHandleId( bj_lastCreatedUnit )
    if LoadTimerHandle( udg_hash, id, StringHash( "bszp3" ) ) == null then 
        call SaveTimerHandle( udg_hash, id, StringHash( "bszp3" ), CreateTimer() )
    endif
    set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bszp3" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bszp3" ), u )
    call SaveUnitHandle( udg_hash, id, StringHash( "bszp3d" ), bj_lastCreatedUnit )
    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "bszp3" ) ), 1, true, function Zapper3End )
    
    call dummyspawn( u, 10, 'A139', 0, 0 )
    call IssuePointOrder( bj_lastCreatedUnit, "flamestrike", GetRectCenterX(udg_Boss_Rect) + 700, GetRectCenterY(udg_Boss_Rect) - 1000 )
    call dummyspawn( u, 10, 'A139', 0, 0 )
    call IssuePointOrder( bj_lastCreatedUnit, "flamestrike", GetRectCenterX(udg_Boss_Rect) - 700, GetRectCenterY(udg_Boss_Rect) - 1000 )

    set u = null
endfunction

//===========================================================================
function InitTrig_Zapper4 takes nothing returns nothing
    set gg_trg_Zapper4 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Zapper4 )
    call TriggerRegisterVariableEvent( gg_trg_Zapper4, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Zapper4, Condition( function Trig_Zapper4_Conditions ) )
    call TriggerAddAction( gg_trg_Zapper4, function Trig_Zapper4_Actions )
endfunction

