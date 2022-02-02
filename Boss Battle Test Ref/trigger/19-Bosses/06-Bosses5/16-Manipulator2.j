function Trig_Manipulator2_Conditions takes nothing returns boolean
    return GetUnitTypeId( udg_DamageEventTarget ) == 'n02W' and GetUnitLifePercent(udg_DamageEventTarget) <= 80
endfunction

function ManipSquad takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "bsmn1" ))
    local group g = CreateGroup()
    local unit u
    
     if GetUnitState( dummy, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        call GroupEnumUnitsInRange( g, GetUnitX(dummy), GetUnitY(dummy), 128, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if unitst( u, dummy, "enemy" ) then
                call SetUnitState( u, UNIT_STATE_MANA, RMaxBJ( 0,GetUnitState( u, UNIT_STATE_MANA ) - ( GetUnitState( u, UNIT_STATE_MAX_MANA ) * 0.04 * udg_SpellDamage[0] ) ) )
                call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Undead\\ReplenishMana\\ReplenishManaCaster.mdl", u, "origin") )
            endif
            call GroupRemoveUnit(g,u)
        endloop
    endif
    
    call GroupClear( g )
    call DestroyGroup( g )
    set g = null
    set u = null
    set dummy = null
endfunction

function ManipCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bsmn" ) )
    local integer id1

    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( boss ), 'u000', GetUnitX( boss ) + GetRandomReal(-600, 600), GetUnitY( boss ) + GetRandomReal(-600, 600), 270 )
        call UnitAddAbility( bj_lastCreatedUnit, 'A076')
        call UnitApplyTimedLife( bj_lastCreatedUnit, 'BTLF', 30)
        call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Demon\\DarkPortal\\DarkPortalTarget.mdl", bj_lastCreatedUnit, "origin") )
        
        set id1 = GetHandleId( bj_lastCreatedUnit )
        if LoadTimerHandle( udg_hash, id1, StringHash( "bsmn1" ) ) == null  then
            call SaveTimerHandle( udg_hash, id1, StringHash( "bsmn1" ), CreateTimer() )
        endif
        set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "bsmn1" ) ) ) 
        call SaveUnitHandle( udg_hash, id1, StringHash( "bsmn1" ), bj_lastCreatedUnit )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "bsmn1" ) ), 1, true, function ManipSquad )
    endif
    
    set boss = null
endfunction

function Trig_Manipulator2_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )
    
    call DisableTrigger( GetTriggeringTrigger() )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "bsmn" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bsmn" ), CreateTimer() )
    endif
    set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bsmn" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bsmn" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bsmn" ) ), bosscast(10), true, function ManipCast )
endfunction

//===========================================================================
function InitTrig_Manipulator2 takes nothing returns nothing
    set gg_trg_Manipulator2 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Manipulator2 )
    call TriggerRegisterVariableEvent( gg_trg_Manipulator2, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Manipulator2, Condition( function Trig_Manipulator2_Conditions ) )
    call TriggerAddAction( gg_trg_Manipulator2, function Trig_Manipulator2_Actions )
endfunction

