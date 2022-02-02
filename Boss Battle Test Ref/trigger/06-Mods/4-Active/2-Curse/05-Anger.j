function Trig_Anger_Conditions takes nothing returns boolean
    return udg_modbad[26]
endfunction

function Trig_Anger_Actions takes nothing returns nothing
    call UnitAddAbility(UNIT_BUFF, 'A0KH')
endfunction

//===========================================================================
function InitTrig_Anger takes nothing returns nothing
    set gg_trg_Anger = CreateTrigger(  )
    call TriggerRegisterVariableEvent( gg_trg_Anger, "Event_Mode_Awake_Real", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Anger, Condition( function Trig_Anger_Conditions ) )
    call TriggerAddAction( gg_trg_Anger, function Trig_Anger_Actions )
endfunction

