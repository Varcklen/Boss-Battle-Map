function Trig_Illusionist2_Conditions takes nothing returns boolean
    return GetUnitTypeId( udg_DamageEventTarget ) == 'h020'
endfunction

function Illusionist2End takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bsil2u" ) )
    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "bsil2" ) )
    local boolean l = LoadBoolean( udg_hash, id, StringHash( "bsil2" ) )
    local group g = CreateGroup()
    local unit u
    
    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Undead\\DeathCoil\\DeathCoilSpecialArt.mdl", GetUnitX( dummy ), GetUnitY( dummy ) + 100 ) )
    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Undead\\DeathCoil\\DeathCoilSpecialArt.mdl", GetUnitX( dummy ) + 140, GetUnitY( dummy ) - 140 ) )
    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Undead\\DeathCoil\\DeathCoilSpecialArt.mdl", GetUnitX( dummy ) - 140, GetUnitY( dummy ) - 140 ) )
    call GroupEnumUnitsInRange( g, GetUnitX( dummy ), GetUnitY( dummy ), 200, null )
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if unitst( u, boss, "enemy" ) then
            if not(l) then
                call UnitDamageTarget( dummy, u, 300, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
            else
                call healst( u, null, 100*udg_SpellDamage[0] )
                call manast( u, null, 30*udg_SpellDamage[0] )
            endif
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

function Illusionist2HEnd takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bsil3u" ) )
    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "bsil3" ) )
    local boolean l = LoadBoolean( udg_hash, id, StringHash( "bsil3" ) )
    local group g = CreateGroup()
    local unit u
    
    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\Resurrect\\ResurrectTarget.mdl", GetUnitX( dummy ), GetUnitY( dummy ) + 100 ) )
    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\Resurrect\\ResurrectTarget.mdl", GetUnitX( dummy ) + 140, GetUnitY( dummy ) - 140 ) )
    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\Resurrect\\ResurrectTarget.mdl", GetUnitX( dummy ) - 140, GetUnitY( dummy ) - 140 ) )
    call GroupEnumUnitsInRange( g, GetUnitX( dummy ), GetUnitY( dummy ), 200, null )
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if unitst( u, boss, "enemy" ) then
            if not(l) then
            	call healst( u, null, 100*udg_SpellDamage[0] )
            	call manast( u, null, 30*udg_SpellDamage[0] )
            else
            	call UnitDamageTarget( dummy, u, 300, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
            endif
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

function Illusionist2Cast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local integer id1
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bsil1" ) )
    local boolean l = LoadBoolean( udg_hash, GetHandleId( boss ), StringHash( "bsilb" ) )

    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( boss ), 'u000', GetUnitX( boss ) + GetRandomReal(-500, 500), GetUnitY( boss ) + GetRandomReal(-500, 500), 270 )
        call SetUnitScale(bj_lastCreatedUnit, 2, 2, 2 )
        call UnitAddAbility( bj_lastCreatedUnit, 'A136')
        
        set id1 = GetHandleId( bj_lastCreatedUnit )
        if LoadTimerHandle( udg_hash, id1, StringHash( "bsil2" ) ) == null  then
            call SaveTimerHandle( udg_hash, id1, StringHash( "bsil2" ), CreateTimer() )
        endif
        set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "bsil2" ) ) ) 
        call SaveUnitHandle( udg_hash, id1, StringHash( "bsil2" ), bj_lastCreatedUnit )
        call SaveUnitHandle( udg_hash, id1, StringHash( "bsil2u" ), boss )
    	call SaveBoolean( udg_hash, id1, StringHash( "bsil2" ), l )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "bsil2" ) ), bosscast(3), false, function Illusionist2End )


        set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( boss ), 'u000', GetUnitX( boss ) + GetRandomReal(-500, 500), GetUnitY( boss ) + GetRandomReal(-500, 500), 270 )
        call SetUnitScale(bj_lastCreatedUnit, 2, 2, 2 )
        call UnitAddAbility( bj_lastCreatedUnit, 'A0BY')
        
        set id1 = GetHandleId( bj_lastCreatedUnit )
        if LoadTimerHandle( udg_hash, id1, StringHash( "bsil3" ) ) == null  then
            call SaveTimerHandle( udg_hash, id1, StringHash( "bsil3" ), CreateTimer() )
        endif
        set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "bsil3" ) ) ) 
        call SaveUnitHandle( udg_hash, id1, StringHash( "bsil3" ), bj_lastCreatedUnit )
        call SaveUnitHandle( udg_hash, id1, StringHash( "bsil3u" ), boss )
    	call SaveBoolean( udg_hash, id1, StringHash( "bsil3" ), l )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "bsil3" ) ), bosscast(3), false, function Illusionist2HEnd )
    endif
    
    set boss = null
endfunction

function Trig_Illusionist2_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )

    call DisableTrigger( GetTriggeringTrigger() )
    call SaveBoolean( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bsilb" ), false )

    if LoadTimerHandle( udg_hash, id, StringHash( "bsil1" ) ) == null then 
        call SaveTimerHandle( udg_hash, id, StringHash( "bsil1" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bsil1" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bsil1" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bsil1" ) ), bosscast(5), true, function Illusionist2Cast )
endfunction

//===========================================================================
function InitTrig_Illusionist2 takes nothing returns nothing
    set gg_trg_Illusionist2 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Illusionist2 )
    call TriggerRegisterVariableEvent( gg_trg_Illusionist2, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Illusionist2, Condition( function Trig_Illusionist2_Conditions ) )
    call TriggerAddAction( gg_trg_Illusionist2, function Trig_Illusionist2_Actions )
endfunction

