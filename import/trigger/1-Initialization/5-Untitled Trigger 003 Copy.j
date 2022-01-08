function Test2 takes unit u returns nothing

    set u = null
endfunction

function Trig_Untitled_Trigger_003_Copy_Actions takes nothing returns nothing
    call Test2(gg_unit_Hamg_0029)
endfunction

//===========================================================================
function InitTrig_Untitled_Trigger_003_Copy takes nothing returns nothing
    set gg_trg_Untitled_Trigger_003_Copy = CreateTrigger(  )
    call TriggerRegisterPlayerChatEvent( gg_trg_Untitled_Trigger_003_Copy, Player(0), "2", true )
    call TriggerAddAction( gg_trg_Untitled_Trigger_003_Copy, function Trig_Untitled_Trigger_003_Copy_Actions )
endfunction
