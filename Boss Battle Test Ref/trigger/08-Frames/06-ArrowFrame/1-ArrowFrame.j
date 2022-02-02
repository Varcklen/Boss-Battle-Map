globals
    framehandle arrowframe
endglobals

function ArrowFrame takes nothing returns nothing
		set arrowframe = BlzCreateFrameByType("BACKDROP", "", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), "StandartFrameTemplate", 0)
        call BlzFrameSetAbsPoint(arrowframe, FRAMEPOINT_CENTER, 0.4, 0.2)	
		call BlzFrameSetSize(arrowframe, 0.025, 0.025)
        call BlzFrameSetTexture(arrowframe, "FrameArrow.blp", 0, true)
		call BlzFrameSetVisible( arrowframe, false )
endfunction

//===========================================================================
function InitTrig_ArrowFrame takes nothing returns nothing
    set gg_trg_ArrowFrame = CreateTrigger(  )
    call TriggerRegisterTimerExpireEvent( gg_trg_ArrowFrame, udg_StartTimer )
    call TriggerAddAction( gg_trg_ArrowFrame, function ArrowFrame )
endfunction

