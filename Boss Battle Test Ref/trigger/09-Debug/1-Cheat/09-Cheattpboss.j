function Trig_Cheattpboss_Actions takes nothing returns nothing
    if GetTriggerPlayer() == udg_cheater then
        set udg_Player_Readiness = udg_Heroes_Amount
        call TriggerExecute( gg_trg_StartFight )
    endif
endfunction

//===========================================================================
function InitTrig_Cheattpboss takes nothing returns nothing
    local integer cyclA = 0
    set gg_trg_Cheattpboss = CreateTrigger(  )
    call DisableTrigger( gg_trg_Cheattpboss )
    loop
        exitwhen cyclA > 3
            call TriggerRegisterPlayerChatEvent( gg_trg_Cheattpboss, Player(cyclA), "-tpboss", true )
        set cyclA = cyclA + 1
    endloop
    call TriggerAddAction( gg_trg_Cheattpboss, function Trig_Cheattpboss_Actions )
endfunction

