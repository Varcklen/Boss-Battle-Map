globals
    constant integer MODE_TRADE_EXCHANGE_NEW_COST = 50
endglobals

function Trig_Trade_Conditions takes nothing returns boolean
    return udg_modgood[13]
endfunction

function Trig_Trade_Actions takes nothing returns nothing
    set ExchangeCost = MODE_TRADE_EXCHANGE_NEW_COST
endfunction

//===========================================================================
function InitTrig_Trade takes nothing returns nothing
    set gg_trg_Trade = CreateTrigger(  )
    call TriggerRegisterVariableEvent( gg_trg_Trade, "Event_Mode_Awake_Real", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Trade, Condition( function Trig_Trade_Conditions ) )
    call TriggerAddAction( gg_trg_Trade, function Trig_Trade_Actions )
endfunction

