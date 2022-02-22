function Trig_GhostKnight1_Conditions takes nothing returns boolean
    return GetUnitTypeId( udg_DamageEventTarget ) == 'n008' 
endfunction

function GhostKnightCast1 takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local integer cyclA
    local unit u
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bsgk1" ) )

    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        call SetUnitAnimation( boss, "spell" )
        call QueueUnitAnimation( boss, "stand" )
        set cyclA = 1
        loop
            exitwhen cyclA > 4
            if GetUnitState( udg_hero[cyclA], UNIT_STATE_LIFE ) > 0.405 and GetUnitLifePercent(udg_hero[cyclA]) >= GetUnitLifePercent(udg_hero[cyclA - 1] ) and GetUnitLifePercent(udg_hero[cyclA]) >= GetUnitLifePercent(udg_hero[cyclA - 2] ) and GetUnitLifePercent(udg_hero[cyclA]) >= GetUnitLifePercent(udg_hero[cyclA - 3] ) then
                set u = udg_hero[cyclA]
            endif
            set cyclA = cyclA + 1
        endloop
        call dummyspawn( boss, 1, 'A03M', 0, 0 )
        call IssueTargetOrder( bj_lastCreatedUnit, "deathcoil", u )
    endif
    
    set u = null
    set boss = null
endfunction

function GhostKnightCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local group g = CreateGroup()
    local unit u
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bsgk" ) )
    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "bsgkd" ) )
    
     if GetUnitState( dummy, UNIT_STATE_LIFE) <= 0.405 or GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call RemoveUnit(dummy)
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        call GroupEnumUnitsInRange( g, GetUnitX(boss), GetUnitY(boss), 900, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if unitst( u, boss, "enemy" ) then
                call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "origin") )
                call UnitDamageTarget( dummy, u, 15, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )
            endif
            call GroupRemoveUnit(g,u)
        endloop
    endif
    
    call GroupClear( g )
    call DestroyGroup( g )
    set g = null
    set u = null
    set boss = null
    set dummy = null
endfunction

function Trig_GhostKnight1_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )

    call DisableTrigger( GetTriggeringTrigger() )
    
    call dummyspawn( udg_DamageEventTarget, 0, 0, 0, 0 )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "bsgk" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bsgk" ), CreateTimer() )
    endif
    set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bsgk" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bsgk" ), udg_DamageEventTarget )
    call SaveUnitHandle( udg_hash, id, StringHash( "bsgkd" ), bj_lastCreatedUnit )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bsgk" ) ), 1, true, function GhostKnightCast )
    
    set id = GetHandleId( udg_DamageEventTarget )
    if LoadTimerHandle( udg_hash, id, StringHash( "bsgk1" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bsgk1" ), CreateTimer() )
    endif
    set id = GetHandleId( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bsgk1" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bsgk1" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bsgk1" ) ), bosscast(6), true, function GhostKnightCast1 )
endfunction

//===========================================================================
function InitTrig_GhostKnight1 takes nothing returns nothing
    set gg_trg_GhostKnight1 = CreateTrigger(  )
    call DisableTrigger( gg_trg_GhostKnight1 )
    call TriggerRegisterVariableEvent( gg_trg_GhostKnight1, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_GhostKnight1, Condition( function Trig_GhostKnight1_Conditions ) )
    call TriggerAddAction( gg_trg_GhostKnight1, function Trig_GhostKnight1_Actions )
endfunction

