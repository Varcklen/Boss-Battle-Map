function Trig_Wyrm1_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'o00M'
endfunction

function WyrmSpawn takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bswr1" ) )
    
    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( boss ), 'e00E', GetRectCenterX( udg_Boss_Rect ) + GetRandomReal( -1500, 1500 ), GetRectCenterY( udg_Boss_Rect ) + GetRandomReal( -1500, 1500 ), GetRandomReal( 0, 360 ) )
        call PingMinimapLocForForceEx( bj_FORCE_ALL_PLAYERS, GetUnitLoc(bj_lastCreatedUnit), 5, bj_MINIMAPPINGSTYLE_ATTACK, 100, 50, 50 )
    endif
    
    set boss = null
endfunction

function WyrmFrostFire takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "bswrfire" ) )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bswrfireu" ) )
    local unit target = LoadUnitHandle( udg_hash, id, StringHash( "bswrfiret" ) )
    local real r = LoadReal( udg_hash, id, StringHash( "bswrfire" ) )
    local point p = GetMovedPointBetweenUnits( dummy, target, r )
    local real distance = DistanceBetweenUnits(dummy, target)
    
    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) or distance <= 25 then
        if GetUnitState( boss, UNIT_STATE_LIFE) > 0.405 then
            call GroupAoE( boss, dummy, p.x, p.y, 200, 150, "enemy", "Objects\\Spawnmodels\\NightElf\\NECancelDeath\\NECancelDeath.mdl", "" )
        endif
        call RemoveUnit( target )
        call RemoveUnit( dummy )
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id ) 
    else 
        call SetUnitPosition( dummy, p.x, p.y )
    endif
    
    call p.destroy()
    set target = null
    set dummy = null
endfunction

function WyrmFrostCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "bswr" ) )
    local unit target
    local real r
    local real cooldown = 0.04
    local integer id1
    local integer cyclA = 1
    
    if GetUnitState( u, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        loop
            exitwhen cyclA > 4
            if GetUnitState( udg_hero[cyclA], UNIT_STATE_LIFE) > 0.405 then
                set target = CreateUnit( GetOwningPlayer( u ), 'u000', GetUnitX( udg_hero[cyclA] ), GetUnitY( udg_hero[cyclA] ), 270 )
                call UnitAddAbility( target, 'A136')
                call dummyspawn( u, 0, 'A13T', 0, 0 )
                set r = DistanceBetweenUnits(bj_lastCreatedUnit, target)
                call SetUnitFlyHeight( bj_lastCreatedUnit, 500, -r / ( r * cooldown ) )
                set id1 = GetHandleId( bj_lastCreatedUnit )
                if LoadTimerHandle( udg_hash, id1, StringHash( "bswrfire" ) ) == null  then
                    call SaveTimerHandle( udg_hash, id1, StringHash( "bswrfire" ), CreateTimer() )
                endif
                set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "bswrfire" ) ) ) 
                call SaveReal( udg_hash, id1, StringHash( "bswrfire" ), r*cooldown ) 
                call SaveUnitHandle( udg_hash, id1, StringHash( "bswrfire" ), bj_lastCreatedUnit )
                call SaveUnitHandle( udg_hash, id1, StringHash( "bswrfiret" ), target )
                call SaveUnitHandle( udg_hash, id1, StringHash( "bswrfireu" ), u )
                call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "bswrfire" ) ), cooldown, true, function WyrmFrostFire )
            endif
            set cyclA = cyclA + 1
        endloop
    endif
    
    set target = null
endfunction

function Trig_Wyrm1_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )
    local integer cyclA
    local real x
    local real y 
    
    call DisableTrigger( GetTriggeringTrigger() )
    call DestroyTimer( LoadTimerHandle( udg_hash, id, StringHash( "bswrs" ) ) )
    
    call UnitAddAbility( udg_DamageEventTarget, 'Awan')
    set cyclA = 1
    loop
        exitwhen cyclA > 4
        if GetUnitState( udg_hero[cyclA], UNIT_STATE_LIFE) > 0.405 then
            set x = GetRectCenterX( udg_Boss_Rect ) + 2000 * Cos( ( 45 + ( 90 * cyclA ) ) * bj_DEGTORAD )
            set y = GetRectCenterY( udg_Boss_Rect ) + 2000 * Sin( ( 45 + ( 90 * cyclA ) ) * bj_DEGTORAD )
            set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( udg_DamageEventTarget ), 'e00E', x, y, GetRandomReal( 0, 360 ) )
            call PingMinimapLocForForceEx( bj_FORCE_ALL_PLAYERS, GetUnitLoc( bj_lastCreatedUnit ), 5, bj_MINIMAPPINGSTYLE_ATTACK, 100, 50, 50 )
        endif
        set cyclA = cyclA + 1
    endloop
    
    if LoadTimerHandle( udg_hash, id, StringHash( "bswr" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bswr" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bswr" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bswr" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bswr" ) ), bosscast(6), true, function WyrmFrostCast )
    
    set id = GetHandleId( udg_DamageEventTarget )
    if LoadTimerHandle( udg_hash, id, StringHash( "bswr1" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bswr1" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bswr1" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bswr1" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bswr1" ) ), bosscast(10), true, function WyrmSpawn )
endfunction

//===========================================================================
function InitTrig_Wyrm1 takes nothing returns nothing
    set gg_trg_Wyrm1 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Wyrm1 )
    call TriggerRegisterVariableEvent( gg_trg_Wyrm1, "udg_DamageModifierEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Wyrm1, Condition( function Trig_Wyrm1_Conditions ) )
    call TriggerAddAction( gg_trg_Wyrm1, function Trig_Wyrm1_Actions )
endfunction

