globals
     	framehandle array infrtlp
endglobals

function Trig_InfoFrame_Actions takes nothing returns nothing
	local framehandle faceHover
	local integer cyclA
	local integer cyclAEnd 

    set cyclA = 1
    set cyclAEnd = udg_DB_InfoFrame_Number
	loop
		exitwhen cyclA > cyclAEnd
		set faceHover = BlzCreateFrameByType("FRAME", "", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0),"", 0)
        call BlzFrameSetSize(faceHover, 0.08, 0.02)
        call BlzFrameSetAbsPoint(faceHover, FRAMEPOINT_LEFT, 0.375+(cyclA*0.088), 0.588)
        
        call SetStableTool( faceHover, udg_DB_InfoFrame_Name[cyclA], udg_DB_InfoFrame_Tooltip[cyclA] )
		set cyclA = cyclA + 1
	endloop

	set faceHover = null
endfunction

//===========================================================================
function InitTrig_InfoFrame takes nothing returns nothing
    set gg_trg_InfoFrame = CreateTrigger(  )
    call TriggerRegisterTimerEventSingle( gg_trg_InfoFrame, 0.10 )
    call TriggerAddAction( gg_trg_InfoFrame, function Trig_InfoFrame_Actions )
endfunction

