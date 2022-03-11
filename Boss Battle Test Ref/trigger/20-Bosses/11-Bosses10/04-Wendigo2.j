function Trig_Wendigo2_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'n03I' and GetUnitLifePercent(udg_DamageEventTarget) <= 90
endfunction

function Wend2End takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local integer id1
    local unit pt = LoadUnitHandle( udg_hash, id, StringHash( "bswd2" ) )

    call ShowUnit( pt, false )
    if GetUnitState( pt, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    else
        set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( pt ), udg_Database_RandomUnit[GetRandomInt(1, udg_Database_NumberItems[5])], GetUnitX( pt ), GetUnitY( pt ), GetUnitFacing( pt ) )
        call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Orc\\FeralSpirit\\feralspirittarget.mdl", bj_lastCreatedUnit, "origin") )
        call UnitApplyTimedLife( bj_lastCreatedUnit, 'BTLF', 60)
    endif
    call KillUnit( pt )
    
    set pt = null
endfunction

function Wend2Cast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local integer id1
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bswd2" ) )
    local real x = GetRandomReal(GetRectMinX(udg_Boss_Rect), GetRectMaxX(udg_Boss_Rect))
    local real y = GetRandomReal(GetRectMinY(udg_Boss_Rect), GetRectMaxY(udg_Boss_Rect))

    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    else
        set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( boss ), 'h01H', x, y, GetRandomReal( 0, 360 ) )
        call PingMinimapLocForForceEx( bj_FORCE_ALL_PLAYERS, GetUnitLoc( bj_lastCreatedUnit ), 2., bj_MINIMAPPINGSTYLE_ATTACK, 0, 0, 0 )
        call SetUnitAnimation( bj_lastCreatedUnit, "birth" )
        call SetUnitTimeScale( bj_lastCreatedUnit, 3 )
        
        set id1 = GetHandleId( bj_lastCreatedUnit )
        
        call SaveTimerHandle( udg_hash, id1, StringHash( "bswd2" ), CreateTimer() )
        set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "bswd2" ) ) ) 
        call SaveUnitHandle( udg_hash, id1, StringHash( "bswd2" ), bj_lastCreatedUnit )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "bswd2" ) ), bosscast(3), true, function Wend2End )  
    endif
    
    set boss = null
endfunction

function Trig_Wendigo2_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )

    call DisableTrigger( GetTriggeringTrigger() )

    if LoadTimerHandle( udg_hash, id, StringHash( "bswd2" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bswd2" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bswd2" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bswd2" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bswd2" ) ), bosscast(5), true, function Wend2Cast )
endfunction

//===========================================================================
function InitTrig_Wendigo2 takes nothing returns nothing
    set gg_trg_Wendigo2 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Wendigo2 )
    call TriggerRegisterVariableEvent( gg_trg_Wendigo2, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Wendigo2, Condition( function Trig_Wendigo2_Conditions ) )
    call TriggerAddAction( gg_trg_Wendigo2, function Trig_Wendigo2_Actions )
endfunction

