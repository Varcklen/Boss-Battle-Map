globals
	framehandle unitfon
	framehandle uniticon
	framehandle unitname
	framehandle unittool
endglobals

function Trig_UnitFon_Actions takes nothing returns nothing

    set unitfon = BlzCreateFrame("QuestButtonBaseTemplate", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), 0, 0)
    call BlzFrameSetAbsPoint(unitfon, FRAMEPOINT_TOP, 0.125, 0.55)
    call BlzFrameSetSize(unitfon, 0.25, 0.22)
    call BlzFrameSetLevel( unitfon, -1 )

	set uniticon = BlzCreateFrameByType("BACKDROP", "", unitfon, "StandartFrameTemplate", 0)
	call BlzFrameSetSize( uniticon, 0.04, 0.04 )
	call BlzFrameSetPoint(uniticon, FRAMEPOINT_TOPLEFT, unitfon, FRAMEPOINT_TOPLEFT, 0.01,-0.01)   
	call BlzFrameSetTexture( uniticon, "ReplaceableTextures\\CommandButtons\\BTNPolymorph.blp", 0, true )

	set unitname = BlzCreateFrameByType("TEXT", "", unitfon, "StandartFrameTemplate", 0)
	call BlzFrameSetSize( unitname, 0.2, 0.03 )
	call BlzFrameSetPoint(unitname, FRAMEPOINT_TOP, unitfon, FRAMEPOINT_TOP, 0.04,-0.01) 
	call BlzFrameSetText( unitname, "" )

	set unittool = BlzCreateFrameByType("TEXT", "", unitfon, "StandartFrameTemplate", 0)
	call BlzFrameSetSize( unittool, 0.23, 0.04 )
	call BlzFrameSetPoint(unittool, FRAMEPOINT_TOP, unitfon, FRAMEPOINT_TOP, 0.,-0.06) 
	call BlzFrameSetText( unittool, "" )

	call BlzFrameSetVisible(unitfon, false)
endfunction

//===========================================================================
function InitTrig_UnitFon takes nothing returns nothing
    set gg_trg_UnitFon = CreateTrigger(  )
    call TriggerRegisterTimerExpireEventBJ( gg_trg_UnitFon, udg_StartTimer )
    call TriggerAddAction( gg_trg_UnitFon, function Trig_UnitFon_Actions )
endfunction

