function Trig_Color_Conditions takes nothing returns boolean
    return not(udg_fightmod[0]) and SubString(GetEventPlayerChatString(), 0, 6) == "-color"
endfunction

function ColorIf takes integer k returns boolean
    local integer cyclA = 1
    local boolean l = true
    
    loop
        exitwhen cyclA > 4
        if udg_Player_Color_Int[cyclA] == k then
            set l = false
            set cyclA = 4
        endif
        set cyclA = cyclA + 1
    endloop
    if 5 == k or 11 == k or 12 == k then
        set l = false
    endif
    return l
endfunction

function Trig_Color_Actions takes nothing returns nothing
    local integer i = GetPlayerId(GetTriggerPlayer()) + 1
    local integer k = S2I(SubString(GetEventPlayerChatString(), 7, 9))

    if k >= 1 and k <= 24 then
        if ColorIf(k) then
            set udg_Player_Color_Int[i] = k
            set udg_Player_Color[i] = udg_DB_Player_Color[k]
            call SetPlayerColorBJ( GetTriggerPlayer(), ConvertPlayerColor(k-1), true )
        
            if udg_Host == GetTriggerPlayer() then
                call BlzFrameSetText( modeshostname, "Host: " + udg_Player_Color[i] + GetPlayerName(udg_Host) + "|r" )
            endif
            call MultiSetColor( udg_multi, ( 3 * udg_Multiboard_Position[i] ) - 1, 3, 255, 255, 255, 0.00 )
            call MultiSetValue( udg_multi, ( 3 * udg_Multiboard_Position[i] ) - 1, 3, udg_Player_Color[i] + GetPlayerName(GetTriggerPlayer()) + "|r" )
            
            call DisplayTimedTextToForce( bj_FORCE_ALL_PLAYERS, 5, udg_DB_Player_Color[k] + GetPlayerName(GetTriggerPlayer()) + "|r changed color to a new one." )
        else
            call DisplayTimedTextToPlayer( GetTriggerPlayer(), 0, 0, 5, "This " + udg_DB_Player_Color[k] + "color|r is already in use by another player. Choose a different color.")
        endif
    endif
endfunction

//===========================================================================
function InitTrig_Color takes nothing returns nothing
    local integer cyclA = 0
    set gg_trg_Color = CreateTrigger(  )
    loop
        exitwhen cyclA > 3
        call TriggerRegisterPlayerChatEvent( gg_trg_Color, Player(cyclA), "-color ", false )
        set cyclA = cyclA + 1
    endloop
    call TriggerAddCondition( gg_trg_Color, Condition( function Trig_Color_Conditions ) )
    call TriggerAddAction( gg_trg_Color, function Trig_Color_Actions )
endfunction

