function Trig_Voidlord4_Conditions takes nothing returns boolean
    return GetUnitTypeId( udg_DamageEventTarget ) == 'n00C'
endfunction

function Voidlord4End takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bbvd2u" ) )
    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "bbvd2" ) )
    local group g = CreateGroup()
    local unit u
    
    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Other\\HowlOfTerror\\HowlCaster.mdl", GetUnitX( dummy ), GetUnitY( dummy ) + 100 ) )
    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Other\\HowlOfTerror\\HowlCaster.mdl", GetUnitX( dummy ) + 140, GetUnitY( dummy ) - 140 ) )
    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Other\\HowlOfTerror\\HowlCaster.mdl", GetUnitX( dummy ) - 140, GetUnitY( dummy ) - 140 ) )
    call GroupEnumUnitsInRange( g, GetUnitX( dummy ), GetUnitY( dummy ), 300, null )
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if unitst( u, boss, "enemy" ) and GetOwningPlayer(u) != Player(PLAYER_NEUTRAL_AGGRESSIVE) and not(IsUnitHiddenBJ(u)) then
            call KillUnit( u )
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

function Voidlord4Cast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local integer id1
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bbvd1" ) )
    local unit target = GroupPickRandomUnit(udg_otryad)
        	
    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    elseif target != null then
        set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( boss ), 'u000', GetUnitX( target ) + GetRandomReal(-300, 300), GetUnitY( target ) + GetRandomReal(-300, 300), 270 )
        call SetUnitScale(bj_lastCreatedUnit, 3, 3, 3 )
        call UnitAddAbility( bj_lastCreatedUnit, 'A136')
        
        set id1 = GetHandleId( bj_lastCreatedUnit )
        if LoadTimerHandle( udg_hash, id1, StringHash( "bbvd2" ) ) == null  then
            call SaveTimerHandle( udg_hash, id1, StringHash( "bbvd2" ), CreateTimer() )
        endif
        set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "bbvd2" ) ) ) 
        call SaveUnitHandle( udg_hash, id1, StringHash( "bbvd2" ), bj_lastCreatedUnit )
        call SaveUnitHandle( udg_hash, id1, StringHash( "bbvd2u" ), boss )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "bbvd2" ) ), bosscast(5), false, function Voidlord4End )
    endif
    
    set boss = null
    set target = null
endfunction

function Trig_Voidlord4_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )

    call DisableTrigger( GetTriggeringTrigger() )

    if LoadTimerHandle( udg_hash, id, StringHash( "bbvd1" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bbvd1" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bbvd1" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bbvd1" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bbvd1" ) ), bosscast(7), true, function Voidlord4Cast )
endfunction

//===========================================================================
function InitTrig_Voidlord4 takes nothing returns nothing
    set gg_trg_Voidlord4 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Voidlord4 )
    call TriggerRegisterVariableEvent( gg_trg_Voidlord4, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Voidlord4, Condition( function Trig_Voidlord4_Conditions ) )
    call TriggerAddAction( gg_trg_Voidlord4, function Trig_Voidlord4_Actions )
endfunction

