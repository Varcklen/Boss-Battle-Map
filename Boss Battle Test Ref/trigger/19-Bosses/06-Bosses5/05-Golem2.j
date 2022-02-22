function Trig_Golem2_Conditions takes nothing returns boolean
    return GetUnitTypeId( udg_DamageEventTarget ) == 'n00R' and GetUnitLifePercent(udg_DamageEventTarget) <= 50
endfunction

function Golem2Cast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bsig" ) )
    local group g = CreateGroup()
    local unit u

    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        call SetUnitAnimation( boss, "spell slam" )
        call QueueUnitAnimation( boss, "stand" )
        call dummyspawn( boss, 1, 0, 'A0C7', 0 )
        call IssueImmediateOrder( bj_lastCreatedUnit, "thunderclap" )
        call GroupEnumUnitsInRange( g, GetUnitX(boss), GetUnitY(boss), 500, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if unitst( u, boss, "enemy" ) and GetUnitTypeId( u ) != 'n00S' then
                call UnitDamageTarget( bj_lastCreatedUnit, u, 100, true, false, ATTACK_TYPE_HERO, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS )
            endif
            call GroupRemoveUnit(g,u)
            set u = FirstOfGroup(g)
        endloop
    endif
    
    call GroupClear( g )
    call DestroyGroup( g )
    set g = null
    set u = null
    set boss = null
endfunction

function Trig_Golem2_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )
    
    call DisableTrigger( GetTriggeringTrigger() )
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl", udg_DamageEventTarget, "origin") )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "bsig" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bsig" ), CreateTimer() )
    endif
    set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bsig" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bsig" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bsig" ) ), bosscast(10), true, function Golem2Cast )
endfunction

//===========================================================================
function InitTrig_Golem2 takes nothing returns nothing
    set gg_trg_Golem2 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Golem2 )
    call TriggerRegisterVariableEvent( gg_trg_Golem2, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Golem2, Condition( function Trig_Golem2_Conditions ) )
    call TriggerAddAction( gg_trg_Golem2, function Trig_Golem2_Actions )
endfunction

