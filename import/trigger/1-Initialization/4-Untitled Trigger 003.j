function Test1 takes unit u returns nothing
endfunction

function Trig_Untitled_Trigger_003_Actions takes nothing returns nothing
    call Test1(gg_unit_Hamg_0029)
endfunction

//===========================================================================
function InitTrig_Untitled_Trigger_003 takes nothing returns nothing
    set gg_trg_Untitled_Trigger_003 = CreateTrigger(  )
    call TriggerRegisterPlayerChatEvent( gg_trg_Untitled_Trigger_003, Player(0), "1", true )
    call TriggerAddAction( gg_trg_Untitled_Trigger_003, function Trig_Untitled_Trigger_003_Actions )
endfunction

