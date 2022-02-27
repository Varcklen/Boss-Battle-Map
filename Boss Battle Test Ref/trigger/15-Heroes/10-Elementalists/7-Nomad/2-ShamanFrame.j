globals
     	framehandle shamanframe
     	framehandle array spfframe
endglobals

function ShamanFrame takes nothing returns nothing
	local integer cyclA = 1

		set shamanframe = BlzCreateFrameByType("BACKDROP", "", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), "StandartFrameTemplate", 0)
    		call BlzFrameSetAbsPoint(shamanframe, FRAMEPOINT_LEFT, 0, 0.19)	
		call BlzFrameSetSize(shamanframe, 0.24, 0.12)
    		call BlzFrameSetTexture(shamanframe, "frame light.blp", 0, true)
		call BlzFrameSetLevel( shamanframe, -1 )
    		call BlzFrameSetVisible( shamanframe, false )

	loop
		exitwhen cyclA > 3
		set spfframe[cyclA] = BlzCreateFrameByType("BACKDROP", "", shamanframe, "StandartFrameTemplate", 0)
    		call BlzFrameSetAbsPoint(spfframe[cyclA], FRAMEPOINT_CENTER, (0.065*cyclA)-0.02, 0.20)	
            call BlzFrameSetSize(spfframe[cyclA], 0.1, 0.1)
    		call BlzFrameSetTexture(spfframe[cyclA], "framesphere.blp", 0, true)
		set cyclA = cyclA + 1
	endloop
endfunction

//===========================================================================
function InitTrig_ShamanFrame takes nothing returns nothing
    set gg_trg_ShamanFrame = CreateTrigger(  )
    call TriggerRegisterTimerExpireEvent( gg_trg_ShamanFrame, udg_StartTimer )
    call TriggerAddAction( gg_trg_ShamanFrame, function ShamanFrame )
endfunction

