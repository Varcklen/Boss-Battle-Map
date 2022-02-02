function Trig_ShoggothA_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventSource) == 'O016'
endfunction

function Trig_ShoggothA_Actions takes nothing returns nothing
    call DestroyEffect( AddSpecialEffect( "Units\\Creeps\\ForgottenOne\\ForgottenOneTent", GetUnitX(udg_DamageEventTarget), GetUnitY(udg_DamageEventTarget) ) )
endfunction

//===========================================================================
function InitTrig_ShoggothA takes nothing returns nothing
    set gg_trg_ShoggothA = CreateTrigger(  )
    call TriggerRegisterVariableEvent( gg_trg_ShoggothA, "udg_DamageModifierEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_ShoggothA, Condition( function Trig_ShoggothA_Conditions ) )
    call TriggerAddAction( gg_trg_ShoggothA, function Trig_ShoggothA_Actions )
endfunction

