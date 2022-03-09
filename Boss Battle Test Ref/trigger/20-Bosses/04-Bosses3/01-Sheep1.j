function Trig_Sheep1_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'n007'
endfunction

function Sheep1Repeat takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bstt3u" ) )
    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "bstt3d" ) )
    local group g = CreateGroup()
    local unit u
    local integer id1
    local boolean l = false
    
    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\Polymorph\\PolyMorphTarget.mdl", GetUnitX( dummy ), GetUnitY( dummy ) + 100 ) )
    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\Polymorph\\PolyMorphTarget.mdl", GetUnitX( dummy ) + 140, GetUnitY( dummy ) - 140 ) )
    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\Polymorph\\PolyMorphTarget.mdl", GetUnitX( dummy ) - 140, GetUnitY( dummy ) - 140 ) )
    
    call GroupEnumUnitsInRange( g, GetUnitX( dummy ), GetUnitY( dummy ), 200, null )
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if unitst( u, boss, "enemy" ) then
            call UnitPoly( boss, u, 'n02L', 5 )
            if IsUnitType( u, UNIT_TYPE_HERO) then
                set l = true
            endif
        endif
        call GroupRemoveUnit(g,u)
    endloop
    
    if l then
        set id1 = GetHandleId( dummy )
        if LoadTimerHandle( udg_hash, id1, StringHash( "bstt3d" ) ) == null  then
            call SaveTimerHandle( udg_hash, id1, StringHash( "bstt3d" ), CreateTimer() )
        endif
        set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "bstt3d" ) ) ) 
        call SaveUnitHandle( udg_hash, id1, StringHash( "bstt3d" ), dummy )
        call SaveUnitHandle( udg_hash, id1, StringHash( "bstt3u" ), boss )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( dummy ), StringHash( "bstt3d" ) ), bosscast(3), false, function Sheep1Repeat )
    else
        call RemoveUnit( dummy )
        call FlushChildHashtable( udg_hash, id )
    endif
    
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
    set boss = null
    set dummy = null
endfunction 

function Sheep1Cast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local integer id1
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bstt3" ) )

    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( boss ), 'u000', GetUnitX( boss ) + GetRandomReal(-500, 500), GetUnitY( boss ) + GetRandomReal(-500, 500), 270 )
        call SetUnitScale(bj_lastCreatedUnit, 2, 2, 2 )
        call UnitAddAbility( bj_lastCreatedUnit, 'A136')
        
        set id1 = GetHandleId( bj_lastCreatedUnit )
        if LoadTimerHandle( udg_hash, id1, StringHash( "bstt3d" ) ) == null then 
            call SaveTimerHandle( udg_hash, id1, StringHash( "bstt3d" ), CreateTimer() )
        endif
        set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "bstt3d" ) ) ) 
        call SaveUnitHandle( udg_hash, id1, StringHash( "bstt3d" ), bj_lastCreatedUnit )
        call SaveUnitHandle( udg_hash, id1, StringHash( "bstt3u" ), boss )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "bstt3d" ) ), bosscast(3), false, function Sheep1Repeat )
    endif
    
    set boss = null
endfunction

function Trig_Sheep1_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )

    call DisableTrigger( GetTriggeringTrigger() )

    if LoadTimerHandle( udg_hash, id, StringHash( "bstt3" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bstt3" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bstt3" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bstt3" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bstt3" ) ), bosscast(3), true, function Sheep1Cast )
endfunction

//===========================================================================
function InitTrig_Sheep1 takes nothing returns nothing
    set gg_trg_Sheep1 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Sheep1 )
    call TriggerRegisterVariableEvent( gg_trg_Sheep1, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Sheep1, Condition( function Trig_Sheep1_Conditions ) )
    call TriggerAddAction( gg_trg_Sheep1, function Trig_Sheep1_Actions )
endfunction