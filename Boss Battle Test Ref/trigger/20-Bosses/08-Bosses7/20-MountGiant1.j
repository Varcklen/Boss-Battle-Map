function Trig_MountGiant1_Conditions takes nothing returns boolean
    return GetUnitTypeId( udg_DamageEventTarget ) == 'e000'
endfunction

function MountGiant1_End takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "bsmg2dmg" ) )
    local real x = LoadReal( udg_hash, id, StringHash( "bsmg2dmgx" ) )
    local real y = LoadReal( udg_hash, id, StringHash( "bsmg2dmgy" ) )

    call GroupAoE( dummy, null, x, y, 150, 200, TARGET_ENEMY, "war3mapImported\\Rock Slam.mdx", null )
    call RemoveUnit(dummy)
    call FlushChildHashtable( udg_hash, id )
    
    set dummy = null
endfunction

function MountGiant1Damage takes unit boss, real x, real y returns nothing
    local integer id

    set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( boss ), 'u000', x, y, 270 )
    call SetUnitScale(bj_lastCreatedUnit, 2, 2, 2 )
    call UnitAddAbility( bj_lastCreatedUnit, 'A136')
    set id = InvokeTimerWithUnit( bj_lastCreatedUnit, "bsmg2dmg", bosscast(2), false, function MountGiant1_End )
    call SaveReal( udg_hash, id, StringHash( "bsmg2dmgx" ), x )
    call SaveReal( udg_hash, id, StringHash( "bsmg2dmgy" ), y )
    
    set boss = null
endfunction

function MountGiant1End takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bsmg2" ) )
    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "bsmg2d" ) )
    local integer xn = LoadInteger( udg_hash, id, StringHash( "bsmg2xn" ) )
    local integer yn = LoadInteger( udg_hash, id, StringHash( "bsmg2yn" ) )
    local real x = LoadReal( udg_hash, id, StringHash( "bsmg2x" ) ) + ( 300*xn )
    local real y = LoadReal( udg_hash, id, StringHash( "bsmg2y" ) ) + ( 300*yn )
    local group g = CreateGroup()
    local unit u
    
    if RectContainsLoc(udg_Boss_Rect, Location(x, y)) and udg_fightmod[0] and GetUnitState( dummy, UNIT_STATE_LIFE) > 0.405 then
        call SaveReal( udg_hash, id, StringHash( "bsmg2x" ), x )
    	call SaveReal( udg_hash, id, StringHash( "bsmg2y" ), y )
        call MountGiant1Damage(boss, x, y)
    else
        call RemoveUnit(dummy)
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    endif
    
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
    set boss = null
endfunction 

function MountGiant1Cast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local integer id1
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bsmg1" ) )
    local integer cyclA = 1
    local real x = GetUnitX(boss) + GetRandomReal( -600,600 )
    local real y = GetUnitY(boss) + GetRandomReal( -600,600 )
    local integer xn
    local integer yn
    local group g = CreateGroup()
    local unit u

    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    else
        call MountGiant1Damage(boss, x, y)
        loop
            exitwhen cyclA > 4
            set xn = 0
            set yn = 0
            if cyclA == 1 then
                set xn = 1
            elseif cyclA == 2 then
                set xn = -1
            elseif cyclA == 3 then
                set yn = 1
            elseif cyclA == 4 then
                set yn = -1
            endif
            call dummyspawn( boss, 0, 0, 0, 0 )
            set id = GetHandleId( bj_lastCreatedUnit )
            if LoadTimerHandle( udg_hash, id, StringHash( "bsmg2" ) ) == null then 
                call SaveTimerHandle( udg_hash, id, StringHash( "bsmg2" ), CreateTimer() )
            endif
            set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bsmg2" ) ) ) 
            call SaveUnitHandle( udg_hash, id, StringHash( "bsmg2" ), boss )
            call SaveUnitHandle( udg_hash, id, StringHash( "bsmg2d" ), bj_lastCreatedUnit )
            call SaveInteger( udg_hash, id, StringHash( "bsmg2xn" ), xn )
            call SaveInteger( udg_hash, id, StringHash( "bsmg2yn" ), yn )
            call SaveReal( udg_hash, id, StringHash( "bsmg2x" ), x )
            call SaveReal( udg_hash, id, StringHash( "bsmg2y" ), y )
            call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "bsmg2" ) ), bosscast(1.5), true, function MountGiant1End )
            set cyclA = cyclA + 1
        endloop
    endif
    
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
    set boss = null
endfunction

function Trig_MountGiant1_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )

    call DisableTrigger( GetTriggeringTrigger() )

    if LoadTimerHandle( udg_hash, id, StringHash( "bsmg1" ) ) == null then 
        call SaveTimerHandle( udg_hash, id, StringHash( "bsmg1" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bsmg1" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bsmg1" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bsmg1" ) ), bosscast(12), true, function MountGiant1Cast )
endfunction

//===========================================================================
function InitTrig_MountGiant1 takes nothing returns nothing
    set gg_trg_MountGiant1 = CreateTrigger(  )
    call DisableTrigger( gg_trg_MountGiant1 )
    call TriggerRegisterVariableEvent( gg_trg_MountGiant1, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_MountGiant1, Condition( function Trig_MountGiant1_Conditions ) )
    call TriggerAddAction( gg_trg_MountGiant1, function Trig_MountGiant1_Actions )
endfunction

