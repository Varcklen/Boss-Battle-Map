function Trig_Refresh_Actions takes nothing returns nothing
    call BJDebugMsg("Special shop refreshed.")
    call SpecialsShop_Refresh()
endfunction

//===========================================================================
function InitTrig_Refresh takes nothing returns nothing
    set gg_trg_Refresh = CreateTrigger()
    call DisableTrigger( gg_trg_Refresh )
    call TriggerRegisterPlayerChatEvent( gg_trg_Refresh, Player(0), "-ref", false )
    call TriggerAddAction( gg_trg_Refresh, function Trig_Refresh_Actions )
endfunction

