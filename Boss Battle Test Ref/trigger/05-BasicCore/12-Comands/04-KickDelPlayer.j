function Trig_KickDelPlayer_Conditions takes nothing returns boolean
    return GetTriggerPlayer() != Player(S2I(udg_Kick_String) - 1) and not( udg_logic[GetPlayerId(GetTriggerPlayer()) + 1 + 66] ) and udg_logic[61]
endfunction

function Trig_KickDelPlayer_Actions takes nothing returns nothing
    local integer cyclA = 1
    set udg_number[95] = udg_number[95] + 1
    set udg_logic[GetPlayerId(GetTriggerPlayer()) + 1 + 66] = true
    call DisplayTimedTextToForce( bj_FORCE_ALL_PLAYERS, 10., ( "Player |cffffcc00" + ( GetPlayerName(GetTriggerPlayer()) + "|r confirmed the exception." ) ) )
    if udg_number[95] >= ( udg_Heroes_Amount - 1 ) then
        call DisableTrigger( GetTriggeringTrigger() )
        call PauseTimer(udg_timer[0])
        set udg_logic[61] = false
        call DisplayTimedTextToForce( bj_FORCE_ALL_PLAYERS, 10., ( "Player |cffffcc00" + ( GetPlayerName(Player(S2I(udg_Kick_String) - 1)) + "|r excluded from the game." ) ) )
        call DesyncPlayer( S2I( udg_Kick_String )-1)
        set cyclA = 1
        loop
            exitwhen cyclA > 4
            set udg_logic[cyclA + 66] = false
            set cyclA = cyclA + 1
        endloop
    endif
endfunction

//===========================================================================
function InitTrig_KickDelPlayer takes nothing returns nothing
    local integer cyclA = 0
    set gg_trg_KickDelPlayer = CreateTrigger(  )
    call DisableTrigger( gg_trg_KickDelPlayer )
    loop
        exitwhen cyclA > 3
        call TriggerRegisterPlayerChatEvent( gg_trg_KickDelPlayer, Player(cyclA), "+", true )
        set cyclA = cyclA + 1
    endloop
    call TriggerAddCondition( gg_trg_KickDelPlayer, Condition( function Trig_KickDelPlayer_Conditions ) )
    call TriggerAddAction( gg_trg_KickDelPlayer, function Trig_KickDelPlayer_Actions )
endfunction

