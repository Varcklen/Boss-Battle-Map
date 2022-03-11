function Trig_Zapper3_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'n00Q' and GetUnitLifePercent(udg_DamageEventTarget) <= 60
endfunction

function Zapper3End takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bszp3" ) )
    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "bszp3d" ) )
    local integer i = LoadInteger( udg_hash, id, StringHash( "bszp3" ) ) + 1
    local group g = CreateGroup()
    local unit u

    if GetUnitState( dummy, UNIT_STATE_LIFE) <= 0.405 or GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) or i > 10 then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        call SaveInteger( udg_hash, id, StringHash( "bszp3" ), i )
        call GroupEnumUnitsInRange( g, GetUnitX( dummy ), GetUnitY( dummy ), 900, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if unitst( u, boss, "enemy" ) then
                call UnitDamageTarget( dummy, u, 100, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )
            endif
            call GroupRemoveUnit(g,u)
            set u = FirstOfGroup(g)
        endloop
    endif
    
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
    set dummy = null
    set boss = null
endfunction

function Trig_Zapper3_Actions takes nothing returns nothing
    local unit u = udg_DamageEventTarget
    local integer id

    call DisableTrigger( GetTriggeringTrigger() )
    call dummyspawn( u, 10, 'A139', 0, 0 )
    call SetUnitPosition( bj_lastCreatedUnit, GetRectCenterX(udg_Boss_Rect) + 700, GetRectCenterY(udg_Boss_Rect) + 1000 )
    call IssuePointOrder( bj_lastCreatedUnit, "flamestrike", GetRectCenterX(udg_Boss_Rect) + 700, GetRectCenterY(udg_Boss_Rect) + 1000 )
    
    set id = GetHandleId( bj_lastCreatedUnit )
    if LoadTimerHandle( udg_hash, id, StringHash( "bszp3" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bszp3" ), CreateTimer() )
    endif
    set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bszp3" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bszp3" ), u )
    call SaveUnitHandle( udg_hash, id, StringHash( "bszp3d" ), bj_lastCreatedUnit )
    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "bszp3" ) ), 1, true, function Zapper3End )
    
    call dummyspawn( u, 10, 'A139', 0, 0 )
    call SetUnitPosition( bj_lastCreatedUnit, GetRectCenterX(udg_Boss_Rect) - 700, GetRectCenterY(udg_Boss_Rect) + 1000 )
    call IssuePointOrder( bj_lastCreatedUnit, "flamestrike", GetRectCenterX(udg_Boss_Rect) - 700, GetRectCenterY(udg_Boss_Rect) + 1000 )
    
    set id = GetHandleId( bj_lastCreatedUnit )
    if LoadTimerHandle( udg_hash, id, StringHash( "bszp3" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bszp3" ), CreateTimer() )
    endif
    set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bszp3" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bszp3" ), u )
    call SaveUnitHandle( udg_hash, id, StringHash( "bszp3d" ), bj_lastCreatedUnit )
    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "bszp3" ) ), 1, true, function Zapper3End )

    call dummyspawn( u, 10, 'A139', 0, 0 )
    call IssuePointOrder( bj_lastCreatedUnit, "flamestrike", GetRectCenterX(udg_Boss_Rect) + 700, GetRectCenterY(udg_Boss_Rect) + 1000 )
    call dummyspawn( u, 10, 'A139', 0, 0 )
    call IssuePointOrder( bj_lastCreatedUnit, "flamestrike", GetRectCenterX(udg_Boss_Rect) - 700, GetRectCenterY(udg_Boss_Rect) + 1000 )
    
    set u = null
endfunction

//===========================================================================
function InitTrig_Zapper3 takes nothing returns nothing
    set gg_trg_Zapper3 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Zapper3 )
    call TriggerRegisterVariableEvent( gg_trg_Zapper3, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Zapper3, Condition( function Trig_Zapper3_Conditions ) )
    call TriggerAddAction( gg_trg_Zapper3, function Trig_Zapper3_Actions )
endfunction

