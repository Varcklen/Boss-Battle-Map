function Trig_ForgeSpecInit_Actions takes nothing returns nothing
    local integer cyclA = 1
	local trigger trig = CreateTrigger()
    local trigger trig1 = CreateTrigger()
	local trigger array trigchs

	loop
		exitwhen cyclA > 3
		set bgfrgfons[cyclA] = BlzCreateFrame("QuestButtonBaseTemplate", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), 0, 0)
		call BlzFrameSetAbsPoint(bgfrgfons[cyclA], FRAMEPOINT_TOP, 0.125+(0.275*(cyclA-1)), 0.45)
		call BlzFrameSetSize(bgfrgfons[cyclA], 0.25, 0.2)
		call BlzFrameSetLevel( bgfrgfons[cyclA], -1 )

		set forgeicons[cyclA] = BlzCreateFrameByType("BACKDROP", "", bgfrgfons[cyclA], "StandartFrameTemplate", 0)
		call BlzFrameSetSize( forgeicons[cyclA], 0.04, 0.04 )
		call BlzFrameSetPoint(forgeicons[cyclA], FRAMEPOINT_TOPLEFT, bgfrgfons[cyclA], FRAMEPOINT_TOPLEFT, 0.01,-0.01)
		call BlzFrameSetTexture( forgeicons[cyclA], "ReplaceableTextures\\CommandButtons\\BTNPolymorph.blp", 0, true )

		set forgenames[cyclA] = BlzCreateFrameByType("TEXT", "", bgfrgfons[cyclA], "StandartFrameTemplate", 0)
		call BlzFrameSetSize( forgenames[cyclA], 0.2, 0.04 )
		call BlzFrameSetPoint(forgenames[cyclA], FRAMEPOINT_TOP, bgfrgfons[cyclA], FRAMEPOINT_TOP, 0.04,-0.01) 
		call BlzFrameSetText( forgenames[cyclA], "" )

		set forgetools[cyclA] = BlzCreateFrameByType("TEXT", "", bgfrgfons[cyclA], "StandartFrameTemplate", 0)
		call BlzFrameSetSize( forgetools[cyclA], 0.23, 0.14 )
		call BlzFrameSetPoint(forgetools[cyclA], FRAMEPOINT_TOP, bgfrgfons[cyclA], FRAMEPOINT_TOP, 0,-0.06) 
		call BlzFrameSetText( forgetools[cyclA], "" )

		set forgebutschss[cyclA] = BlzCreateFrame("ScriptDialogButton", bgfrgfons[cyclA], 0,0) 
		call BlzFrameSetSize(forgebutschss[cyclA], 0.06,0.03)
		call BlzFrameSetPoint(forgebutschss[cyclA], FRAMEPOINT_TOP, bgfrgfons[cyclA], FRAMEPOINT_BOTTOM, 0,0.01)
		call BlzFrameSetText(forgebutschss[cyclA], "Choose")

		set trigchs[cyclA] = CreateTrigger()
		call BlzTriggerRegisterFrameEvent(trigchs[cyclA], forgebutschss[cyclA], FRAMEEVENT_CONTROL_CLICK)
		
		call BlzFrameSetVisible(bgfrgfons[cyclA], false)
        
        set forgealticons[cyclA] = BlzCreateFrameByType("BACKDROP", "", bgfrgfons[cyclA], "StandartFrameTemplate", 0)
		call BlzFrameSetSize( forgealticons[cyclA], 0.02, 0.02 )
		call BlzFrameSetPoint(forgealticons[cyclA], FRAMEPOINT_TOPRIGHT, bgfrgfons[cyclA], FRAMEPOINT_TOPRIGHT, -0.01,-0.025)
		call BlzFrameSetTexture( forgealticons[cyclA], "ReplaceableTextures\\CommandButtons\\BTNPolymorph.blp", 0, true )
        
        set forgealtnames[cyclA] = BlzCreateFrameByType("TEXT", "", forgealticons[cyclA], "StandartFrameTemplate", 0)
		call BlzFrameSetSize( forgealtnames[cyclA], 0.06, 0.04 )
		call BlzFrameSetPoint(forgealtnames[cyclA], FRAMEPOINT_TOPRIGHT, bgfrgfons[cyclA], FRAMEPOINT_TOPRIGHT, -0.035,-0.03) 
		call BlzFrameSetText( forgealtnames[cyclA], "|cffff6666[REPLACES]|r" )
        
        call BlzFrameSetVisible(forgealticons[cyclA], false)
		set cyclA = cyclA + 1
	endloop

	call TriggerAddAction(trigchs[1], function Button1S)
	call TriggerAddAction(trigchs[2], function Button2S)
	call TriggerAddAction(trigchs[3], function Button3S)

	set forgebuts = BlzCreateFrame("ScriptDialogButton", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI,0), 0,0) 
	call BlzFrameSetSize(forgebuts, 0.08,0.03)
	call BlzFrameSetAbsPoint(forgebuts, FRAMEPOINT_CENTER, 0.4, 0.22)
	call BlzFrameSetText(forgebuts, "Hide")
	call BlzFrameSetVisible(forgebuts, false)
	
	call BlzTriggerRegisterFrameEvent(trig, forgebuts, FRAMEEVENT_CONTROL_CLICK)
	call TriggerAddAction(trig, function ButtonFSpell)
    
    set trig = null
    set trig1 = null
endfunction

//===========================================================================
function InitTrig_ForgeSpecInit takes nothing returns nothing
    set gg_trg_ForgeSpecInit = CreateTrigger(  )
    call TriggerRegisterTimerExpireEventBJ( gg_trg_ForgeSpecInit, udg_StartTimer )
    call TriggerAddAction( gg_trg_ForgeSpecInit, function Trig_ForgeSpecInit_Actions )
endfunction

