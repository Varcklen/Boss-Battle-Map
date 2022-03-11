function Trig_Marine3_Conditions takes nothing returns boolean
    return GetUnitTypeId( udg_DamageEventTarget ) == 'n04N' and GetUnitLifePercent(udg_DamageEventTarget) <= 95
endfunction

function Marine3Wave takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local integer counter = LoadInteger( udg_hash, id, StringHash( "bsmr6" ) ) + 1
    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "bsmr6" ) )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bsmr6b" ) )
    local real NewX = GetUnitX( dummy ) + 42 * Cos( 0.017 * GetUnitFacing( dummy ) )
    local real NewY = GetUnitY( dummy ) + 42 * Sin( 0.017 * GetUnitFacing( dummy ) )
    local real dmg = LoadReal( udg_hash, id, StringHash( "bsmr6" ) )
    local group nodmg = LoadGroupHandle( udg_hash, id, StringHash( "bsmr6g" ) )
    local group g = CreateGroup()
    local unit u

    if counter >= 60 or GetUnitState( dummy, UNIT_STATE_LIFE) <= 0.405 then
        call RemoveUnit( dummy )
        call GroupClear( nodmg )
        call DestroyGroup( nodmg )
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    else
        call SetUnitPosition( dummy, NewX, NewY )
        call SaveInteger( udg_hash, id, StringHash( "bsmr6" ), counter )
        call GroupEnumUnitsInRange( g, GetUnitX( dummy ), GetUnitY( dummy ), 125, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if unitst( u, boss, "enemy" ) and not( IsUnitInGroup( u, nodmg ) ) then
                call UnitDamageTarget( dummy, u, 400, true, false, ATTACK_TYPE_HERO, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS )
                call GroupAddUnit( nodmg, u )
            endif
            call GroupRemoveUnit(g,u)
            set u = FirstOfGroup(g)
        endloop
        call SaveGroupHandle( udg_hash, id, StringHash( "bsmr6g" ), nodmg )
    endif
    
    call GroupClear( g )
    call DestroyGroup( g )
    set g = null
    set nodmg = null
    set u = null
    set dummy = null
    set boss = null
endfunction

function Marine3End takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bsmr5b" ) )
    local unit c = LoadUnitHandle( udg_hash, id, StringHash( "bsmr5" ) )
    local integer id1
    local real x = GetUnitX( boss )
    local real y = GetUnitY( boss )
    
    if GetUnitState( boss, UNIT_STATE_LIFE) > 0.405 and ( udg_fightmod[0] ) then
        call UnitRemoveAbility( c, 'A0S4')
        call UnitRemoveAbility( c, 'B07X')
        
        set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( boss ), 'u000', x, y, bj_RADTODEG * Atan2( GetUnitY( c ) - y, GetUnitX( c ) - x ) )
        call UnitAddAbility( bj_lastCreatedUnit, 'A0S5')
        
        set id1 = GetHandleId( bj_lastCreatedUnit )
        if LoadTimerHandle( udg_hash, id1, StringHash( "bsmr6" ) ) == null  then
            call SaveTimerHandle( udg_hash, id1, StringHash( "bsmr6" ), CreateTimer() )
        endif
        set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "bsmr6" ) ) ) 
        call SaveUnitHandle( udg_hash, id1, StringHash( "bsmr6" ), bj_lastCreatedUnit )
        call SaveUnitHandle( udg_hash, id1, StringHash( "bsmr6b" ), boss )
        call SaveGroupHandle( udg_hash, id1, StringHash( "bsmr6g" ), CreateGroup() )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "bsmr6" ) ), 0.04, true, function Marine3Wave )
        
        call IssueImmediateOrder( boss, "stop" )
        call SetUnitAnimation( boss, "attack slam" )
    endif
    call FlushChildHashtable( udg_hash, id )
    
    set boss = null
    set c = null
endfunction

function Marine3Cast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bsmr4" ) ) 
    local unit c = GroupPickRandomUnit(udg_otryad)
    local integer id1

    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    elseif c != null and GetUnitAbilityLevel( boss, 'A0SE') == 0 then
        call UnitAddAbility( c, 'A0S4' )
        set id1 = GetHandleId( c )
        if LoadTimerHandle( udg_hash, id1, StringHash( "bsmr5" ) ) == null then
            call SaveTimerHandle( udg_hash, id1, StringHash( "bsmr5" ), CreateTimer() )
        endif
        set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "bsmr5" ) ) ) 
        call SaveUnitHandle( udg_hash, id1, StringHash( "bsmr5" ), c )
        call SaveUnitHandle( udg_hash, id1, StringHash( "bsmr5b" ), boss )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( c ), StringHash( "bsmr5" ) ), bosscast(3), false, function Marine3End )
    endif
    
    set boss = null
endfunction

function Trig_Marine3_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )

    call DisableTrigger( GetTriggeringTrigger() )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "bsmr4" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bsmr4" ), CreateTimer() )
    endif
    set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bsmr4" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bsmr4" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bsmr4" ) ), bosscast(10), true, function Marine3Cast )
endfunction

//===========================================================================
function InitTrig_Marine3 takes nothing returns nothing
    set gg_trg_Marine3 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Marine3 )
    call TriggerRegisterVariableEvent( gg_trg_Marine3, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Marine3, Condition( function Trig_Marine3_Conditions ) )
    call TriggerAddAction( gg_trg_Marine3, function Trig_Marine3_Actions )
endfunction

