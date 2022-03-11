function Trig_Marine2_Conditions takes nothing returns boolean
    return GetUnitTypeId( udg_DamageEventTarget ) == 'n04N' and GetUnitLifePercent(udg_DamageEventTarget) <= 95
endfunction

function Marine2End takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local integer counter = LoadInteger( udg_hash, id, StringHash( "bsmr3" ) ) + 1
    local unit target = LoadUnitHandle( udg_hash, id, StringHash( "bsmr3" ) )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bsmr3b" ) )
    local real x1 = LoadReal( udg_hash, id, StringHash( "bsmr3x" ))
    local real y1 = LoadReal( udg_hash, id, StringHash( "bsmr3y" ))
    local real x2 = GetUnitX( target )
    local real y2 = GetUnitY( target )
    local real angle = Atan2( y2 - y1, x2 - x1 )
    local real NewX = x2 + 20 * Cos( angle )
    local real NewY = y2 + 20 * Sin( angle )

    if counter < 10 and GetUnitState( target, UNIT_STATE_LIFE) > 0.405 and RectContainsUnit( udg_Boss_Rect, target) then
        call SetUnitX(target, NewX )
        call SetUnitY(target, NewY )
        call SaveInteger( udg_hash, id, StringHash( "bsmr3" ), counter )
    else
        call SetUnitPathing( target, true )
        call DestroyEffect( AddSpecialEffect("Abilities\\Spells\\Human\\Thunderclap\\ThunderClapCaster.mdl", GetUnitX(target), GetUnitY(target) ) )
        call dummyspawn( boss, 1, 0, 0, 0 )
        call UnitDamageTarget( bj_lastCreatedUnit, target, 400, true, false, ATTACK_TYPE_HERO, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS)
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    endif
    
    set target = null
    set boss = null
endfunction

function Marine2Cast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bsmr" ) ) 
    local group g = CreateGroup()
    local unit u
    local integer id1
    local real x
    local real y

    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    elseif GetUnitAbilityLevel( boss, 'A0SE') == 0 then
        set x = GetUnitX( boss ) + 200 * Cos( 0.017 * GetUnitFacing( boss ) )
    	set y = GetUnitY( boss ) + 200 * Sin( 0.017 * GetUnitFacing( boss ) )
        
        call DestroyEffect( AddSpecialEffect("Abilities\\Spells\\Human\\Thunderclap\\ThunderClapCaster.mdl", x, y ) )
        call GroupEnumUnitsInRange( g, x, y, 300, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if boss != u and unitst( u, boss, "all" ) and GetUnitDefaultMoveSpeed(u) != 0 then
                call SetUnitPathing( u, false )

                set id1 = GetHandleId( u )
                if LoadTimerHandle( udg_hash, id1, StringHash( "bsmr3" ) ) == null then
                    call SaveTimerHandle( udg_hash, id1, StringHash( "bsmr3" ), CreateTimer() )
                endif
                set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "bsmr3" ) ) ) 
                call SaveReal( udg_hash, id1, StringHash( "bsmr3x" ), x )
                call SaveReal( udg_hash, id1, StringHash( "bsmr3y" ), y )
                call SaveUnitHandle( udg_hash, id1, StringHash( "bsmr3" ), u )
                call SaveUnitHandle( udg_hash, id1, StringHash( "bsmr3b" ), boss )
                call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( u ), StringHash( "bsmr3" ) ), 0.02, true, function Marine2End )
            endif
            call GroupRemoveUnit(g,u)
            set u = FirstOfGroup(g)
        endloop
    endif
    
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
    set boss = null
endfunction

function Trig_Marine2_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )

    call DisableTrigger( GetTriggeringTrigger() )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "bsmr" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bsmr" ), CreateTimer() )
    endif
    set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bsmr" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bsmr" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bsmr" ) ), bosscast(12), true, function Marine2Cast )
endfunction

//===========================================================================
function InitTrig_Marine2 takes nothing returns nothing
    set gg_trg_Marine2 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Marine2 )
    call TriggerRegisterVariableEvent( gg_trg_Marine2, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Marine2, Condition( function Trig_Marine2_Conditions ) )
    call TriggerAddAction( gg_trg_Marine2, function Trig_Marine2_Actions )
endfunction

