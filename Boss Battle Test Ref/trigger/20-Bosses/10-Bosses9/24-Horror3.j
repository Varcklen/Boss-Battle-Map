function Trig_Horror3_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'e002'
endfunction

function Horror3End takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bshr2u" ) )
    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "bshr2d" ) )
    local group g = CreateGroup()
    local unit u
    
    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Other\\HowlOfTerror\\HowlCaster.mdl", GetUnitX( dummy ), GetUnitY( dummy ) + 100 ) )
    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Other\\HowlOfTerror\\HowlCaster.mdl", GetUnitX( dummy ) + 140, GetUnitY( dummy ) - 140 ) )
    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Other\\HowlOfTerror\\HowlCaster.mdl", GetUnitX( dummy ) - 140, GetUnitY( dummy ) - 140 ) )
    call GroupEnumUnitsInRange( g, GetUnitX( dummy ), GetUnitY( dummy ), 300, null )
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if unitst( u, boss, "enemy" ) then
            call UnitDamageTarget( dummy, u, 450, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
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

function Horror3Cast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local integer id1
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bshr2" ) )
    local integer cyclA = 1

    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
	loop
		exitwhen cyclA > 3
        	set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( boss ), 'u000', GetUnitX( boss ) + GetRandomReal(-500, 500), GetUnitY( boss ) + GetRandomReal(-500, 500), 270 )
        	call SetUnitScale(bj_lastCreatedUnit, 3, 3, 3 )
        	call UnitAddAbility( bj_lastCreatedUnit, 'A136')
        
        	set id1 = GetHandleId( bj_lastCreatedUnit )
        	if LoadTimerHandle( udg_hash, id1, StringHash( "bshr2d" ) ) == null  then
            		call SaveTimerHandle( udg_hash, id1, StringHash( "bshr2d" ), CreateTimer() )
        	endif
        	set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "bshr2d" ) ) ) 
        	call SaveUnitHandle( udg_hash, id1, StringHash( "bshr2d" ), bj_lastCreatedUnit )
        	call SaveUnitHandle( udg_hash, id1, StringHash( "bshr2u" ), boss )
        	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "bshr2d" ) ), bosscast(3), false, function Horror3End )
		set cyclA = cyclA + 1
	endloop
    endif
    
    set boss = null
endfunction

function Trig_Horror3_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )

    call DisableTrigger( GetTriggeringTrigger() )

    if LoadTimerHandle( udg_hash, id, StringHash( "bshr2" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bshr2" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bshr2" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bshr2" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bshr2" ) ), bosscast(15), true, function Horror3Cast )
endfunction

//===========================================================================
function InitTrig_Horror3 takes nothing returns nothing
    set gg_trg_Horror3 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Horror3 )
    call TriggerRegisterVariableEvent( gg_trg_Horror3, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Horror3, Condition( function Trig_Horror3_Conditions ) )
    call TriggerAddAction( gg_trg_Horror3, function Trig_Horror3_Actions )
endfunction

