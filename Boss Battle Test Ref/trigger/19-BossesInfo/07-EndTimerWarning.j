function Trig_EndTimerWarning_Actions takes nothing returns nothing
    call DisplayTimedTextToForce( GetPlayersAll(), 10, "|cffffcc00Warning!|r 20 seconds left before the battle starts!" )
    call StartSound(gg_snd_Warning)
endfunction

//===========================================================================
function InitTrig_EndTimerWarning takes nothing returns nothing
    set gg_trg_EndTimerWarning = CreateTrigger(  )
    call TriggerRegisterTimerExpireEvent( gg_trg_EndTimerWarning, udg_timer[2] )
    call TriggerAddAction( gg_trg_EndTimerWarning, function Trig_EndTimerWarning_Actions )
endfunction

