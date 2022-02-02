function Trig_CheatSwap_Actions takes nothing returns nothing
    call heroswap()
endfunction

//===========================================================================
function InitTrig_CheatSwap takes nothing returns nothing
    local integer cyclA = 0
    set gg_trg_CheatSwap = CreateTrigger(  )
    call DisableTrigger( gg_trg_CheatSwap )
    loop
        exitwhen cyclA > 3
            call TriggerRegisterPlayerChatEvent( gg_trg_CheatSwap, Player(cyclA), "-swap", true )
        set cyclA = cyclA + 1
    endloop
    call TriggerAddAction( gg_trg_CheatSwap, function Trig_CheatSwap_Actions )
endfunction

