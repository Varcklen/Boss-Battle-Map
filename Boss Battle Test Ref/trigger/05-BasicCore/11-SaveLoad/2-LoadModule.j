function Trig_LoadModule_Actions takes nothing returns nothing
    call Preloader("BossBattleSave\\Boss Battle Progress.txt")
endfunction

//===========================================================================
function InitTrig_LoadModule takes nothing returns nothing
    set gg_trg_LoadModule = CreateTrigger(  )
    call TriggerRegisterTimerExpireEvent( gg_trg_LoadModule, udg_StartTimer )
    call TriggerAddAction( gg_trg_LoadModule, function Trig_LoadModule_Actions )
endfunction

