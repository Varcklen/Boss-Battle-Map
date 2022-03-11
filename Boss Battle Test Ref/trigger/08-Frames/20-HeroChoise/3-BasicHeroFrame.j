elseif udg_HeroChooseMode == 1 then
	set cyclA = 1
	loop
		exitwhen cyclA > 5
		if GetUnitTypeId( u ) == udg_DB_BasicHeroes[cyclA] then
			call BlzFrameSetTexture( basic1v[cyclA], udg_DB_Basic_HeroIcon[cyclA],0, true)
			set l = true
			set cyclA = cyclAEnd
		endif
		set cyclA = cyclA + 1
	endloop

	if not(l) then
	set cyclA = 1
	loop
		exitwhen cyclA > 5
		if GetUnitTypeId( u ) == udg_DB_BasicHeroes[cyclA+5] then
			call BlzFrameSetTexture( basic2v[cyclA], udg_DB_Basic_HeroIcon[cyclA+5],0, true)
			set l = true
			set cyclA = cyclAEnd
		endif
		set cyclA = cyclA + 1
	endloop
	endif

	if not(l) then
	set cyclA = 1
	loop
		exitwhen cyclA > 5
		if GetUnitTypeId( u ) == udg_DB_BasicHeroes[cyclA+10] then
			call BlzFrameSetTexture( basic3v[cyclA], udg_DB_Basic_HeroIcon[cyclA+10],0, true)
			set l = true
			set cyclA = cyclAEnd
		endif
		set cyclA = cyclA + 1
	endloop
	endif



        elseif udg_HeroChooseMode == 1 then
                set cyclA = 1
                loop
                    exitwhen cyclA > 5
                    if GetUnitTypeId( udg_hero[i] ) == udg_DB_BasicHeroes[cyclA] and GetUnitTypeId( udg_hero[i] ) != 'O00T'  then
                        call BlzFrameSetTexture( basic1v[cyclA], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp",0, true)
                        set k = true
                        set cyclA = cyclAEnd
                    endif
                    set cyclA = cyclA + 1
                endloop

                if not(k) then
                    set cyclA = 1
                    loop
                        exitwhen cyclA > 5
                        if GetUnitTypeId( udg_hero[i] ) == udg_DB_BasicHeroes[cyclA+5] and GetUnitTypeId( udg_hero[i] ) != 'O00T' then
                            call BlzFrameSetTexture( basic2v[cyclA], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp",0, true)
                            set k = true
                            set cyclA = cyclAEnd
                        endif
                        set cyclA = cyclA + 1
                    endloop
                endif

                if not(k) then
                    set cyclA = 1
                    loop
                        exitwhen cyclA > 5
                        if GetUnitTypeId( udg_hero[i] ) == udg_DB_BasicHeroes[cyclA+10] and GetUnitTypeId( udg_hero[i] ) != 'O00T' then
                            call BlzFrameSetTexture( basic3v[cyclA], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp",0, true)
                            set k = true
                            set cyclA = cyclAEnd
                        endif
                        set cyclA = cyclA + 1
                    endloop
                endif





globals
    framehandle basicbut
	framehandle array basictool
	framehandle array basicspell
	framehandle array basic1
	framehandle array basic2
	framehandle array basic3
	framehandle array basic1v
	framehandle array basic2v
	framehandle array basic3v
	framehandle basichard
	framehandle basicavtor
	framehandle array basicspellname
	framehandle array basicspelltool
endglobals

function BasicButton takes nothing returns nothing
	local integer cyclA = 1
	local integer cyclAEnd
	local integer i = GetPlayerId( GetTriggerPlayer() ) + 1
	local boolean l = false
	local string text
	local integer k = 0
	local integer ab = 0
	local integer c = 0

	if GetLocalPlayer() == GetTriggerPlayer() then
        call BlzFrameSetVisible( BlzGetTriggerFrame(),false)
		call BlzFrameSetVisible( BlzGetTriggerFrame(),true)
	endif
	
	if basic1[0] == BlzGetTriggerFrame() then
		set udg_HeroChoose[i] = udg_DB_HeroFrame_Buffer[0]
		set l = true
	endif

	if not(l) then
	set cyclA = 1
	loop
		exitwhen cyclA > 5
		if BlzGetTriggerFrame() == basic1[cyclA] then
			set udg_HeroChoose[i] = udg_DB_BasicHeroes[cyclA]
			set l = true
			set cyclA = 5
			set ab = 1
		endif
		set cyclA = cyclA + 1
	endloop
	endif

	if not(l) then
	set cyclA = 1
	loop
		exitwhen cyclA > 5
		if BlzGetTriggerFrame() == basic2[cyclA] then
			set udg_HeroChoose[i] = udg_DB_BasicHeroes[cyclA+5]
			set l = true
			set cyclA = 5
			set ab = 2
		endif
		set cyclA = cyclA + 1
	endloop
	endif

	if not(l) then
	set cyclA = 1
	loop
		exitwhen cyclA > 5
		if BlzGetTriggerFrame() == basic3[cyclA] then
			set udg_HeroChoose[i] = udg_DB_BasicHeroes[cyclA+10]
			set l = true
			set cyclA = 5
			set ab = 3
		endif
		set cyclA = cyclA + 1
	endloop
	endif

	set cyclA = 1
	set cyclAEnd = udg_Database_InfoNumberHeroes
	loop
		exitwhen cyclA > cyclAEnd
		if udg_Database_Hero[cyclA] == udg_HeroChoose[i] then
			set k = cyclA
			set cyclA = cyclAEnd
		endif
		set cyclA = cyclA + 1
	endloop
	if BlzGetUnitSkin(udg_HeroSpawn[i]) != udg_HeroChoose[i] then
		call RemoveUnit( udg_HeroSpawn[i] )
		if udg_HeroChoose[i] == 'N038' or udg_HeroChoose[i] == 'u002' or udg_HeroChoose[i] == 'N04J' or udg_HeroChoose[i] == 'N054' then
			set udg_HeroSpawn[i] = CreateUnit( Player(PLAYER_NEUTRAL_PASSIVE), udg_HeroChoose[i], GetLocationX(udg_point[25+i]), GetLocationY(udg_point[25+i]), bj_UNIT_FACING )
		else
			set udg_HeroSpawn[i] = CreateUnit( Player(PLAYER_NEUTRAL_PASSIVE), 'u000', GetLocationX(udg_point[25+i]), GetLocationY(udg_point[25+i]), bj_UNIT_FACING )
			call BlzSetUnitSkin( udg_HeroSpawn[i], udg_HeroChoose[i] )
		endif
    		if ab == 1 then
			set c = 13
		elseif ab == 2 then
			set c = 23
		elseif ab == 3 then
			set c = 14
		endif
		call SetUnitColor( udg_HeroSpawn[i], GetPlayerColor(ConvertedPlayer(c) ) )
		call BlzShowUnitTeamGlow( udg_HeroSpawn[i], FALSE ) 
		call QueueUnitAnimationBJ( udg_HeroSpawn[i], "stand" )
		call QueueUnitAnimationBJ( udg_HeroSpawn[i], "attack" )
		call QueueUnitAnimationBJ( udg_HeroSpawn[i], "stand" )
		call SetUnitState( udg_HeroSpawn[i], UNIT_STATE_MANA, GetUnitState( udg_HeroSpawn[i], UNIT_STATE_MAX_MANA) )
		call FogModifierStart( udg_Visible[i] )
	
		call CameraSetupApplyForPlayer( true, udg_CameraChoose[i], Player(i-1), 0 )
        call SetCameraTargetControllerNoZForPlayer( Player(i-1), udg_HeroSpawn[i], 210.00, -150.00, false )

		if ab == 0 then
			if GetLocalPlayer() == GetTriggerPlayer() then
				call BlzFrameSetVisible( basicspell[1], false )
				call BlzFrameSetVisible( basicspell[2], false )
				call BlzFrameSetVisible( basicspell[3], false )
				call BlzFrameSetVisible( basicspell[4], false )

				call BlzFrameSetText( basicavtor, "" )
				call BlzFrameSetText( basichard, "" )
			endif
		else
			if GetLocalPlayer() == GetTriggerPlayer() then
				call BlzFrameSetTexture( basicspell[1], BlzGetAbilityIcon( udg_DB_Hero_FirstSpell[k] ),0, true)
				call BlzFrameSetTexture( basicspell[2], BlzGetAbilityIcon( udg_Database_EarringSpell[k] ),0, true)
				call BlzFrameSetTexture( basicspell[3], BlzGetAbilityIcon( udg_DB_Hero_Passive[k]),0, true)
				call BlzFrameSetTexture( basicspell[4], BlzGetAbilityIcon( udg_DB_Hero_Fourth[k]),0, true)
			
				call BlzFrameSetText(basicspelltool[1], BlzGetAbilityResearchExtendedTooltip(udg_DB_Hero_FirstSpell[k], 0) )
				call BlzFrameSetText(basicspellname[1], BlzGetAbilityResearchTooltip(udg_DB_Hero_FirstSpell[k], 0) )
				call BlzFrameSetSize(basictool[1], 0.35, StringSizeSmall(BlzGetAbilityResearchExtendedTooltip(udg_DB_Hero_FirstSpell[k], 0)) )

				call BlzFrameSetText(basicspelltool[2], BlzGetAbilityResearchExtendedTooltip(udg_Database_EarringSpell[k], 0) )
				call BlzFrameSetText(basicspellname[2], BlzGetAbilityResearchTooltip(udg_Database_EarringSpell[k], 0) )
				call BlzFrameSetSize(basictool[2], 0.35, StringSizeSmall(BlzGetAbilityResearchExtendedTooltip(udg_Database_EarringSpell[k], 0)))

				call BlzFrameSetText(basicspelltool[3], BlzGetAbilityResearchExtendedTooltip(udg_DB_Hero_Passive[k], 0) )
				call BlzFrameSetText(basicspellname[3], BlzGetAbilityResearchTooltip(udg_DB_Hero_Passive[k], 0) )
				call BlzFrameSetSize(basictool[3], 0.35, StringSizeSmall(BlzGetAbilityResearchExtendedTooltip(udg_DB_Hero_Passive[k], 0)))

				call BlzFrameSetText(basicspelltool[4], BlzGetAbilityResearchExtendedTooltip(udg_DB_Hero_Fourth[k], 0) )
				call BlzFrameSetText(basicspellname[4], BlzGetAbilityResearchTooltip(udg_DB_Hero_Fourth[k], 0) )
				call BlzFrameSetSize(basictool[4], 0.35, StringSizeSmall(BlzGetAbilityResearchExtendedTooltip(udg_DB_Hero_Fourth[k], 0)))

				call BlzFrameSetVisible( basicspell[1], true )
				call BlzFrameSetVisible( basicspell[2], true )
				call BlzFrameSetVisible( basicspell[3], true )
				call BlzFrameSetVisible( basicspell[4], true )

				call BlzFrameSetText( basicavtor, udg_DB_Hero_Avtor[k] )
				call BlzFrameSetText( basichard, udg_DB_Hero_Hard[k] )
			endif
		endif
	endif
endfunction

function BasicSLButton takes nothing returns nothing
	local player pl = GetTriggerPlayer()
	local integer i = GetPlayerId( pl ) + 1
	local integer cyclA = 1
	local boolean l = false

	loop
		exitwhen cyclA > 4
		if GetUnitTypeId( udg_hero[cyclA] ) == udg_HeroChoose[i] and udg_HeroChoose[i] != 'O00T' then
			set l = true
		endif
		set cyclA = cyclA + 1
	endloop
	if LoadInteger( udg_hash, i, StringHash( "randpick" ) ) >= 3 and udg_HeroChoose[i] == udg_DB_HeroFrame_Buffer[0] then
		set l = true
		call DisplayTimedTextToPlayer( pl, 0, 0, 10., "Attempts exhausted." )
	endif

	if udg_logic[79] and udg_Host == GetTriggerPlayer() then
		set l = true
	endif

	if udg_HeroChoose[i] != 0 and not(l) then
		call RemoveUnit( udg_HeroSpawn[i] )
		call FogModifierStop( udg_Visible[i] )
		if GetLocalPlayer() == pl then
			call ResetToGameCameraForPlayer( pl, 0 )
			call BlzFrameSetVisible( basicbut, false )
		endif
		if udg_HeroChoose[i] == udg_DB_HeroFrame_Buffer[0] then
			call RandomHero( pl )
		else
			call CreateUnit( pl, udg_HeroChoose[i], GetLocationX(GetRectCenter(gg_rct_HeroesTp)), GetLocationY(GetRectCenter(gg_rct_HeroesTp)), bj_UNIT_FACING )
		endif
		set udg_HeroChoose[i] = 0
	endif

	set pl = null
endfunction

function Trig_BasicHeroFrame_Actions takes nothing returns nothing
	local trigger trig = CreateTrigger()
	local trigger trigclass = CreateTrigger()
	local framehandle basicfon
	local framehandle tool
	local framehandle class
	local framehandle classtool
	local framehandle namefon
	local framehandle newframe
	local framehandle backfon
	local integer cyclA = 1
	local integer cyclAEnd
	local integer cyclB
	local integer cyclBEnd
	local integer rand


	set udg_DB_BasicHeroesNum = 15
	set udg_DB_BasicHeroes[1] = udg_Database_Hero[udg_Database_InfoNumberHeroes]
	set udg_DB_BasicHeroes[2] = udg_Database_Hero[udg_Database_InfoNumberHeroes-1]

	set cyclA = 1
	loop
		exitwhen cyclA > 1
		set rand = GetRandomInt(1,udg_DB_HeroFrame_Number[2])
		set cyclB = 1
		loop
			exitwhen cyclB > 2 
			if udg_DB_BasicHeroes[cyclB] == udg_DB_HeroFrame_Deffender[rand] then
				set cyclB = 2
				set cyclA = cyclA - 1
			endif
			set cyclB = cyclB + 1
		endloop
		set cyclA = cyclA + 1
	endloop
	set udg_DB_BasicHeroes[3] = udg_DB_HeroFrame_Deffender[rand]

	set cyclA = 1
	loop
		exitwhen cyclA > 1
		set rand = GetRandomInt(1,udg_DB_HeroFrame_Number[8])
		set cyclB = 1
		loop
			exitwhen cyclB > 3 
			if udg_DB_BasicHeroes[cyclB] == udg_DB_HeroFrame_Healer[rand] then
				set cyclB = 3
				set cyclA = cyclA - 1
			endif
			set cyclB = cyclB + 1
		endloop
		set cyclA = cyclA + 1
	endloop
	set udg_DB_BasicHeroes[4] = udg_DB_HeroFrame_Healer[rand]

	set cyclA = 1
	loop
		exitwhen cyclA > 1
		set rand = GetRandomInt(1,udg_DB_HeroFrame_Number[6])
		set cyclB = 1
		loop
			exitwhen cyclB > 4 
			if udg_DB_BasicHeroes[cyclB] == udg_DB_HeroFrame_Killer[rand] then
				set cyclB = 4
				set cyclA = cyclA - 1
			endif
			set cyclB = cyclB + 1
		endloop
		set cyclA = cyclA + 1
	endloop
	set udg_DB_BasicHeroes[5] = udg_DB_HeroFrame_Killer[rand]

	set cyclA = 1
	loop
		exitwhen cyclA > 1
		set rand = GetRandomInt(1,udg_DB_HeroFrame_Number[7])
		set cyclB = 1
		loop
			exitwhen cyclB > 5 
			if udg_DB_BasicHeroes[cyclB] == udg_DB_HeroFrame_Elemental[rand] then
				set cyclB = 5
				set cyclA = cyclA - 1
			endif
			set cyclB = cyclB + 1
		endloop
		set cyclA = cyclA + 1
	endloop
	set udg_DB_BasicHeroes[6] = udg_DB_HeroFrame_Elemental[rand]

    set cyclA = 7
    loop
        exitwhen cyclA > 15
        set udg_DB_BasicHeroes[cyclA] = udg_Database_Hero[GetRandomInt(1, udg_Database_InfoNumberHeroes)]
        set cyclB = 1
        set cyclBEnd = cyclA - 1
        loop
            exitwhen cyclB > cyclBEnd
            if udg_DB_BasicHeroes[cyclA] == udg_DB_BasicHeroes[cyclB] then
                set cyclA = cyclA - 1
                set cyclB = cyclBEnd
            endif
            set cyclB = cyclB + 1
        endloop
        set cyclA = cyclA + 1
    endloop

    set basicbut = BlzCreateFrame("ScriptDialogButton", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), 0,0) 
	call BlzFrameSetSize(basicbut, 0.07,0.04)
	call BlzFrameSetAbsPoint(basicbut, FRAMEPOINT_CENTER, 0.18,0.185)
	call BlzFrameSetText(basicbut, "Choose")
	call BlzFrameSetLevel( basicbut, -1 )
    call BlzFrameSetVisible( basicbut, false )

	call BlzTriggerRegisterFrameEvent(trig, basicbut, FRAMEEVENT_CONTROL_CLICK)
	call TriggerAddAction(trig, function BasicSLButton)

	set basicfon = BlzCreateFrame("EscMenuBackdrop", basicbut, 0, 0)
    	call BlzFrameSetAbsPoint(basicfon, FRAMEPOINT_CENTER, 0.398, 0.16)
    	call BlzFrameSetSize(basicfon, 0.3, 0.075)

	set namefon = BlzCreateFrame("QuestButtonBaseTemplate", basicbut, 0, 0)
    	call BlzFrameSetAbsPoint(namefon, FRAMEPOINT_CENTER, 0.398, 0.205)
    	call BlzFrameSetSize(namefon, 0.15, 0.05)
	call BlzFrameSetLevel( namefon, -2 )

	set basichard = BlzCreateFrameByType("TEXT", "", namefon, "StandartFrameTemplate", 0)
	call BlzFrameSetSize( basichard, 0.2, 0.04 )
	call BlzFrameSetPoint( basichard, FRAMEPOINT_TOPLEFT, namefon, FRAMEPOINT_TOPLEFT, 0.01,-0.01) 
	call BlzFrameSetText( basichard, "" )

	set basicavtor = BlzCreateFrameByType("TEXT", "", namefon, "StandartFrameTemplate", 0)
	call BlzFrameSetSize( basicavtor, 0.2, 0.04 )
	call BlzFrameSetPoint( basicavtor, FRAMEPOINT_TOPLEFT, namefon, FRAMEPOINT_TOPLEFT, 0.01,-0.02) 
	call BlzFrameSetText( basicavtor, "" )
	
	set cyclA = 1
	loop
		exitwhen cyclA > 4
		set basicspell[cyclA] = BlzCreateFrameByType("BACKDROP", "", basicbut, "", 0)
		set tool = BlzCreateFrameByType("FRAME", "", basicspell[cyclA],"", 0)
		set basictool[cyclA] = BlzCreateFrame("Spell1Text", basicspell[cyclA], 0, 0)
		set basicspellname[cyclA] = BlzCreateFrameByType("TEXT", "", basictool[cyclA], "StandartFrameTemplate", 0)
		set basicspelltool[cyclA] = BlzCreateFrameByType("TEXT", "", basictool[cyclA], "StandartFrameTemplate", 0)
		 
		call BlzFrameSetPoint( basicspellname[cyclA], FRAMEPOINT_TOPLEFT, basictool[cyclA], FRAMEPOINT_TOPLEFT, 0.005,-0.01) 
		call BlzFrameSetLevel( basicspellname[cyclA], 1 )
		call BlzFrameSetSize(basicspellname[cyclA], 0.3, 0.6)

		call BlzFrameSetPoint( basicspelltool[cyclA], FRAMEPOINT_TOPLEFT, basictool[cyclA], FRAMEPOINT_TOPLEFT, 0.005,-0.025) 
		call BlzFrameSetLevel( basicspelltool[cyclA], 1 )
		call BlzFrameSetSize(basicspelltool[cyclA], 0.3, 0.6)

		call BlzFrameSetAllPoints(tool, basicspell[cyclA])
		call BlzFrameSetTooltip(tool, basictool[cyclA])
	
		call BlzFrameSetSize(basicspell[cyclA], 0.04, 0.04)
		call BlzFrameSetPoint( basicspell[cyclA], FRAMEPOINT_CENTER, basicfon, FRAMEPOINT_CENTER, (0.04*(cyclA-2))-0.02, 0 )
		call BlzFrameSetSize(basictool[cyclA], 0.35, 0.06)
		call BlzFrameSetAbsPoint(basictool[cyclA], FRAMEPOINT_BOTTOM, 0.7, 0.16)

		call BlzFrameSetTexture( basicspell[cyclA], "war3mapImported\\PASfeed-icon-red-1_result.blp",0, true)
		call BlzFrameSetVisible( basicspell[cyclA], false )
		set cyclA = cyclA + 1
	endloop

	call TriggerAddAction(trigclass, function BasicButton)

	set basic1[0] = BlzCreateFrameByType("GLUEBUTTON", "", basicbut, "ScoreScreenTabButtonTemplate", 0)
	call BlzFrameSetAbsPoint(basic1[0], FRAMEPOINT_CENTER, 0.45,0.48)	
	call BlzFrameSetSize(basic1[0], 0.05, 0.05)

	set tool = BlzCreateFrameByType("BACKDROP", "", basic1[0], "StandartFrameTemplate", 0)
	call BlzFrameSetAllPoints(tool,basic1[0] )
    
	call BlzTriggerRegisterFrameEvent(trigclass, basic1[0], FRAMEEVENT_CONTROL_CLICK)
	call BlzFrameSetTexture( tool, "war3mapImported\\PASBTNSelectHeroOn.blp",0, true)

	set cyclA = 1
	set cyclAEnd = udg_DB_HeroFrame_Number[1]
	loop
		exitwhen cyclA > cyclAEnd
		set cyclB = 1
		set cyclBEnd = udg_DB_BasicHeroesNum
		loop
			exitwhen cyclB > cyclBEnd
			if udg_DB_HeroFrame_Buffer[cyclA] == udg_DB_BasicHeroes[cyclB] then
				set udg_DB_Basic_HeroIcon[cyclB] = udg_DB_HeroFrame_Buffer_Icon[cyclA]
			endif
			set cyclB = cyclB + 1
		endloop
		set cyclA = cyclA + 1
	endloop

	set cyclA = 1
	set cyclAEnd = udg_DB_HeroFrame_Number[2]
	loop
		exitwhen cyclA > cyclAEnd
		set cyclB = 1
		set cyclBEnd = udg_DB_BasicHeroesNum
		loop
			exitwhen cyclB > cyclBEnd
			if udg_DB_HeroFrame_Deffender[cyclA] == udg_DB_BasicHeroes[cyclB] then
				set udg_DB_Basic_HeroIcon[cyclB] = udg_DB_HeroFrame_Deffender_Icon[cyclA]
			endif
			set cyclB = cyclB + 1
		endloop
		set cyclA = cyclA + 1
	endloop

	set cyclA = 1
	set cyclAEnd = udg_DB_HeroFrame_Number[3]
	loop
		exitwhen cyclA > cyclAEnd
		set cyclB = 1
		set cyclBEnd = udg_DB_BasicHeroesNum
		loop
			exitwhen cyclB > cyclBEnd
			if udg_DB_HeroFrame_Ripper[cyclA] == udg_DB_BasicHeroes[cyclB] then
				set udg_DB_Basic_HeroIcon[cyclB] = udg_DB_HeroFrame_Ripper_Icon[cyclA]
			endif
			set cyclB = cyclB + 1
		endloop
		set cyclA = cyclA + 1
	endloop

	set cyclA = 1
	set cyclAEnd = udg_DB_HeroFrame_Number[4]
	loop
		exitwhen cyclA > cyclAEnd
		set cyclB = 1
		set cyclBEnd = udg_DB_BasicHeroesNum
		loop
			exitwhen cyclB > cyclBEnd
			if udg_DB_HeroFrame_Hybrid[cyclA] == udg_DB_BasicHeroes[cyclB] then
				set udg_DB_Basic_HeroIcon[cyclB] = udg_DB_HeroFrame_Hybrid_Icon[cyclA]
			endif
			set cyclB = cyclB + 1
		endloop
		set cyclA = cyclA + 1
	endloop

	set cyclA = 1
	set cyclAEnd = udg_DB_HeroFrame_Number[5]
	loop
		exitwhen cyclA > cyclAEnd
		set cyclB = 1
		set cyclBEnd = udg_DB_BasicHeroesNum
		loop
			exitwhen cyclB > cyclBEnd
			if udg_DB_HeroFrame_Maraduer[cyclA] == udg_DB_BasicHeroes[cyclB] then
				set udg_DB_Basic_HeroIcon[cyclB] = udg_DB_HeroFrame_Maraduer_Icon[cyclA]
			endif
			set cyclB = cyclB + 1
		endloop
		set cyclA = cyclA + 1
	endloop
	
	set cyclA = 1
	set cyclAEnd = udg_DB_HeroFrame_Number[6]
	loop
		exitwhen cyclA > cyclAEnd
		set cyclB = 1
		set cyclBEnd = udg_DB_BasicHeroesNum
		loop
			exitwhen cyclB > cyclBEnd
			if udg_DB_HeroFrame_Killer[cyclA] == udg_DB_BasicHeroes[cyclB] then
				set udg_DB_Basic_HeroIcon[cyclB] = udg_DB_HeroFrame_Killer_Icon[cyclA]
			endif
			set cyclB = cyclB + 1
		endloop
		set cyclA = cyclA + 1
	endloop
	
	set cyclA = 1
	set cyclAEnd = udg_DB_HeroFrame_Number[7]
	loop
		exitwhen cyclA > cyclAEnd
		set cyclB = 1
		set cyclBEnd = udg_DB_BasicHeroesNum
		loop
			exitwhen cyclB > cyclBEnd
			if udg_DB_HeroFrame_Elemental[cyclA] == udg_DB_BasicHeroes[cyclB] then
				set udg_DB_Basic_HeroIcon[cyclB] = udg_DB_HeroFrame_Elemental_Icon[cyclA]
			endif
			set cyclB = cyclB + 1
		endloop
		set cyclA = cyclA + 1
	endloop
	
	set cyclA = 1
	set cyclAEnd = udg_DB_HeroFrame_Number[8]
	loop
		exitwhen cyclA > cyclAEnd
		set cyclB = 1
		set cyclBEnd = udg_DB_BasicHeroesNum
		loop
			exitwhen cyclB > cyclBEnd
			if udg_DB_HeroFrame_Healer[cyclA] == udg_DB_BasicHeroes[cyclB] then
				set udg_DB_Basic_HeroIcon[cyclB] = udg_DB_HeroFrame_Healer_Icon[cyclA]
			endif
			set cyclB = cyclB + 1
		endloop
		set cyclA = cyclA + 1
	endloop

	set cyclA = 1
	set cyclAEnd = udg_DB_HeroFrame_Number[9]
	loop
		exitwhen cyclA > cyclAEnd
		set cyclB = 1
		set cyclBEnd = udg_DB_BasicHeroesNum
		loop
			exitwhen cyclB > cyclBEnd
			if udg_DB_HeroFrame_Debuffer[cyclA] == udg_DB_BasicHeroes[cyclB] then
				set udg_DB_Basic_HeroIcon[cyclB] = udg_DB_HeroFrame_Debuffer_Icon[cyclA]
			endif
			set cyclB = cyclB + 1
		endloop
		set cyclA = cyclA + 1
	endloop

	set backfon = BlzCreateFrame("EscMenuBackdrop", basicbut, 0, 0)
    	call BlzFrameSetAbsPoint(backfon, FRAMEPOINT_CENTER, 0.52, 0.38)
    	call BlzFrameSetSize(backfon, 0.3, 0.3)
	call BlzFrameSetLevel( backfon, -1 )

	set cyclA = 1
	loop
		exitwhen cyclA > 5
		set basic1[cyclA] = BlzCreateFrameByType("GLUEBUTTON", "", basicbut, "ScoreScreenTabButtonTemplate", 0)
		call BlzFrameSetAbsPoint(basic1[cyclA], FRAMEPOINT_CENTER, 0.6,0.53-(0.05*cyclA))	
		call BlzFrameSetSize(basic1[cyclA], 0.05, 0.05)

		set basic1v[cyclA] = BlzCreateFrameByType("BACKDROP", "", basic1[cyclA], "StandartFrameTemplate", 0)
		call BlzFrameSetAllPoints(basic1v[cyclA],basic1[cyclA] )
    
		call BlzTriggerRegisterFrameEvent(trigclass, basic1[cyclA], FRAMEEVENT_CONTROL_CLICK)
		call BlzFrameSetTexture( basic1v[cyclA], udg_DB_Basic_HeroIcon[cyclA],0, true)
		set cyclA = cyclA + 1
	endloop

	set cyclA = 1
	loop
		exitwhen cyclA > 5
		set basic2[cyclA] = BlzCreateFrameByType("GLUEBUTTON", "", basicbut, "ScoreScreenTabButtonTemplate", 0)
		call BlzFrameSetAbsPoint(basic2[cyclA], FRAMEPOINT_CENTER, 0.55,0.53-(0.05*cyclA))	
		call BlzFrameSetSize(basic2[cyclA], 0.05, 0.05)

		set basic2v[cyclA] = BlzCreateFrameByType("BACKDROP", "", basic2[cyclA], "StandartFrameTemplate", 0)
		call BlzFrameSetAllPoints(basic2v[cyclA],basic2[cyclA] )
    
		call BlzTriggerRegisterFrameEvent(trigclass, basic2[cyclA], FRAMEEVENT_CONTROL_CLICK)
		call BlzFrameSetTexture( basic2v[cyclA], udg_DB_Basic_HeroIcon[cyclA+5],0, true)
		set cyclA = cyclA + 1
	endloop

	set cyclA = 1
	loop
		exitwhen cyclA > 5
		set basic3[cyclA] = BlzCreateFrameByType("GLUEBUTTON", "", basicbut, "ScoreScreenTabButtonTemplate", 0)
		call BlzFrameSetAbsPoint(basic3[cyclA], FRAMEPOINT_CENTER, 0.5,0.53-(0.05*cyclA))	
		call BlzFrameSetSize(basic3[cyclA], 0.05, 0.05)

		set basic3v[cyclA] = BlzCreateFrameByType("BACKDROP", "", basic3[cyclA], "StandartFrameTemplate", 0)
		call BlzFrameSetAllPoints(basic3v[cyclA],basic3[cyclA] )
    
		call BlzTriggerRegisterFrameEvent(trigclass, basic3[cyclA], FRAMEEVENT_CONTROL_CLICK)
		call BlzFrameSetTexture( basic3v[cyclA], udg_DB_Basic_HeroIcon[cyclA+10],0, true)
		set cyclA = cyclA + 1
	endloop

	//set cyclA = 1
	//loop
	//	exitwhen cyclA > 2
	//	set newframe = BlzCreateFrameByType("BACKDROP", "", basicbut, "", 0)
	//	call BlzFrameSetPoint( newframe, FRAMEPOINT_CENTER, basic1[cyclA], FRAMEPOINT_BOTTOMRIGHT, -0.006,0.006) 	
	//	call BlzFrameSetSize(newframe, 0.025, 0.025)
	//	call BlzFrameSetTexture( newframe, "framenew.blp",0, true)
	//	set cyclA = cyclA + 1
	//endloop

	set trig = null
	set trigclass = null
	set basicfon = null
	set tool = null
	set class = null
	set classtool = null
	set namefon = null
	set newframe = null
	set backfon = null
endfunction

//===========================================================================
function InitTrig_BasicHeroFrame takes nothing returns nothing
    set gg_trg_BasicHeroFrame = CreateTrigger(  )
    call TriggerAddAction( gg_trg_BasicHeroFrame, function Trig_BasicHeroFrame_Actions )
endfunction

