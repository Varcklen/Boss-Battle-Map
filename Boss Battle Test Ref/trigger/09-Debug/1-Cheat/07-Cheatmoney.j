function Trig_Cheatmoney_Actions takes nothing returns nothing
    local integer cyclA = 0
    
    if GetTriggerPlayer() == udg_cheater then
        loop
            exitwhen cyclA > 3
            if GetPlayerSlotState( Player( cyclA) ) == PLAYER_SLOT_STATE_PLAYING then
                call moneyst( udg_hero[cyclA + 1], 1000 )
                call DisplayTimedTextToPlayer(Player( cyclA ), 0, 0, 5, "Получено 1000 золота." )
            endif
            set cyclA = cyclA + 1
        endloop
    endif
endfunction

//===========================================================================
function InitTrig_Cheatmoney takes nothing returns nothing
    local integer cyclA = 0
    set gg_trg_Cheatmoney = CreateTrigger(  )
    call DisableTrigger( gg_trg_Cheatmoney )
    loop
        exitwhen cyclA > 3
            call TriggerRegisterPlayerChatEvent( gg_trg_Cheatmoney, Player(cyclA), "-money", true )
        set cyclA = cyclA + 1
    endloop 
    call TriggerAddAction( gg_trg_Cheatmoney, function Trig_Cheatmoney_Actions )
endfunction

