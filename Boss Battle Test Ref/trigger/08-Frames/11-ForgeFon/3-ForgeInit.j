function Trig_ForgeInit_Actions takes nothing returns nothing
	local integer cyclA = 1
	local trigger trig = CreateTrigger()
	local trigger array trigchs

	loop
		exitwhen cyclA > 3
		set bgfrgfon[cyclA] = BlzCreateFrame("QuestButtonBaseTemplate", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), 0, 0)
		call BlzFrameSetAbsPoint(bgfrgfon[cyclA], FRAMEPOINT_CENTER, 0.125+(0.275*(cyclA-1)), 0.4)
		call BlzFrameSetSize(bgfrgfon[cyclA], 0.25, 0.2)
		call BlzFrameSetLevel( bgfrgfon[cyclA], -1 )

		set forgeicon[cyclA] = BlzCreateFrameByType("BACKDROP", "", bgfrgfon[cyclA], "StandartFrameTemplate", 0)
		call BlzFrameSetSize( forgeicon[cyclA], 0.04, 0.04 )
		call BlzFrameSetPoint(forgeicon[cyclA], FRAMEPOINT_TOPLEFT, bgfrgfon[cyclA], FRAMEPOINT_TOPLEFT, 0.01,-0.01)
		call BlzFrameSetTexture( forgeicon[cyclA], "ReplaceableTextures\\CommandButtons\\BTNPolymorph.blp", 0, true )

		set forgename[cyclA] = BlzCreateFrameByType("TEXT", "", bgfrgfon[cyclA], "StandartFrameTemplate", 0)
		call BlzFrameSetSize( forgename[cyclA], 0.2, 0.04 )
		call BlzFrameSetPoint(forgename[cyclA], FRAMEPOINT_TOP, bgfrgfon[cyclA], FRAMEPOINT_TOP, 0.04,-0.01) 
		call BlzFrameSetText( forgename[cyclA], "" )

		set forgetool[cyclA] = BlzCreateFrameByType("TEXT", "", bgfrgfon[cyclA], "StandartFrameTemplate", 0)
		call BlzFrameSetSize( forgetool[cyclA], 0.23, 0.14 )
		call BlzFrameSetPoint(forgetool[cyclA], FRAMEPOINT_TOP, bgfrgfon[cyclA], FRAMEPOINT_TOP, 0,-0.06) 
		call BlzFrameSetText( forgetool[cyclA], "" )

		set forgebutchs[cyclA] = BlzCreateFrame("ScriptDialogButton", bgfrgfon[cyclA], 0,0) 
		call BlzFrameSetSize(forgebutchs[cyclA], 0.06,0.03)
		call BlzFrameSetPoint(forgebutchs[cyclA], FRAMEPOINT_TOP, bgfrgfon[cyclA], FRAMEPOINT_BOTTOM, 0,0.01)
		call BlzFrameSetText(forgebutchs[cyclA], "Choose")

		set trigchs[cyclA] = CreateTrigger()
		call BlzTriggerRegisterFrameEvent(trigchs[cyclA], forgebutchs[cyclA], FRAMEEVENT_CONTROL_CLICK)
		
		call BlzFrameSetVisible(bgfrgfon[cyclA], false)
		set cyclA = cyclA + 1
	endloop

	call TriggerAddAction(trigchs[1], function Button1)
	call TriggerAddAction(trigchs[2], function Button2)
	call TriggerAddAction(trigchs[3], function Button3)

	set forgebut  = BlzCreateFrame("ScriptDialogButton", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI,0), 0,0) 
	call BlzFrameSetSize(forgebut, 0.08,0.03)
	call BlzFrameSetAbsPoint(forgebut, FRAMEPOINT_CENTER, 0.4, 0.22)
	call BlzFrameSetText(forgebut, "Hide")
	call BlzFrameSetVisible(forgebut, false)
	
	call BlzTriggerRegisterFrameEvent(trig, forgebut, FRAMEEVENT_CONTROL_CLICK)
	call TriggerAddAction(trig, function ButtonF)
endfunction

//===========================================================================
function InitTrig_ForgeInit takes nothing returns nothing
    set gg_trg_ForgeInit = CreateTrigger(  )
    call TriggerRegisterTimerExpireEventBJ( gg_trg_ForgeInit, udg_StartTimer )
    call TriggerAddAction( gg_trg_ForgeInit, function Trig_ForgeInit_Actions )
endfunction

