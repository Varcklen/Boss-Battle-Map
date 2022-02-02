function Trig_Bers2_Actions takes nothing returns nothing
    call berserk( udg_hero[2], -1 )
endfunction

//===========================================================================
function InitTrig_Bers2 takes nothing returns nothing
    set gg_trg_Bers2 = CreateTrigger(  )
    call TriggerRegisterPlayerChatEvent( gg_trg_Bers2, Player(0), "3", true )
    call TriggerAddAction( gg_trg_Bers2, function Trig_Bers2_Actions )
endfunction

