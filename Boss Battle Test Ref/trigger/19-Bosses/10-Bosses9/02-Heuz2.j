function Trig_Heuz2_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'e008' and GetUnitLifePercent(udg_DamageEventTarget) <= 85
endfunction

function Heuz2End takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local group g = CreateGroup()
    local unit u
    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "bshz4" ) )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bshz4b" ) )

    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or GetUnitState( dummy, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call RemoveUnit(dummy)
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    else
        call GroupEnumUnitsInRange( g, GetUnitX( dummy ), GetUnitY( dummy ), 150, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if unitst( u, dummy, "enemy" ) then
                if not(IsUnitType( u, UNIT_TYPE_HERO)) and not(IsUnitType( u, UNIT_TYPE_ANCIENT)) then
                    call UnitDamageTarget( dummy, u, 500, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )
                else
                    call UnitDamageTarget( dummy, u, 50, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )
                endif
            endif
            call GroupRemoveUnit( g, u )
        endloop
    endif
    
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
    set dummy = null
    set boss = null
endfunction

function Heuz2Cast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local integer id1 
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bshz3" ))
    
    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( boss ), 'u000', GetUnitX( boss ) + GetRandomReal(-300, 300), GetUnitY( boss ) + GetRandomReal(-300, 300), 270 )
        call UnitAddAbility( bj_lastCreatedUnit, 'A0RQ')
        call DestroyEffect( AddSpecialEffectTarget( "Acid Ex.mdx", bj_lastCreatedUnit, "origin") )
        set id1 = GetHandleId( bj_lastCreatedUnit )
        
        if LoadTimerHandle( udg_hash, id1, StringHash( "bshz4" ) ) == null  then
            call SaveTimerHandle( udg_hash, id1, StringHash( "bshz4" ), CreateTimer() )
        endif
        set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "bshz4" ) ) ) 
        call SaveUnitHandle( udg_hash, id1, StringHash( "bshz4" ), bj_lastCreatedUnit )
        call SaveUnitHandle( udg_hash, id1, StringHash( "bshz4b" ),boss )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "bshz4" ) ), 1, true, function Heuz2End )
    endif
    
    set boss = null
endfunction

function Trig_Heuz2_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )

    call DisableTrigger( GetTriggeringTrigger() )
    call UnitAddAbility( udg_DamageEventTarget, 'A05K')
    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Undead\\DeathPact\\DeathPactTarget.mdl", GetUnitX( udg_DamageEventTarget ), GetUnitY( udg_DamageEventTarget ) ) )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "bshz3" ) ) == null then 
        call SaveTimerHandle( udg_hash, id, StringHash( "bshz3" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bshz3" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bshz3" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bshz3" ) ), bosscast(5), true, function Heuz2Cast )
endfunction

//===========================================================================
function InitTrig_Heuz2 takes nothing returns nothing
    set gg_trg_Heuz2 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Heuz2 )
    call TriggerRegisterVariableEvent( gg_trg_Heuz2, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Heuz2, Condition( function Trig_Heuz2_Conditions ) )
    call TriggerAddAction( gg_trg_Heuz2, function Trig_Heuz2_Actions )
endfunction

