//TESH.scrollpos=0
//TESH.alwaysfold=0
function Trig_Ent3_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'e006' and GetUnitLifePercent(udg_DamageEventTarget) <= 25
endfunction

function Trig_Ent3_Actions takes nothing returns nothing
    local integer cyclA = 1 
    call DisableTrigger( GetTriggeringTrigger() )
    call UnitAddAbility( udg_DamageEventTarget, 'A0RR' )
    loop
        exitwhen cyclA > 4
        if GetUnitState( udg_hero[cyclA], UNIT_STATE_LIFE) > 0.405 then
            call dummyspawn( udg_DamageEventTarget, 1, 'A0K0', 0, 0 )
            call IssueTargetOrder( bj_lastCreatedUnit, "entanglingroots", udg_hero[cyclA] )
        endif
        set cyclA = cyclA + 1
    endloop
endfunction

//===========================================================================
function InitTrig_Ent3 takes nothing returns nothing
    set gg_trg_Ent3 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Ent3 )
    call TriggerRegisterVariableEvent( gg_trg_Ent3, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Ent3, Condition( function Trig_Ent3_Conditions ) )
    call TriggerAddAction( gg_trg_Ent3, function Trig_Ent3_Actions )
endfunction

