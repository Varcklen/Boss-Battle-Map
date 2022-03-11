function Trig_NoRepick_Actions takes nothing returns nothing
    set udg_logic[9] = true
    call BlzFrameSetVisible( rpkmod,false)
endfunction

//===========================================================================
function InitTrig_NoRepick takes nothing returns nothing
    set gg_trg_NoRepick = CreateTrigger(  )
    call TriggerRegisterTimerExpireEvent( gg_trg_NoRepick, udg_timer[3] )
    call TriggerAddAction( gg_trg_NoRepick, function Trig_NoRepick_Actions )
endfunction

