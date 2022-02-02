function Trig_Cheattp_Actions takes nothing returns nothing
    local integer cyclA = 1
    
    if GetTriggerPlayer() == udg_cheater then
        loop
            exitwhen cyclA > 4
            if GetPlayerSlotState(Player(cyclA - 1)) == PLAYER_SLOT_STATE_PLAYING then
                call ReviveHero( udg_hero[cyclA], GetRectCenterX(gg_rct_HeroTp), GetRectCenterY(gg_rct_HeroTp), true )
                call SetUnitPosition( udg_hero[cyclA], GetRectCenterX(gg_rct_HeroTp), GetRectCenterY(gg_rct_HeroTp))
                call SetUnitFacing( udg_hero[cyclA], 270 )
                call PanCameraToTimedForPlayer( Player(cyclA - 1), GetRectCenterX(gg_rct_HeroTp), GetRectCenterY(gg_rct_HeroTp), 0 )
            endif
            set cyclA = cyclA + 1
        endloop
    endif
endfunction

//===========================================================================
function InitTrig_Cheattp takes nothing returns nothing
    local integer cyclA = 0
    set gg_trg_Cheattp = CreateTrigger(  )
    call DisableTrigger( gg_trg_Cheattp )
    loop
        exitwhen cyclA > 3
            call TriggerRegisterPlayerChatEvent( gg_trg_Cheattp, Player(cyclA), "-tpgo", true )
        set cyclA = cyclA + 1
    endloop
    call TriggerAddAction( gg_trg_Cheattp, function Trig_Cheattp_Actions )
endfunction

