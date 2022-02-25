function Trig_Salamander2_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'n041' and GetUnitLifePercent(udg_DamageEventTarget) <= 25
endfunction

function Trig_Salamander2_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )
    local unit boss = udg_DamageEventTarget
    call UnitAddAbilityBJ( 'A0JT', boss )
    call PolledWait( 30 )
    call UnitRemoveAbilityBJ( 'A0JT', boss )
    call DisableTrigger( GetTriggeringTrigger() )
    
endfunction

//===========================================================================
function InitTrig_Salamander2 takes nothing returns nothing
    set gg_trg_Salamander2 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Salamander2 )
    call TriggerRegisterVariableEvent( gg_trg_Salamander2, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Salamander2, Condition( function Trig_Salamander2_Conditions ) )
    call TriggerAddAction( gg_trg_Salamander2, function Trig_Salamander2_Actions )
endfunction

