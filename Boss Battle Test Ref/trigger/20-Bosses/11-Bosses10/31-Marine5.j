function Trig_Marine5_Conditions takes nothing returns boolean
    return GetUnitTypeId( udg_DamageEventTarget ) == 'n04N' and GetUnitLifePercent(udg_DamageEventTarget) <= 70
endfunction

function Marine5Cast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "bsmr8" ) )
    local integer rand = GetRandomInt( 1, 4 )
    local string str
    
    if rand == 1 then
        set str = "I will not give up!"
    elseif rand == 2 then
        set str = "This will not happen again!"
    elseif rand == 3 then
        set str = "Now I'm really angry!"
    elseif rand == 4 then
        set str = "How did this happen?!"
    endif
    
    call TransmissionFromUnitWithNameBJ( bj_FORCE_ALL_PLAYERS, caster, GetUnitName(caster), null, str, bj_TIMETYPE_SET, 3, false )
    
    call UnitRemoveAbility( caster, LoadInteger( udg_hash, id, StringHash( "bsmr8" ) ) )
    call UnitRemoveAbility( caster, 'A0SB' )
    call UnitRemoveAbility( caster, 'A0SE' )
    call UnitRemoveAbility( caster, 'B01C' )
    call pausest( caster, -1 )
    call SetUnitAnimation( caster, "stand" )
    call FlushChildHashtable( udg_hash, id )
    
    set caster = null
endfunction


function Marine5BoomEnd takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bsmr10" ) )
    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "bsmr10d" ) )
    local group g = CreateGroup()
    local unit u
    
    call DestroyEffect( AddSpecialEffect("Abilities\\Spells\\Human\\Thunderclap\\ThunderClapCaster.mdl", GetUnitX(dummy), GetUnitY(dummy) ) )
    
    call GroupEnumUnitsInRange( g, GetUnitX( dummy ), GetUnitY( dummy ), 125, null )
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if unitst( u, boss, "enemy" ) then
            call UnitDamageTarget( dummy, u, 200, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
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

function Marine5Boom takes nothing returns nothing
    local integer cyclA = 1
    local integer id = GetHandleId( GetExpiredTimer() )
    local integer id1
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bsmr9" ) )
    local integer c = LoadInteger( udg_hash, id, StringHash( "bsmr9" ) ) + 1
    
    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) or c > 10 then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        call SaveInteger( udg_hash, id, StringHash( "bsmr9" ), c )
        loop
            exitwhen cyclA > 4
            if GetUnitState( udg_hero[cyclA], UNIT_STATE_LIFE) > 0.405 then
                set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( boss ), 'u000', GetUnitX( udg_hero[cyclA] ), GetUnitY( udg_hero[cyclA] ), 270 )
                if GetOwningPlayer(boss) == Player(10) then
                    call UnitAddAbility( bj_lastCreatedUnit, 'A136')
                endif
                
                set id1 = GetHandleId( udg_hero[cyclA] )
                if LoadTimerHandle( udg_hash, id1, StringHash( "bsmr10" ) ) == null  then
                    call SaveTimerHandle( udg_hash, id1, StringHash( "bsmr10" ), CreateTimer() )
                endif
                call SaveTimerHandle( udg_hash, id1, StringHash( "bsmr10" ), CreateTimer() )
                set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "bsmr10" ) ) ) 
                call SaveUnitHandle( udg_hash, id1, StringHash( "bsmr10" ), boss )
                call SaveUnitHandle( udg_hash, id1, StringHash( "bsmr10d" ), bj_lastCreatedUnit )
                call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_hero[cyclA] ), StringHash( "bsmr10" ) ), bosscast(2), false, function Marine5BoomEnd )
            endif
            set cyclA = cyclA + 1
        endloop
    endif
    
    set boss = null
 endfunction   

function Trig_Marine5_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )

    call DisableTrigger( GetTriggeringTrigger() )
    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bsmr" ) ), bosscast(10), true, function Marine2Cast )
    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bsmr4" ) ), bosscast(8), true, function Marine3Cast )
    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bsmr7" ) ), bosscast(12), true, function Marine4Cast )
    
    call TransmissionFromUnitWithNameBJ( bj_FORCE_ALL_PLAYERS, udg_DamageEventTarget, GetUnitName(udg_DamageEventTarget), null, "Ugh...", bj_TIMETYPE_SET, 3, false )
    call UnitAddAbility( udg_DamageEventTarget, 'A0SB' )
    call UnitAddAbility( udg_DamageEventTarget, 'A0SE' )
    call pausest( udg_DamageEventTarget, 1 )
    call SetUnitAnimation( udg_DamageEventTarget, "death" )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "bsmr8" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bsmr8" ), CreateTimer() )
    endif
    set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bsmr8" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bsmr8" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bsmr8" ) ), 5, false, function Marine5Cast )
    
    set id = GetHandleId( udg_DamageEventTarget )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "bsmr9" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bsmr9" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bsmr9" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bsmr9" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bsmr9" ) ), bosscast(0.5), true, function Marine5Boom )
endfunction

//===========================================================================
function InitTrig_Marine5 takes nothing returns nothing
    set gg_trg_Marine5 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Marine5 )
    call TriggerRegisterVariableEvent( gg_trg_Marine5, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Marine5, Condition( function Trig_Marine5_Conditions ) )
    call TriggerAddAction( gg_trg_Marine5, function Trig_Marine5_Actions )
endfunction

