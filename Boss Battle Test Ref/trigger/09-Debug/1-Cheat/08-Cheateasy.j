function Trig_Cheateasy_Actions takes nothing returns nothing
    local integer cyclA = 0
    
    if GetTriggerPlayer() == udg_cheater then
        set udg_Heroes_Chanse = udg_Heroes_Chanse + 5
        call MultiSetValue( udg_multi, 2, 1, I2S(udg_Heroes_Chanse) )
        loop
            exitwhen cyclA > 3
            if GetPlayerSlotState( Player( cyclA ) ) == PLAYER_SLOT_STATE_PLAYING then
                call DisplayTimedTextToPlayer( Player( cyclA ), 0, 0, 5, "Добавлено 5 попыток." )
            endif
            set cyclA = cyclA + 1
        endloop
    endif
endfunction

//===========================================================================
function InitTrig_Cheateasy takes nothing returns nothing
    local integer cyclA = 0
    set gg_trg_Cheateasy = CreateTrigger(  )
    call DisableTrigger( gg_trg_Cheateasy )
    loop
        exitwhen cyclA > 3
            call TriggerRegisterPlayerChatEvent( gg_trg_Cheateasy, Player(cyclA), "-easy", true )
        set cyclA = cyclA + 1
    endloop
    call TriggerAddAction( gg_trg_Cheateasy, function Trig_Cheateasy_Actions )
endfunction

