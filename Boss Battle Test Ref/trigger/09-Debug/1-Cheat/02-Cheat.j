function Trig_Cheat_Conditions takes nothing returns boolean
   return GetPlayerName(GetTriggerPlayer()) == "Varcklen"
endfunction

function Trig_Cheat_Actions takes nothing returns nothing
    local integer cyclA = 0

    if udg_GameStatus != GAME_STATUS_ONLINE then
        call DisableTrigger( GetTriggeringTrigger() )

        set udg_logic[0] = true
        call MultiSetColor( udg_multi, 3, 2, 80.00, 0.00, 0.00, 25.00 )
        loop
            exitwhen cyclA > 3
            if GetPlayerSlotState( Player( cyclA ) ) == PLAYER_SLOT_STATE_PLAYING then
                call DisplayTimedTextToPlayer(Player(cyclA), 0, 0, 5, "Cheats enabled by player: " + GetPlayerName(GetTriggerPlayer()) + "." )
            endif
            set cyclA = cyclA + 1
        endloop
        set udg_cheater = GetTriggerPlayer()
        call CheatEnable()
    endif
endfunction

//===========================================================================
function InitTrig_Cheat takes nothing returns nothing
    local integer cyclA = 0
    set gg_trg_Cheat = CreateTrigger()
    loop
        exitwhen cyclA > 3
         call TriggerRegisterPlayerChatEvent( gg_trg_Cheat, Player(cyclA), "-cheat", true )
        set cyclA = cyclA + 1
    endloop
    call TriggerAddCondition( gg_trg_Cheat, Condition( function Trig_Cheat_Conditions ) )
    call TriggerAddAction( gg_trg_Cheat, function Trig_Cheat_Actions )
endfunction

