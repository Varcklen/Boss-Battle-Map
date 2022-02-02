globals
    framehandle fastvis
	framehandle array fasticon
    framehandle array fastbutv
    framehandle array fastback
    framehandle array fastname
    framehandle array fastdisc
	framehandle array fasttool
	framehandle array chbut
	framehandle fastbut
endglobals

function ButtonChoose takes nothing returns nothing
	local integer i = GetPlayerId( GetTriggerPlayer() ) + 1
	local integer cyclA = 1
	local integer k

	if GetLocalPlayer() == GetTriggerPlayer() then
		call BlzFrameSetVisible(fastvis, false)
		call BlzFrameSetVisible(fastbut, false)
		call BlzFrameSetVisible( BlzGetTriggerFrame(),false)
		call BlzFrameSetVisible( BlzGetTriggerFrame(),true)
	endif

	loop
		exitwhen cyclA > 3
		if BlzGetTriggerFrame() == chbut[cyclA] then
			set k = cyclA
			set cyclA = 3
		endif
		set cyclA = cyclA + 1
	endloop

	set cyclA = 1
    	loop
        	exitwhen cyclA > 6
            	call RemoveItem( UnitItemInSlot( udg_hero[i], cyclA-1 ) )
            	call UnitAddItem( udg_hero[i], CreateItem( udg_DB_FS_Item[udg_DB_FS_SetItem[(18*(i-1))+(6*(k-1))+cyclA]], GetUnitX(udg_hero[i]), GetUnitY(udg_hero[i]) ) )
        	set cyclA = cyclA + 1
    	endloop
    
    	call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\Polymorph\\PolyMorphDoneGround.mdl", GetUnitX( udg_hero[i] ), GetUnitY( udg_hero[i] ) ) )
endfunction

function Button takes nothing returns nothing
	if GetLocalPlayer() == GetTriggerPlayer() then
		call BlzFrameSetVisible( BlzGetTriggerFrame(),false)
		call BlzFrameSetVisible( BlzGetTriggerFrame(),true)
		if BlzFrameIsVisible( fasticon[1] ) then
			call BlzFrameSetText(fastbut, "Show")
			call BlzFrameSetVisible(fastvis, false)
		else
			call BlzFrameSetText(fastbut, "Hide")
			call BlzFrameSetVisible(fastvis, true)
		
		endif
	endif
endfunction

function Trig_FastStartFrame_Actions takes nothing returns nothing
	local integer cyclA = 1
	local integer cyclB
	local trigger trig = CreateTrigger()
	local trigger trigchs = CreateTrigger()
	local framehandle fon
	local integer i = 0

    set fastbut = BlzCreateFrame("ScriptDialogButton", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI,0), 0,0) 

	call BlzFrameSetSize(fastbut, 0.08,0.03)
	call BlzFrameSetAbsPoint(fastbut, FRAMEPOINT_CENTER, 0.4, 0.22)
	call BlzFrameSetText(fastbut, "Hide")
	
	call BlzTriggerRegisterFrameEvent(trig, fastbut, FRAMEEVENT_CONTROL_CLICK)
	call TriggerAddAction(trig, function Button)
	
	set fastvis = BlzCreateFrameByType("BACKDROP", "", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI,0), "StandartFrameTemplate", 0)
	call TriggerAddAction(trigchs, function ButtonChoose)
	loop
		exitwhen cyclA > 3
        set fon = BlzCreateFrame("QuestButtonBaseTemplate", fastvis, 0, 0)
        call BlzFrameSetAbsPoint(fon, FRAMEPOINT_CENTER, 0.2+(0.2*(cyclA-1)), 0.4)
        call BlzFrameSetSize(fon, 0.14, 0.12)
        call BlzFrameSetLevel( fon, -1 )
    
        set cyclB = 1
        loop
            exitwhen cyclB > 6
            set i = i + 1
            set fasticon[i] = BlzCreateFrameByType("BACKDROP", "", fastvis, "StandartFrameTemplate", 0)
            call BlzFrameSetSize( fasticon[i], 0.04, 0.04 )
            if cyclB >= 4 then
                call BlzFrameSetPoint(fasticon[i], FRAMEPOINT_TOPLEFT, fon, FRAMEPOINT_TOPLEFT, 0.01+(0.04*(cyclB-4)),-0.01)  
            else
                call BlzFrameSetPoint(fasticon[i], FRAMEPOINT_TOPLEFT, fon, FRAMEPOINT_TOPLEFT, 0.01+(0.04*(cyclB-1)),-0.05)  
            endif
            
            set fastbutv[i] = BlzCreateFrameByType("BUTTON", "", fastvis, "StandartFrameTemplate", 0)
            call BlzFrameSetSize( fastbutv[i], 0.04, 0.04 )
            call BlzFrameSetPoint(fastbutv[i], FRAMEPOINT_CENTER, fasticon[i], FRAMEPOINT_CENTER, 0.0,0.0)
            
            set fastback[i] = BlzCreateFrame( "QuestButtonDisabledBackdropTemplate", fastvis, 0, 0 )
            call BlzFrameSetAbsPoint(fastback[i], FRAMEPOINT_BOTTOM, 0.7, 0.16)
            call BlzFrameSetTooltip( fastbutv[i], fastback[i] )

            set fastdisc[i] = BlzCreateFrameByType("TEXT", "",  fastback[i], "StandartFrameTemplate", 0)
            call BlzFrameSetPoint( fastdisc[i], FRAMEPOINT_TOPLEFT, fastback[i], FRAMEPOINT_TOPLEFT, 0.007,-0.03) 
            call BlzFrameSetSize(fastdisc[i], 0.28, 0.1)

            set fastname[i] = BlzCreateFrameByType("TEXT", "",  fastback[i], "StandartFrameTemplate", 0)
            call BlzFrameSetPoint( fastname[i], FRAMEPOINT_TOPLEFT, fastback[i], FRAMEPOINT_TOPLEFT, 0.007,-0.01) 
            call BlzFrameSetSize(fastname[i], 0.28, 0.1)
            set cyclB = cyclB + 1
        endloop

		set fasttool[cyclA] = BlzCreateFrameByType("TEXT", "", fastvis, "StandartFrameTemplate", 0)
		call BlzFrameSetPoint(fasttool[cyclA], FRAMEPOINT_CENTER, fon, FRAMEPOINT_BOTTOM, 0,0.02) 
		call BlzFrameSetText( fasttool[cyclA], "" )

		set chbut[cyclA] = BlzCreateFrame("ScriptDialogButton", fon, 0,0) 
		call BlzFrameSetSize(chbut[cyclA], 0.08,0.03)
		call BlzFrameSetPoint(chbut[cyclA], FRAMEPOINT_CENTER, fon, FRAMEPOINT_BOTTOM, 0,0) 
		call BlzFrameSetText(chbut[cyclA], "Choose")

		call BlzTriggerRegisterFrameEvent(trigchs, chbut[cyclA], FRAMEEVENT_CONTROL_CLICK)

		set cyclA = cyclA + 1
	endloop
	call BlzFrameSetVisible( fastbut,false)
	call BlzFrameSetVisible( fastvis,false)

	set fon = null
	set trig = null
	set trigchs = null
endfunction

//===========================================================================
function InitTrig_FastStartFrame takes nothing returns nothing
    set gg_trg_FastStartFrame = CreateTrigger(  )
    call TriggerRegisterTimerExpireEvent( gg_trg_FastStartFrame, udg_StartTimer )
    call TriggerAddAction( gg_trg_FastStartFrame, function Trig_FastStartFrame_Actions )
endfunction

