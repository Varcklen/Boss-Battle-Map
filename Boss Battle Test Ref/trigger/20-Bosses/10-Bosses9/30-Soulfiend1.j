function Trig_Soulfiend1_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'n04F'
endfunction

function Soulfiend1End takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local group g = CreateGroup()
    local unit u
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bssf2b" ) )
    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "bssf2" ) )

    if GetUnitState( dummy, UNIT_STATE_LIFE) <= 0.405 or GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call RemoveUnit( dummy )
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    else
        call GroupEnumUnitsInRange( g, GetUnitX( dummy ), GetUnitY( dummy ), 250, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if unitst( u, boss, "enemy" ) then
                call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Items\\AIil\\AIilTarget.mdl", GetUnitX( u ), GetUnitY( u ) ) )
                call SetUnitState( u, UNIT_STATE_LIFE, RMaxBJ(0,GetUnitState( u, UNIT_STATE_LIFE) - (GetUnitState( u, UNIT_STATE_MAX_LIFE)*0.1) ))
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

function Soulfiend1Cast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bssf1" ))
    local integer id1 
    
    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( boss ), 'u000', Math_GetUnitRandomX(boss, 400), Math_GetUnitRandomY(boss, 400), 270 )
    	call DestroyEffect( AddSpecialEffect( "CallOfAggression.mdx", GetUnitX( bj_lastCreatedUnit ), GetUnitY( bj_lastCreatedUnit ) ) )
    	call SetUnitScale( bj_lastCreatedUnit, 2.5, 2.5, 2.5 )
        call UnitAddAbility( bj_lastCreatedUnit, 'A170')

        set id1 = InvokeTimerWithUnit( bj_lastCreatedUnit, "bssf2", 1, true, function Soulfiend1End )
        call SaveUnitHandle( udg_hash, id1, StringHash( "bssf2b" ), boss )
    endif
    
    set boss = null
endfunction

function Trig_Soulfiend1_Actions takes nothing returns nothing
    call DisableTrigger( GetTriggeringTrigger() )
    call InvokeTimerWithUnit( udg_DamageEventTarget, "bssf1", bosscast(12), true, function Soulfiend1Cast )
endfunction

//===========================================================================
function InitTrig_Soulfiend1 takes nothing returns nothing
    set gg_trg_Soulfiend1 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Soulfiend1 )
    call TriggerRegisterVariableEvent( gg_trg_Soulfiend1, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Soulfiend1, Condition( function Trig_Soulfiend1_Conditions ) )
    call TriggerAddAction( gg_trg_Soulfiend1, function Trig_Soulfiend1_Actions )
endfunction

