function Trig_Cheatcast_Actions takes nothing returns nothing
    local integer cyclA = 0
    
    if GetTriggerPlayer() == udg_cheater then
        if IsTriggerEnabled(gg_trg_Cheatactive) then
            call DisableTrigger( gg_trg_Cheatactive )
            loop
                exitwhen cyclA > 4
                if GetPlayerSlotState( Player( cyclA ) ) == PLAYER_SLOT_STATE_PLAYING then
                    call DisplayTimedTextToPlayer( Player( cyclA ), 0, 0, 5, "Чит на перезарядку отключен." )
                endif
                set cyclA = cyclA + 1
            endloop
        else
            call EnableTrigger( gg_trg_Cheatactive )
            loop
                exitwhen cyclA > 4
                if GetPlayerSlotState( Player( cyclA ) ) == PLAYER_SLOT_STATE_PLAYING then
                    call DisplayTimedTextToPlayer( Player( cyclA ), 0, 0, 5, "Чит на перезарядку включен." )
                endif
                set cyclA = cyclA + 1
            endloop
        endif
    endif
endfunction

//===========================================================================
function InitTrig_Cheatcast takes nothing returns nothing
    local integer cyclA = 0
    set gg_trg_Cheatcast = CreateTrigger(  )
    call DisableTrigger( gg_trg_Cheatcast )
    loop
        exitwhen cyclA > 3
            call TriggerRegisterPlayerChatEvent( gg_trg_Cheatcast, Player(cyclA), "-cast", true )
        set cyclA = cyclA + 1
    endloop
    call TriggerAddAction( gg_trg_Cheatcast, function Trig_Cheatcast_Actions )
endfunction

