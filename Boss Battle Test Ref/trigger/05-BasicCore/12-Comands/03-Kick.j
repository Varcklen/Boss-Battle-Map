function DesyncPlayer takes integer id returns nothing
    if GetLocalPlayer()==Player(id) then
        call Location(0,0)
    endif
endfunction

function Trig_Kick_Conditions takes nothing returns boolean
    return SubString(GetEventPlayerChatString(), 0, 5) == "-kick" and  udg_Heroes_Amount > 2 and not( udg_logic[61] )
endfunction

function KickTimer takes nothing returns nothing
    local integer cyclA = 1
    call DisplayTimedTextToForce( bj_FORCE_ALL_PLAYERS, 10, "The poll is over. Player |cffffcc00" + GetPlayerName(Player(S2I(udg_Kick_String) - 1)) + "|r will not be excluded." )
    set udg_logic[61] = false
    loop
        exitwhen cyclA > 4
        set udg_logic[cyclA + 66] = false
        set cyclA = cyclA + 1
    endloop
    call DestroyTimer( GetExpiredTimer() )
endfunction

function Trig_Kick_Actions takes nothing returns nothing
    local integer i
    set udg_Kick_String = SubString(GetEventPlayerChatString(), 6, 7)
    if udg_Kick_String == "1" or udg_Kick_String == "2" or udg_Kick_String == "3" or udg_Kick_String == "4" then
        set i = S2I(udg_Kick_String)
        if GetTriggerPlayer() != Player(i - 1) and GetPlayerSlotState(Player(i - 1)) == PLAYER_SLOT_STATE_PLAYING then
            set udg_logic[61] = true
            set udg_number[95] = 1 
            set udg_logic[66 + GetPlayerId(GetTriggerPlayer()) + 1] = true
            call EnableTrigger( gg_trg_KickDelPlayer )
            call DisplayTimedTextToForce( bj_FORCE_ALL_PLAYERS, 10, "Player |cffffcc00" + GetPlayerName(GetTriggerPlayer()) + "|r proposes to exclude player |cffffcc00" + GetPlayerName(Player(i - 1)) + "|r from the game." )
            call DisplayTimedTextToForce( bj_FORCE_ALL_PLAYERS, 10, "If you agree to exclude a player, write to the chat +" )
            set udg_timer[0] = CreateTimer()
            call TimerStart( udg_timer[0], 30, false, function KickTimer )
        endif
    endif
endfunction

//===========================================================================
function InitTrig_Kick takes nothing returns nothing
    local integer cyclA = 0
    set gg_trg_Kick = CreateTrigger()
    loop
        exitwhen cyclA > 3
        call TriggerRegisterPlayerChatEvent( gg_trg_Kick, Player(cyclA), "-kick ", false )
        set cyclA = cyclA + 1
    endloop
    call TriggerAddCondition( gg_trg_Kick, Condition( function Trig_Kick_Conditions ) )
    call TriggerAddAction( gg_trg_Kick, function Trig_Kick_Actions )
endfunction

