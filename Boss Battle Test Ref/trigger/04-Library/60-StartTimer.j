function Trig_StartTimer_Actions takes nothing returns nothing
    call BlzChangeMinimapTerrainTex("map.blp")
    //call DisplayCineFilterBJ( false )
    call StartTimerBJ( udg_StartTimer, false, 0.01 )
endfunction

//===========================================================================
function InitTrig_StartTimer takes nothing returns nothing
    set gg_trg_StartTimer = CreateTrigger(  )
    call TriggerAddAction( gg_trg_StartTimer, function Trig_StartTimer_Actions )
endfunction

