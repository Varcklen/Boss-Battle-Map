function Trig_Esc_Actions takes nothing returns nothing
    local integer i = GetPlayerId( GetTriggerPlayer() ) + 1

    if GetLocalPlayer() == GetTriggerPlayer() then
        if BlzFrameIsVisible( quartback ) then
			call BlzFrameSetVisible(quartback, false)
        elseif udg_LogicModes and udg_hero[i] != null then
            if BlzFrameIsVisible( modesback ) then
                call BlzFrameSetVisible(modesback, false)
            else
                call BlzFrameSetVisible(modesback, true)
            endif
		endif
    endif
endfunction

//===========================================================================
function InitTrig_Esc takes nothing returns nothing
    local integer i = 0
    set gg_trg_Esc = CreateTrigger()
    loop
        exitwhen i > 3
        call BlzTriggerRegisterPlayerKeyEvent( gg_trg_Esc, Player(i), OSKEY_ESCAPE, 0, false )
        set i = i + 1
    endloop
    call TriggerAddAction( gg_trg_Esc, function Trig_Esc_Actions )
endfunction

