globals
    framehandle entQText
    framehandle entQBackdrop
endglobals

function Trig_Corrupted_EntQFrame_Actions takes nothing returns nothing
    set entQBackdrop = BlzCreateFrameByType("BACKDROP", "", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), "StandartFrameTemplate", 0)
    call BlzFrameSetSize( entQBackdrop, 0.012, 0.012 )
    call BlzFrameSetAbsPoint(entQBackdrop, FRAMEPOINT_CENTER, 0.65, 0.017)
    call BlzFrameSetTexture( entQBackdrop, "war3mapImported\\BTNfeed-icon-red-1_result.blp",0, true)
    call BlzFrameSetVisible( entQBackdrop, false )

    set entQText = BlzCreateFrameByType("TEXT", "", entQBackdrop, "StandartFrameTemplate", 0)
    call BlzFrameSetSize( entQText, 0.005, 0.01 )
    call BlzFrameSetAbsPoint(entQText, FRAMEPOINT_CENTER, 0.651, 0.017)
    call BlzFrameSetText( entQText, "0" )
endfunction

//===========================================================================
function InitTrig_Corrupted_EntQFrame takes nothing returns nothing
    set gg_trg_Corrupted_EntQFrame = CreateTrigger(  )
    call TriggerRegisterTimerExpireEvent( gg_trg_Corrupted_EntQFrame, udg_StartTimer )
    call TriggerAddAction( gg_trg_Corrupted_EntQFrame, function Trig_Corrupted_EntQFrame_Actions )
endfunction

