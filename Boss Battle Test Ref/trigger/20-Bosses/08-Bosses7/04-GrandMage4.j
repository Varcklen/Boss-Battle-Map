function Trig_GrandMage4_Conditions takes nothing returns boolean
    return GetUnitTypeId( udg_DamageEventTarget ) == 'h003' and GetUnitLifePercent(udg_DamageEventTarget) <= 40
endfunction

function GrandMage4Cast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bsgm3" ) )
    local real x = GetUnitX( boss ) + GetRandomReal( -400, 400 )
    local real y = GetUnitY( boss ) + GetRandomReal( -400, 400 )
    local group g = CreateGroup()
    local unit u

    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        call dummyspawn( boss, 1, 0, 0, 0 )
        call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Other\\HowlOfTerror\\HowlCaster.mdl", x, y ) )
        call GroupEnumUnitsInRange( g, x, y, 250, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if unitst( u, boss, "enemy" ) then
                call UnitDamageTarget(bj_lastCreatedUnit, u, 200, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
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

function Trig_GrandMage4_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )
    
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Weapons\\Bolt\\BoltImpact.mdl", udg_DamageEventTarget, "origin") )
    call DisableTrigger( GetTriggeringTrigger() )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "bsgm3" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bsgm3" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bsgm3" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bsgm3" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bsgm3" ) ), bosscast(4), true, function GrandMage4Cast )
endfunction

//===========================================================================
function InitTrig_GrandMage4 takes nothing returns nothing
    set gg_trg_GrandMage4 = CreateTrigger(  )
    call DisableTrigger( gg_trg_GrandMage4 )
    call TriggerRegisterVariableEvent( gg_trg_GrandMage4, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_GrandMage4, Condition( function Trig_GrandMage4_Conditions ) )
    call TriggerAddAction( gg_trg_GrandMage4, function Trig_GrandMage4_Actions )
endfunction

