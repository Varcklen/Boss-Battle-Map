globals
	framehandle itemfon
	framehandle itemicon
	framehandle itemname
	framehandle itemtool
endglobals

function Trig_ItemFon_Actions takes nothing returns nothing

    set itemfon = BlzCreateFrame("QuestButtonBaseTemplate", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), 0, 0)
    call BlzFrameSetAbsPoint(itemfon, FRAMEPOINT_TOP, 0.125, 0.55)
    call BlzFrameSetSize(itemfon, 0.25, 0.22)
	call BlzFrameSetLevel( itemfon, -1 )

	set itemicon = BlzCreateFrameByType("BACKDROP", "", itemfon, "StandartFrameTemplate", 0)
	call BlzFrameSetSize( itemicon, 0.04, 0.04 )
	call BlzFrameSetPoint(itemicon, FRAMEPOINT_TOPLEFT, itemfon, FRAMEPOINT_TOPLEFT, 0.01,-0.01)   
	call BlzFrameSetTexture( itemicon, "ReplaceableTextures\\CommandButtons\\BTNPolymorph.blp", 0, true )

	set itemname = BlzCreateFrameByType("TEXT", "", itemfon, "StandartFrameTemplate", 0)
	call BlzFrameSetSize( itemname, 0.2, 0.04 )
	call BlzFrameSetPoint(itemname, FRAMEPOINT_TOP, itemfon, FRAMEPOINT_TOP, 0.04,-0.01) 
	call BlzFrameSetText( itemname, "" )

	set itemtool = BlzCreateFrameByType("TEXT", "", itemfon, "StandartFrameTemplate", 0)
	call BlzFrameSetSize( itemtool, 0.23, 0.14 )
	call BlzFrameSetPoint(itemtool, FRAMEPOINT_TOP, itemfon, FRAMEPOINT_TOP, 0.,-0.06) 
	call BlzFrameSetText( itemtool, "" )

	call BlzFrameSetVisible(itemfon, false)
endfunction

//===========================================================================
function InitTrig_ItemFon takes nothing returns nothing
    set gg_trg_ItemFon = CreateTrigger(  )
    call TriggerRegisterTimerExpireEventBJ( gg_trg_ItemFon, udg_StartTimer )
    call TriggerAddAction( gg_trg_ItemFon, function Trig_ItemFon_Actions )
endfunction

