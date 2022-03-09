//TESH.scrollpos=8
//TESH.alwaysfold=0
function Trig_Kodo3_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'h01K' and GetUnitLifePercent(udg_DamageEventTarget) <= 50
endfunction

function Kodo3Cast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bsbkd3" ) )

    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) or CountLivingPlayerUnitsOfTypeId('o00V', Player(PLAYER_NEUTRAL_AGGRESSIVE)) <= 0 then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        call IssueTargetOrder( boss, "attack", GroupPickRandomUnit(GetUnitsOfTypeIdAll('o00V')) )
    endif
    
    set boss = null
endfunction

function Trig_Kodo3_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )
    local integer cyclA = 1
    local real x
    local real y 
    
    call DisableTrigger( GetTriggeringTrigger() )
    loop
        exitwhen cyclA > 4
        set x = GetRectCenterX( udg_Boss_Rect ) + 1500 * Cos( ( 45 + ( 90 * cyclA ) ) * bj_DEGTORAD )
        set y = GetRectCenterY( udg_Boss_Rect ) + 1500 * Sin( ( 45 + ( 90 * cyclA ) ) * bj_DEGTORAD )
        set bj_lastCreatedUnit = CreateUnit( Player( PLAYER_NEUTRAL_AGGRESSIVE ), 'o00V', x, y, 270 )
        call DestroyEffect(AddSpecialEffectTarget( "Abilities\\Spells\\Human\\Thunderclap\\ThunderClapCaster.mdl", bj_lastCreatedUnit, "origin") )
        call PingMinimapLocForForceEx( bj_FORCE_ALL_PLAYERS, GetUnitLoc( bj_lastCreatedUnit ), 5, bj_MINIMAPPINGSTYLE_ATTACK, 100, 50, 50 )
        set cyclA = cyclA + 1
    endloop
    
    call IssueTargetOrder( udg_DamageEventTarget, "attack", GroupPickRandomUnit(GetUnitsOfTypeIdAll('o00V')) )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "bsbkd3" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bsbkd3" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bsbkd3" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bsbkd3" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bsbkd3" ) ), bosscast(10), true, function Kodo3Cast )
endfunction

//===========================================================================
function InitTrig_Kodo3 takes nothing returns nothing
    set gg_trg_Kodo3 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Kodo3 )
    call TriggerRegisterVariableEvent( gg_trg_Kodo3, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Kodo3, Condition( function Trig_Kodo3_Conditions ) )
    call TriggerAddAction( gg_trg_Kodo3, function Trig_Kodo3_Actions )
endfunction

