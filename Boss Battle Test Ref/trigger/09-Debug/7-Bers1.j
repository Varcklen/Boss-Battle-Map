function Trig_Bers1_Actions takes nothing returns nothing
    call berserk( udg_hero[2], 1 )
endfunction

//===========================================================================
function InitTrig_Bers1 takes nothing returns nothing
    set gg_trg_Bers1 = CreateTrigger(  )
    call TriggerRegisterPlayerChatEvent( gg_trg_Bers1, Player(0), "2", true )
    call TriggerAddAction( gg_trg_Bers1, function Trig_Bers1_Actions )
endfunction

