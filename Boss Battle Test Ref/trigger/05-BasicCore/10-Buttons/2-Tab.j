function Trig_Tab_Actions takes nothing returns nothing
    local integer i = GetPlayerId( GetTriggerPlayer() ) + 1

    if GetLocalPlayer() == GetTriggerPlayer() then
        if udg_combatlogic[i] and udg_Guild[i] != 0 and udg_Guild[i] != 2 and udg_Guild[i] != 6 and not(udg_GuildDone[i]) then
            if BlzFrameIsVisible( gqfone ) then
                call BlzFrameSetVisible(gqfone, false)
            else
                call BlzFrameSetVisible(gqfone, true)
            endif
        endif
    endif
endfunction

//===========================================================================
function InitTrig_Tab takes nothing returns nothing
    local integer i = 0
    set gg_trg_Tab = CreateTrigger()
    loop
        exitwhen i > 3
        call BlzTriggerRegisterPlayerKeyEvent( gg_trg_Tab, Player(i), OSKEY_TAB, 0, false )
        set i = i + 1
    endloop
    call TriggerAddAction( gg_trg_Tab, function Trig_Tab_Actions )
endfunction

