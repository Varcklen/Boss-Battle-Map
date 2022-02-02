globals
     	framehandle outcastframe
     	framehandle array outballframe
endglobals

function OutcastFrame takes nothing returns nothing
	local integer cyclA = 1

    set outcastframe = BlzCreateFrameByType("BACKDROP", "", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), "StandartFrameTemplate", 0)
    call BlzFrameSetAbsPoint(outcastframe, FRAMEPOINT_LEFT, 0, 0.19)	
    call BlzFrameSetSize(outcastframe, 0.24, 0.12)
    call BlzFrameSetTexture(outcastframe, "outcastframe.blp", 0, true)
    call BlzFrameSetLevel( outcastframe, -1 )
    call BlzFrameSetVisible( outcastframe, false )

	loop
		exitwhen cyclA > 3
		set outballframe[cyclA] = BlzCreateFrameByType("BACKDROP", "", outcastframe, "StandartFrameTemplate", 0)
    		call BlzFrameSetAbsPoint(outballframe[cyclA], FRAMEPOINT_CENTER, (0.06*cyclA)-0.008, 0.20)	
		call BlzFrameSetSize(outballframe[cyclA], 0.07, 0.07)
    		call BlzFrameSetVisible( outballframe[cyclA], false )
		set cyclA = cyclA + 1
	endloop

    call BlzFrameSetTexture(outballframe[1], "ballred.blp", 0, true)
    call BlzFrameSetTexture(outballframe[2], "ballgreen.blp", 0, true)
    call BlzFrameSetTexture(outballframe[3], "ballblue.blp", 0, true)
endfunction

//===========================================================================
function InitTrig_OutcastFrame takes nothing returns nothing
    set gg_trg_OutcastFrame = CreateTrigger(  )
    call TriggerRegisterTimerExpireEvent( gg_trg_OutcastFrame, udg_StartTimer )
    call TriggerAddAction( gg_trg_OutcastFrame, function OutcastFrame )
endfunction

