function Trig_TimeGame_Actions takes nothing returns nothing
    local integer cyclA = 0
    local integer cyclB
    
    set udg_Multiboard_Time[1] = udg_Multiboard_Time[1] + 1
    if udg_Multiboard_Time[1] >= 60 then
        set udg_Multiboard_Time[1] = 0
        set udg_Multiboard_Time[2] = udg_Multiboard_Time[2] + 1
    elseif udg_Multiboard_Time[2] >= 60 then
        set udg_Multiboard_Time[1] = 0
        set udg_Multiboard_Time[2] = 0
        set udg_Multiboard_Time[3] = udg_Multiboard_Time[3] + 1
    endif
    call MultiboardSetTitleText( udg_multi, "Statistics [" + I2S(udg_Multiboard_Time[3]) + ":" + I2S(udg_Multiboard_Time[2]) + ":" + I2S(udg_Multiboard_Time[1]) + "]" )

    loop
        exitwhen cyclA > 3
        if GetPlayerSlotState( Player( cyclA ) ) == PLAYER_SLOT_STATE_PLAYING then
            set cyclB = 0
            loop
                exitwhen cyclB > 3
                if Player( cyclA ) != Player( cyclB ) then
                    call SetPlayerAlliance(Player( cyclA ), Player( cyclB ), ALLIANCE_SHARED_CONTROL, false )
                endif
                set cyclB = cyclB + 1
            endloop
        endif
        set cyclA = cyclA + 1
    endloop

endfunction

//===========================================================================
function InitTrig_TimeGame takes nothing returns nothing
    set gg_trg_TimeGame = CreateTrigger(  )
    call DisableTrigger( gg_trg_TimeGame )
    call TriggerRegisterTimerEvent( gg_trg_TimeGame, 1., true)
    call TriggerAddAction( gg_trg_TimeGame, function Trig_TimeGame_Actions )
endfunction

