function Trig_Wyrm3_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventSource) == 'e00G' and GetUnitTypeId(udg_DamageEventTarget) == 'o00M'
endfunction

function Trig_Wyrm3_Actions takes nothing returns nothing
    set udg_DamageEventAmount = GetUnitState( udg_DamageEventTarget, UNIT_STATE_MAX_LIFE)*0.085
    if GetUnitState( udg_DamageEventSource, UNIT_STATE_LIFE) > 0.405 then
        call KillUnit( udg_DamageEventSource )
    endif
endfunction

//===========================================================================
function InitTrig_Wyrm3 takes nothing returns nothing
    set gg_trg_Wyrm3 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Wyrm3 )
    call TriggerRegisterVariableEvent( gg_trg_Wyrm3, "udg_DamageEventAfterArmor", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Wyrm3, Condition( function Trig_Wyrm3_Conditions ) )
    call TriggerAddAction( gg_trg_Wyrm3, function Trig_Wyrm3_Actions )
endfunction

