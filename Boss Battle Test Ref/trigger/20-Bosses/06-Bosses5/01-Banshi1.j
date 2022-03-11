function Trig_Banshi1_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'n03M' 
endfunction

function Trig_Banshi1_Actions takes nothing returns nothing
    call DisableTrigger( GetTriggeringTrigger() )
    call UnitAddAbility( udg_DamageEventTarget, 'A0W8' )
endfunction

//===========================================================================
function InitTrig_Banshi1 takes nothing returns nothing
    set gg_trg_Banshi1 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Banshi1 )
    call TriggerRegisterVariableEvent( gg_trg_Banshi1, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Banshi1, Condition( function Trig_Banshi1_Conditions ) )
    call TriggerAddAction( gg_trg_Banshi1, function Trig_Banshi1_Actions )
endfunction

