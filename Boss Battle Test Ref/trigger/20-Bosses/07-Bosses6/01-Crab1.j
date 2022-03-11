function Trig_Crab1_Conditions takes nothing returns boolean
    return GetUnitTypeId( udg_DamageEventTarget ) == 'n009'
endfunction

function Crab1Buff takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    
    call UnitRemoveAbility( LoadUnitHandle( udg_hash, id, StringHash( "bscr2" ) ), 'A0KJ' )
    call FlushChildHashtable( udg_hash, id )
endfunction

function Crab1End takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bscr1u" ) )
    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "bscr1d" ) )
    local group g = CreateGroup()
    local unit u
    local integer id1
    
    call DestroyEffect( AddSpecialEffect( "Objects\\Spawnmodels\\Naga\\NagaDeath\\NagaDeath.mdl", GetUnitX( dummy ), GetUnitY( dummy ) + 100 ) )
    call DestroyEffect( AddSpecialEffect( "Objects\\Spawnmodels\\Naga\\NagaDeath\\NagaDeath.mdl", GetUnitX( dummy ) + 140, GetUnitY( dummy ) - 140 ) )
    call DestroyEffect( AddSpecialEffect( "Objects\\Spawnmodels\\Naga\\NagaDeath\\NagaDeath.mdl", GetUnitX( dummy ) - 140, GetUnitY( dummy ) - 140 ) )
    
    call GroupEnumUnitsInRange( g, GetUnitX( dummy ), GetUnitY( dummy ), 300, null )
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if unitst( u, boss, "all" ) then
            set bj_lastCreatedUnit = CreateUnit(Player(PLAYER_NEUTRAL_AGGRESSIVE), 'u000', GetUnitX( u ), GetUnitY( u ), 270 )
            call UnitStun(bj_lastCreatedUnit, u, 3 )
            call UnitDamageTarget( bj_lastCreatedUnit, u, 500, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
            
            call UnitAddAbility( u, 'A0KJ' )
            
            set id1 = GetHandleId( u )
            if LoadTimerHandle( udg_hash, id1, StringHash( "bscr2" ) ) == null  then
                call SaveTimerHandle( udg_hash, id1, StringHash( "bscr2" ), CreateTimer() )
            endif
            set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "bscr2" ) ) ) 
            call SaveUnitHandle( udg_hash, id1, StringHash( "bscr2" ), u )
            call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( u ), StringHash( "bscr2" ) ), 10, true, function Crab1Buff )
        endif
        call GroupRemoveUnit(g,u)
        set u = FirstOfGroup(g)
    endloop
    
    call RemoveUnit( dummy )
    
    call FlushChildHashtable( udg_hash, id )
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
    set boss = null
    set dummy = null
endfunction 

function Crab1Cast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local integer id1
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bscr1" ) )
    local integer cyclA
    local integer rand
    local integer cyclB
    local integer cyclBEnd = LoadInteger( udg_hash, id, StringHash( "bscr1" ) )
    
    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        set rand = GetRandomInt( -1, 3 )
        set cyclB = 1
        loop
            exitwhen cyclB > cyclBEnd
            set cyclA = 0
            loop
                exitwhen cyclA > 7
                set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( boss ), 'u000', GetRectCenterX(udg_Boss_Rect)-1860+(500*(rand+cyclB)), GetRectCenterY(udg_Boss_Rect)-1860+(500*cyclA), 270 )
                call SetUnitScale(bj_lastCreatedUnit, 3, 3, 3 )
                call UnitAddAbility( bj_lastCreatedUnit, 'A136')
                
                set id1 = GetHandleId( bj_lastCreatedUnit )
                if LoadTimerHandle( udg_hash, id1, StringHash( "bscr1d" ) ) == null  then
                    call SaveTimerHandle( udg_hash, id1, StringHash( "bscr1d" ), CreateTimer() )
                endif
                set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "bscr1d" ) ) ) 
                call SaveUnitHandle( udg_hash, id1, StringHash( "bscr1d" ), bj_lastCreatedUnit )
                call SaveUnitHandle( udg_hash, id1, StringHash( "bscr1u" ), boss )
                call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "bscr1d" ) ), bosscast(3), false, function Crab1End )
                set cyclA = cyclA + 1
            endloop
            set cyclB = cyclB + 1
        endloop
    endif
    
    set boss = null
endfunction

function Trig_Crab1_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )

    call DisableTrigger( GetTriggeringTrigger() )

    if LoadTimerHandle( udg_hash, id, StringHash( "bscr1" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bscr1" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bscr1" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bscr1" ), udg_DamageEventTarget )
    call SaveInteger( udg_hash, id, StringHash( "bscr1" ), 1 )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bscr1" ) ), bosscast(8), true, function Crab1Cast )
endfunction

//===========================================================================
function InitTrig_Crab1 takes nothing returns nothing
    set gg_trg_Crab1 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Crab1 )
    call TriggerRegisterVariableEvent( gg_trg_Crab1, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Crab1, Condition( function Trig_Crab1_Conditions ) )
    call TriggerAddAction( gg_trg_Crab1, function Trig_Crab1_Actions )
endfunction

