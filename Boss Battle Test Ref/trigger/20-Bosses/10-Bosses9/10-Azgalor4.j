function Trig_Azgalor4_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'h011' and GetUnitLifePercent(udg_DamageEventTarget) <= 25
endfunction

function Trig_Azgalor4_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )
    local group g = CreateGroup()
    local unit u

    call DisableTrigger( GetTriggeringTrigger() )
    
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bszg1" ) ), bosscast(6), true, function Azg2Cast )

    set bj_livingPlayerUnitsTypeId = 'h00O'
    call GroupEnumUnitsOfPlayer(g, GetOwningPlayer( udg_DamageEventTarget ), filterLivingPlayerUnitsOfTypeId)
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        set id = GetHandleId( u )
        if GetUnitState( u, UNIT_STATE_LIFE) > 0.405 then
            call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( u ), StringHash( "bszg1" ) ), bosscast(6), true, function Azg2Cast )
        endif
        call GroupRemoveUnit(g,u)
    endloop
    
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
endfunction

//===========================================================================
function InitTrig_Azgalor4 takes nothing returns nothing
    set gg_trg_Azgalor4 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Azgalor4 )
    call TriggerRegisterVariableEvent( gg_trg_Azgalor4, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Azgalor4, Condition( function Trig_Azgalor4_Conditions ) )
    call TriggerAddAction( gg_trg_Azgalor4, function Trig_Azgalor4_Actions )
endfunction

