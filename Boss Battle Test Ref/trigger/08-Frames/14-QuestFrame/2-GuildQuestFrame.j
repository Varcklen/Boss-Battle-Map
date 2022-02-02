globals
    framehandle gqfone
    framehandle gqicon
    framehandle gqname
endglobals

function Trig_GuildQuestFrame_Actions takes nothing returns nothing
    set gqfone = BlzCreateFrame("QuestButtonBaseTemplate", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), 0, 0)
    call BlzFrameSetSize(gqfone, 0.1,0.035)
	call BlzFrameSetAbsPoint(gqfone, FRAMEPOINT_CENTER, 0.54, 0.156)
    call BlzFrameSetVisible( gqfone, false )
    
	set gqicon = BlzCreateFrameByType("BACKDROP", "", gqfone, "", 0)
    call BlzFrameSetPoint(gqicon, FRAMEPOINT_TOPLEFT, gqfone, FRAMEPOINT_TOPLEFT, 0.01, -0.01) 	
	call BlzFrameSetSize(gqicon, 0.018, 0.018)
    
    set gqname = BlzCreateFrameByType("TEXT", "", gqfone, "StandartFrameTemplate", 0)
	call BlzFrameSetSize( gqname, 0.06, 0.02 )
	call BlzFrameSetPoint(gqname, FRAMEPOINT_CENTER, gqfone, FRAMEPOINT_CENTER, 0.02,-0.005) 
	call BlzFrameSetText( gqname, "0/1000" )
endfunction

//===========================================================================
function InitTrig_GuildQuestFrame takes nothing returns nothing
    set gg_trg_GuildQuestFrame = CreateTrigger(  )
    call TriggerRegisterTimerExpireEventBJ( gg_trg_GuildQuestFrame, udg_StartTimer )
    call TriggerAddAction( gg_trg_GuildQuestFrame, function Trig_GuildQuestFrame_Actions )
endfunction

