function Trig_Marine4_Conditions takes nothing returns boolean
    return GetUnitTypeId( udg_DamageEventTarget ) == 'n04N' and GetUnitLifePercent(udg_DamageEventTarget) <= 95
endfunction

function Marine4End takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bsmr8u" ) )
    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "bsmr8" ) )
    local group g = CreateGroup()
    local unit u
    
    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\Thunderclap\\ThunderClapCaster.mdl", GetUnitX( dummy ), GetUnitY( dummy ) + 80 ) )
    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\Thunderclap\\ThunderClapCaster.mdl", GetUnitX( dummy ) + 110, GetUnitY( dummy ) - 110 ) )
    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\Thunderclap\\ThunderClapCaster.mdl", GetUnitX( dummy ) - 110, GetUnitY( dummy ) - 110 ) )
    call GroupEnumUnitsInRange( g, GetUnitX( dummy ), GetUnitY( dummy ), 200, null )
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if unitst( u, boss, "enemy" ) and GetOwningPlayer(u) != Player(PLAYER_NEUTRAL_AGGRESSIVE) and not(IsUnitHiddenBJ(u)) then
            call UnitDamageTarget( dummy, u, 500, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
        endif
        call GroupRemoveUnit(g,u)
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

function Marine4Cast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bsmr7" ) )
    local integer cyclA = 1

    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    elseif GetUnitAbilityLevel( boss, 'A0SE') == 0 then
        loop
            exitwhen cyclA > 4
            if GetUnitState( udg_hero[cyclA], UNIT_STATE_LIFE) > 0.405 then
                set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( boss ), 'u000', GetUnitX( udg_hero[cyclA] ), GetUnitY( udg_hero[cyclA] ), 270 )
                call SetUnitScale(bj_lastCreatedUnit, 2, 2, 2 )
                call UnitAddAbility( bj_lastCreatedUnit, 'A136')
        
                set id = GetHandleId( bj_lastCreatedUnit )
                if LoadTimerHandle( udg_hash, id, StringHash( "bsmr8" ) ) == null  then
                        call SaveTimerHandle( udg_hash, id, StringHash( "bsmr8" ), CreateTimer() )
                endif
                set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bsmr8" ) ) ) 
                call SaveUnitHandle( udg_hash, id, StringHash( "bsmr8" ), bj_lastCreatedUnit )
                call SaveUnitHandle( udg_hash, id, StringHash( "bsmr8u" ), boss )
                call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "bsmr8" ) ), bosscast(3), false, function Marine4End )
            endif
            set cyclA = cyclA + 1
        endloop
    endif
endfunction

function Trig_Marine4_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )

    call DisableTrigger( GetTriggeringTrigger() )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "bsmr7" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bsmr7" ), CreateTimer() )
    endif
    set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bsmr7" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bsmr7" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bsmr7" ) ), bosscast(15), true, function Marine4Cast )
endfunction

//===========================================================================
function InitTrig_Marine4 takes nothing returns nothing
    set gg_trg_Marine4 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Marine4 )
    call TriggerRegisterVariableEvent( gg_trg_Marine4, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Marine4, Condition( function Trig_Marine4_Conditions ) )
    call TriggerAddAction( gg_trg_Marine4, function Trig_Marine4_Actions )
endfunction

