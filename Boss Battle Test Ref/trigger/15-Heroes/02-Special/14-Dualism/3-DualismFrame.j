globals
    framehandle dualtext
endglobals

function Trig_DualismFrame_Actions takes nothing returns nothing
    set dualtext = BlzCreateFrameByType("TEXT", "", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), "StandartFrameTemplate", 0)
    call BlzFrameSetSize( dualtext, 0.01, 0.01 )
    call BlzFrameSetAbsPoint(dualtext, FRAMEPOINT_CENTER, 0.74, 0.057)
    call BlzFrameSetText( dualtext, "0" )
    call BlzFrameSetVisible( dualtext, false )
endfunction

//===========================================================================
function InitTrig_DualismFrame takes nothing returns nothing
    set gg_trg_DualismFrame = CreateTrigger(  )
    call TriggerRegisterTimerExpireEvent( gg_trg_DualismFrame, udg_StartTimer )
    call TriggerAddAction( gg_trg_DualismFrame, function Trig_DualismFrame_Actions )
endfunction

