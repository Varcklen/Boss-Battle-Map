function Trig_Kobold3_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'n00P' and GetUnitLifePercent( udg_DamageEventTarget ) <= 75
endfunction

function Cobold3End takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "bscb2" ) )
    local group g = CreateGroup()
    local unit u

    call DestroyEffect( AddSpecialEffect( "Objects\\Spawnmodels\\Human\\HCancelDeath\\HCancelDeath.mdl", GetUnitX( dummy ), GetUnitY( dummy ) ) )
    call GroupEnumUnitsInRange( g, GetUnitX( dummy ), GetUnitY( dummy ), 200, null )
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if unitst( u, dummy, "enemy" ) then
            call UnitDamageTarget( dummy, u, 125, true, false, ATTACK_TYPE_HERO, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS)
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
    set dummy = null
endfunction 

function Cobold3Cast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local integer id1
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bscb1" ) )

    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( boss ), 'u000', GetUnitX( boss ) + GetRandomReal(-300, 300), GetUnitY( boss ) + GetRandomReal(-300, 300), 270 )
        call UnitAddAbility( bj_lastCreatedUnit, 'A13P')
        call SetUnitScale(bj_lastCreatedUnit, 2, 2, 2 )
        call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageDeathCaster.mdl", GetUnitX( bj_lastCreatedUnit ), GetUnitY( bj_lastCreatedUnit ) ) )
        set id1 = GetHandleId( bj_lastCreatedUnit )
        
        call SaveTimerHandle( udg_hash, id1, StringHash( "bscb2" ), CreateTimer() )
        set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "bscb2" ) ) ) 
        call SaveUnitHandle( udg_hash, id1, StringHash( "bscb2" ), bj_lastCreatedUnit )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "bscb2" ) ), bosscast(3), false, function Cobold3End ) 
    endif
    set boss = null
endfunction

function Trig_Kobold3_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )

    call DisableTrigger( GetTriggeringTrigger() )

    if LoadTimerHandle( udg_hash, id, StringHash( "bscb1" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bscb1" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bscb1" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bscb1" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bscb1" ) ), bosscast(10), true, function Cobold3Cast )
endfunction

//===========================================================================
function InitTrig_Kobold3 takes nothing returns nothing
    set gg_trg_Kobold3 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Kobold3 )
    call TriggerRegisterVariableEvent( gg_trg_Kobold3, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Kobold3, Condition( function Trig_Kobold3_Conditions ) )
    call TriggerAddAction( gg_trg_Kobold3, function Trig_Kobold3_Actions )
endfunction

