globals
	framehandle modesbut
    framehandle modesback
    framehandle modesdificon
    framehandle modesdiftool
    framehandle array modesextraicon
    framehandle array modesextrabut
    framehandle array modesmodeicon[4][3]
    framehandle array modesmodebut[4][3]
    framehandle array modesroticon[4][3]
    framehandle array modesrotebut[4][3]
    framehandle array modesDescription[4][3]
    framehandle modebase
    framehandle rotbase
    framehandle modeshostname
    framehandle modeslight
    integer modeslightnum = 100
    integer modeslightmove = -6
    boolean modeslightbool = false
endglobals

function ButtonModes takes nothing returns nothing
    if udg_Host == GetTriggerPlayer() then
        set modeslightbool = true
    endif
    if GetLocalPlayer() == GetTriggerPlayer() then
        call BlzFrameSetVisible( BlzGetTriggerFrame(),false)
		call BlzFrameSetVisible( BlzGetTriggerFrame(),true)
		if BlzFrameIsVisible( modesback ) then
			call BlzFrameSetVisible(modesback, false)
		else
			call BlzFrameSetVisible(modesback, true)
		endif
	endif
endfunction

function DifficultyEnd takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local string str = LoadStr( udg_hash, id, StringHash( "diff" ) )
    
    if not(udg_fightmod[0] ) then
        call DisplayTimedTextToForce( bj_FORCE_ALL_PLAYERS, 5, "Amplifier |cffffcc00\"" + str + "\"|r is activated." )
    endif
    call FlushChildHashtable( udg_hash, id )
endfunction

function DifficultyMore takes nothing returns nothing
    local integer i = udg_HardNum + 1
    local integer id
    if GetLocalPlayer() == GetTriggerPlayer() then
        call BlzFrameSetVisible( BlzGetTriggerFrame(),false)
		call BlzFrameSetVisible( BlzGetTriggerFrame(),true)
	endif
    
    if udg_Host == GetTriggerPlayer() then
        if i > 9 then
            set i = 9
        endif
        
        if i != udg_HardNum then
            set udg_HardNum = i
            set udg_Hardest = udg_DB_Hardest[i]
            call MultiSetValue( udg_multi, 3, 2, udg_Hardest )
            
            call BlzFrameSetTexture( modesdificon, BlzGetAbilityIcon( udg_DB_ModesFrame_Difficulty[i]), 0, true )
            call BlzFrameSetText( modesdiftool, BlzGetAbilityExtendedTooltip(udg_DB_ModesFrame_Difficulty[i], 0) )
            
            if udg_Heroes_Amount > 1 then
                set id = GetHandleId( GetTriggerPlayer() )
                if LoadTimerHandle( udg_hash, id, StringHash( "diff" ) ) == null  then
                    call SaveTimerHandle( udg_hash, id, StringHash( "diff" ), CreateTimer() )
                endif
                set id = GetHandleId( LoadTimerHandle(udg_hash, id, StringHash( "diff" ) ) )
                call SaveStr( udg_hash, id, StringHash( "diff" ), udg_Hardest )
                call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetTriggerPlayer() ), StringHash( "diff" ) ), 2, false, function DifficultyEnd )
            endif
        endif
    endif
endfunction

function DifficultyLess takes nothing returns nothing
    local integer i = udg_HardNum - 1
    local integer id

    if GetLocalPlayer() == GetTriggerPlayer() then
        call BlzFrameSetVisible( BlzGetTriggerFrame(),false)
		call BlzFrameSetVisible( BlzGetTriggerFrame(),true)
	endif
    
    if udg_Host == GetTriggerPlayer() then
        if i < 0 then
            set i = 0
        endif

        if i != udg_HardNum then
            set udg_HardNum = i
            set udg_Hardest = udg_DB_Hardest[i]
            call MultiSetValue( udg_multi, 3, 2, udg_Hardest )
            
            call BlzFrameSetTexture( modesdificon, BlzGetAbilityIcon( udg_DB_ModesFrame_Difficulty[i]), 0, true )
            call BlzFrameSetText( modesdiftool, BlzGetAbilityExtendedTooltip(udg_DB_ModesFrame_Difficulty[i], 0) )
            
            if udg_Heroes_Amount > 1 then
                set id = GetHandleId( GetTriggerPlayer() )
                if LoadTimerHandle( udg_hash, id, StringHash( "diff" ) ) == null  then
                    call SaveTimerHandle( udg_hash, id, StringHash( "diff" ), CreateTimer() )
                endif
                set id = GetHandleId( LoadTimerHandle(udg_hash, id, StringHash( "diff" ) ) )
                call SaveStr( udg_hash, id, StringHash( "diff" ), udg_Hardest )
                call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetTriggerPlayer() ), StringHash( "diff" ) ), 2, false, function DifficultyEnd )
            endif
        endif
    endif
endfunction

function ExtraModeUse takes nothing returns nothing
    local player p = GetTriggerPlayer()
    
    if GetLocalPlayer() == p then
        call BlzFrameSetVisible( BlzGetTriggerFrame(),false)
		call BlzFrameSetVisible( BlzGetTriggerFrame(),true)
	endif
    
    if udg_Host == p then
        if modesextrabut[1] == BlzGetTriggerFrame() then
            if not(udg_logic[100]) then
                set udg_logic[100] = true
                call DisplayTimedTextToForce( bj_FORCE_ALL_PLAYERS, 5.00, "|cffffcc00'Hardcore'|r activated." )
                call BlzFrameSetTexture( modesextraicon[1], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp", 0, true )
            else
                set udg_logic[100] = false
                call DisplayTimedTextToForce( bj_FORCE_ALL_PLAYERS, 5.00, "|cffffcc00'Hardcore'|r disabled." )
                call BlzFrameSetTexture( modesextraicon[1], BlzGetAbilityIcon( udg_DB_ModesFrame_Ability[1]), 0, true )
            endif
        elseif modesextrabut[2] == BlzGetTriggerFrame() then
            if not(udg_logic[77]) then
                set udg_logic[77] = true
                call DisplayTimedTextToForce( bj_FORCE_ALL_PLAYERS, 5.00, "|cffffcc00'On a new one!'|r activated." )
                call BlzFrameSetTexture( modesextraicon[2], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp", 0, true )
            else
                set udg_logic[77] = false
                call DisplayTimedTextToForce( bj_FORCE_ALL_PLAYERS, 5.00, "|cffffcc00'On a new one!'|r disabled." )
                call BlzFrameSetTexture( modesextraicon[2], BlzGetAbilityIcon( udg_DB_ModesFrame_Ability[2]), 0, true )
            endif
        elseif modesextrabut[3] == BlzGetTriggerFrame() then
            if not(udg_logic[78]) then
                set udg_logic[78] = true
                call DisplayTimedTextToForce( bj_FORCE_ALL_PLAYERS, 5.00, "|cffffcc00'Double trouble'|r activated." )
                call BlzFrameSetTexture( modesextraicon[3], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp", 0, true )
            else
                set udg_logic[78] = false
                call DisplayTimedTextToForce( bj_FORCE_ALL_PLAYERS, 5.00, "|cffffcc00'Double trouble'|r disabled." )
                call BlzFrameSetTexture( modesextraicon[3], BlzGetAbilityIcon( udg_DB_ModesFrame_Ability[3]), 0, true )
            endif
        elseif modesextrabut[4] == BlzGetTriggerFrame() then
            if not(udg_logic[6]) then
                set udg_logic[6] = true
                call DisplayTimedTextToForce( bj_FORCE_ALL_PLAYERS, 5.00, "|cffffcc00'Power up!'|r activated." )
                call BlzFrameSetTexture( modesextraicon[4], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp", 0, true )
            else
                set udg_logic[6] = false
                call DisplayTimedTextToForce( bj_FORCE_ALL_PLAYERS, 5.00, "|cffffcc00'Power up!'|r disabled." )
                call BlzFrameSetTexture( modesextraicon[4], BlzGetAbilityIcon( udg_DB_ModesFrame_Ability[4]), 0, true )
            endif
        elseif modesextrabut[5] == BlzGetTriggerFrame() then
            if GetOwningPlayer(gg_unit_h00A_0034) != Player(0) then
                call SetUnitOwner( gg_unit_h00A_0034, Player(0), true )
                call UnitRemoveAbility(gg_unit_h00A_0034, 'Ane2')
                call DisplayTimedTextToForce( bj_FORCE_ALL_PLAYERS, 5.00, "|cffffcc00'Host mode'|r activated." )
                call BlzFrameSetTexture( modesextraicon[5], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp", 0, true )
            else
                call SetUnitOwner( gg_unit_h00A_0034, Player(PLAYER_NEUTRAL_PASSIVE), true )
                call SetUnitColor( gg_unit_h00A_0034, PLAYER_COLOR_PINK )
                call UnitAddAbility(gg_unit_h00A_0034, 'Ane2')
                call DisplayTimedTextToForce( bj_FORCE_ALL_PLAYERS, 5.00, "|cffffcc00'Host mode'|r disabled." )
                call BlzFrameSetTexture( modesextraicon[5], BlzGetAbilityIcon( udg_DB_ModesFrame_Ability[5]), 0, true )
            endif
        endif
    endif
    
    set p = null
endfunction

function SetModeUse takes integer modeIndex, string modeName, integer x, integer y returns nothing
    if not( udg_worldmod[modeIndex] ) then
        set udg_worldmod[modeIndex] = true
        set IsModeUsed = true
        set udg_ModName = modeName
        call DisplayTimedTextToForce( bj_FORCE_ALL_PLAYERS, 5, "Mode |cffffcc00'"+udg_ModName+"'|r activated." )
        call BlzFrameSetTexture( modesmodeicon[x][y], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp", 0, true )
    else
        call DisplayTimedTextToForce( bj_FORCE_ALL_PLAYERS, 5, "Mode |cffffcc00'"+udg_ModName+"'|r disabled." )
        set udg_ModName = ""
        set udg_worldmod[modeIndex] = false
    endif
endfunction

globals
    boolean IsModeUsed = false
endglobals

function ModsModeUse takes nothing returns nothing
    local player p = GetTriggerPlayer()
    local integer cyclA = 0
    local integer cyclB
    local integer i = 0
    
    if GetLocalPlayer() == GetTriggerPlayer() then
        call BlzFrameSetVisible( BlzGetTriggerFrame(),false)
		call BlzFrameSetVisible( BlzGetTriggerFrame(),true)
	endif
    
    set IsModeUsed = false
    
    if udg_Host == p then
        set cyclA = 1
        loop
            exitwhen cyclA > udg_DB_ModesFrame_ModeLR
            set cyclB = 1
            loop
                exitwhen cyclB > udg_DB_ModesFrame_ModeUD
                call BlzFrameSetTexture( modesmodeicon[cyclA][cyclB], BlzGetAbilityIcon( DB_ModesFrame_Mode[cyclA][cyclB]), 0, true )
                set cyclB = cyclB + 1
            endloop
            set cyclA = cyclA + 1
        endloop
        
        if modesmodebut[1][1] == BlzGetTriggerFrame() then
            set i = 1
            call SetModeUse(i, "Fast start", 1, 1)
        elseif modesmodebut[2][1] == BlzGetTriggerFrame() then
            set i = 2
            call SetModeUse(i, "Apocalypse of Random", 2, 1)
        elseif modesmodebut[3][1] == BlzGetTriggerFrame() then
            set i = 7
            call SetModeUse(i, "Themed Challenge", 3, 1)
        elseif modesmodebut[4][1] == BlzGetTriggerFrame() then
            set i = 6
            call SetModeUse(i, "Damned", 4, 1)
        elseif modesmodebut[1][2] == BlzGetTriggerFrame() then
            set i = 3
            call SetModeUse(i, "Chaos", 1, 2)
        elseif modesmodebut[2][2] == BlzGetTriggerFrame() then
            set i = 4
            call SetModeUse(i, "More chaos!", 2, 2)
        elseif modesmodebut[3][2] == BlzGetTriggerFrame() then
            set i = 5
            call SetModeUse(i, "More! More chaos!", 3, 2)
        elseif modesmodebut[4][2] == BlzGetTriggerFrame() then
            set i = 8
            call SetModeUse(i, "Dragons and Dungeons", 4, 2)
        endif
        
        if IsModeUsed then
            set udg_worldmod[0] = true
        else
            set udg_worldmod[0] = false
        endif
        set cyclA = 1
        loop
            exitwhen cyclA > 8
            if i != cyclA then
                set udg_worldmod[cyclA] = false
            endif
            set cyclA = cyclA + 1
        endloop
    endif
    
    set p = null
endfunction

function RotationModeUse takes nothing returns nothing
    local player p = GetTriggerPlayer()
    local integer cyclA = 0
    local integer cyclB
    local boolean l = false
    local integer i = 0
    local integer k = 0
    
    if GetLocalPlayer() == p then
        call BlzFrameSetVisible( BlzGetTriggerFrame(),false)
		call BlzFrameSetVisible( BlzGetTriggerFrame(),true)
	endif
    
    if udg_Host == p then
        set i = 0
        set cyclA = 1
        loop
            exitwhen cyclA > udg_DB_ModesFrame_RotationUD
            set cyclB = 1
            loop
                exitwhen cyclB > udg_DB_ModesFrame_RotationLR
                set i = i + 1
                if modesroticon[cyclB][cyclA] != null then
                    call BlzFrameSetTexture( modesroticon[cyclB][cyclA], BlzGetAbilityIcon( DB_ModesFrame_Rotation[cyclB][cyclA]), 0, true )
                endif
                if modesrotebut[cyclB][cyclA] == BlzGetTriggerFrame() then
                    set k = i
                    if not(udg_Preset[i]) then
                        set udg_Preset[i] = true
                        set udg_Dublicate = true
                        set l = true 
                        call DisplayTimedTextToForce( udg_Players, 5, "|cffffcc00Rotation activated:|r " + BlzGetAbilityTooltip(DB_ModesFrame_Rotation[cyclB][cyclA], 0) )
                        call BlzFrameSetTexture( modesroticon[cyclB][cyclA], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp", 0, true )
                    else
                        set udg_Preset[i] = false
                        call DisplayTimedTextToForce( bj_FORCE_ALL_PLAYERS, 5, "Rotation |cffffcc00'" + BlzGetAbilityTooltip(DB_ModesFrame_Rotation[cyclB][cyclA], 0) + "'|r disabled." )
                    endif
                endif
                set cyclB = cyclB + 1
            endloop
            set cyclA = cyclA + 1
        endloop
        
        if l then
            set udg_Preset[0] = true
        else
            set udg_Preset[0] = false
            set udg_Dublicate = false
        endif
        set cyclA = 1
        loop
            exitwhen cyclA > udg_DB_ModesFrame_RotationNum
            if k != cyclA then
                set udg_Preset[cyclA] = false
            endif
            set cyclA = cyclA + 1
        endloop
    endif
    
    set p = null
endfunction

function FrameModeLight takes nothing returns nothing
    set modeslightnum = modeslightnum + modeslightmove

    call BlzFrameSetAlpha(modeslight, modeslightnum)
    if udg_fightmod[0] or modeslightbool then
        call BlzFrameSetVisible( modeslight, false )
        call DestroyTimer( GetExpiredTimer() )
    elseif modeslightnum <= 20 then
        set modeslightmove = 6
    elseif modeslightnum >= 200 then
        set modeslightmove = -6
    endif
endfunction

function Trig_ModesFrame_Actions takes nothing returns nothing
    local trigger trig
    local real x = 1
    local real y = 1
    local framehandle framebase
    local framehandle frame
    local integer cyclA
    local integer cyclB

    set modesbut = BlzCreateFrame("ScriptDialogButton", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI,0), 0,0) 

	call BlzFrameSetSize(modesbut, 0.08,0.03)
	call BlzFrameSetAbsPoint(modesbut, FRAMEPOINT_CENTER, 0.55, 0.154)
	call BlzFrameSetText(modesbut, "Mods")
    call BlzFrameSetVisible( modesbut, false )
	
    set trig = CreateTrigger()
	call BlzTriggerRegisterFrameEvent(trig, modesbut, FRAMEEVENT_CONTROL_CLICK)
	call TriggerAddAction(trig, function ButtonModes)
    
    set modeslight = BlzCreateFrameByType("BACKDROP", "",BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI,0), "StandartFrameTemplate", 0)
	call BlzFrameSetSize( modeslight, 0.12, 0.12 )
	call BlzFrameSetPoint(modeslight, FRAMEPOINT_CENTER, modesbut, FRAMEPOINT_CENTER, 0,0) 
	call BlzFrameSetTexture( modeslight, "framelightmode.blp", 0, true )
    call BlzFrameSetLevel( modeslight, -1 )
    call BlzFrameSetVisible( modeslight, false )
    
    call TimerStart(CreateTimer(),0.04,true,function FrameModeLight)

    set modesback = BlzCreateFrame("QuestButtonBaseTemplate", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), 0, 0)
    call BlzFrameSetAbsPoint(modesback, FRAMEPOINT_CENTER, 0.4, 0.35)
    call BlzFrameSetSize(modesback, x*0.57, y*0.32)
    call BlzFrameSetVisible( modesback, false )
    call BlzFrameSetLevel( modesback, -1 )
    
    //=========Difficulty=========
    set framebase = BlzCreateFrame("QuestButtonBackdropTemplate", modesback, 0, 0)
    call BlzFrameSetPoint(framebase, FRAMEPOINT_TOPLEFT, modesback, FRAMEPOINT_TOPLEFT, 0.005*x,-0.005*y) 
    call BlzFrameSetSize(framebase, 0.25*x, 0.1*y)
    
    set frame = BlzCreateFrameByType("TEXT", "", modesback, "StandartFrameTemplate", 0)
	call BlzFrameSetSize( frame, 0.06*x, 0.02*y )
	call BlzFrameSetPoint(frame, FRAMEPOINT_TOP, framebase, FRAMEPOINT_TOP, 0,-0.01*y) 
	call BlzFrameSetText( frame, "Difficulty" )
    
    set modesdificon = BlzCreateFrameByType("BACKDROP", "", modesback, "StandartFrameTemplate", 0)
	call BlzFrameSetSize( modesdificon, 0.04*x, 0.04*y )
	call BlzFrameSetPoint(modesdificon, FRAMEPOINT_TOPLEFT, framebase, FRAMEPOINT_TOPLEFT, 0.035*x,-0.02*y) //0 
	call BlzFrameSetTexture( modesdificon, BlzGetAbilityIcon( udg_DB_ModesFrame_Difficulty[0]), 0, true )

    set frame = BlzCreateFrame("ScriptDialogButton", modesback, 0,0) 
	call BlzFrameSetSize(frame, 0.03,0.03)
	call BlzFrameSetPoint(frame, FRAMEPOINT_TOPLEFT, framebase, FRAMEPOINT_TOPLEFT, 0.02*x,-0.06*y) //-0.02 
	call BlzFrameSetText(frame, "<")

    set trig = CreateTrigger()
	call BlzTriggerRegisterFrameEvent(trig, frame, FRAMEEVENT_CONTROL_CLICK)
	call TriggerAddAction(trig, function DifficultyLess)
    
    set frame = BlzCreateFrame("ScriptDialogButton", modesback, 0,0) 
	call BlzFrameSetSize(frame, 0.03,0.03)
	call BlzFrameSetPoint(frame, FRAMEPOINT_TOPLEFT, framebase, FRAMEPOINT_TOPLEFT, 0.06*x,-0.06*y) //-0.02 
	call BlzFrameSetText(frame, ">")

    set trig = CreateTrigger()
	call BlzTriggerRegisterFrameEvent(trig, frame, FRAMEEVENT_CONTROL_CLICK)
	call TriggerAddAction(trig, function DifficultyMore)
    
    set modesdiftool = BlzCreateFrameByType("TEXT", "", modesback, "StandartFrameTemplate", 0)
	call BlzFrameSetSize( modesdiftool, 0.14*x, 0.07*y )
	call BlzFrameSetPoint(modesdiftool, FRAMEPOINT_TOP, framebase, FRAMEPOINT_TOP, 0.04*x,-0.02*y)
    call BlzFrameSetText( modesdiftool, BlzGetAbilityExtendedTooltip(udg_DB_ModesFrame_Difficulty[0], 0) )
    
    //=========Extra=========
    set framebase = BlzCreateFrame("QuestButtonBackdropTemplate", modesback, 0, 0)
    call BlzFrameSetPoint(framebase, FRAMEPOINT_TOPLEFT, modesback, FRAMEPOINT_TOPLEFT, 0.005*x,-0.1*y) 
    call BlzFrameSetSize(framebase, 0.25*x, 0.1*y)
    
    set frame = BlzCreateFrameByType("TEXT", "", modesback, "StandartFrameTemplate", 0)
	call BlzFrameSetSize( frame, 0.04*x, 0.02*y )
	call BlzFrameSetPoint(frame, FRAMEPOINT_TOP, framebase, FRAMEPOINT_TOP, 0,-0.01*y) 
	call BlzFrameSetText( frame, "Extra" )
    
    set modeshostname = BlzCreateFrameByType("TEXT", "", framebase, "StandartFrameTemplate", 0)
	call BlzFrameSetSize( modeshostname, 0.1*x, 0.01*y )
	call BlzFrameSetPoint(modeshostname, FRAMEPOINT_BOTTOMLEFT, framebase, FRAMEPOINT_BOTTOMLEFT, 0.01*x,0.01*y)  
	call BlzFrameSetText( modeshostname, "Host: " + udg_Player_Color[GetPlayerId( udg_Host ) + 1] + GetPlayerName(udg_Host) + "|r" )
    
    set cyclA = 1
    loop
        exitwhen cyclA > udg_DB_ModesFrame_AbilityNum
        set modesextraicon[cyclA] = BlzCreateFrameByType("BACKDROP", "", modesback, "StandartFrameTemplate", 0)
        call BlzFrameSetSize( modesextraicon[cyclA], 0.04*x, 0.04*y )
        call BlzFrameSetPoint(modesextraicon[cyclA], FRAMEPOINT_TOPLEFT, framebase, FRAMEPOINT_TOPLEFT, (-0.03+(cyclA*0.045))*x,-0.03*y)
        
        call BlzFrameSetTexture( modesextraicon[cyclA], BlzGetAbilityIcon( udg_DB_ModesFrame_Ability[cyclA]), 0, true )
        
        set modesextrabut[cyclA] = BlzCreateFrameByType("GLUEBUTTON", "", modesback, "ScoreScreenTabButtonTemplate", 0)
        call BlzFrameSetSize( modesextrabut[cyclA], 0.04*x, 0.04*y )
        call BlzFrameSetPoint(modesextrabut[cyclA], FRAMEPOINT_CENTER, modesextraicon[cyclA], FRAMEPOINT_CENTER, 0,0)
        
        set trig = CreateTrigger()
    	call BlzTriggerRegisterFrameEvent(trig, modesextrabut[cyclA], FRAMEEVENT_CONTROL_CLICK)
    	call TriggerAddAction(trig, function ExtraModeUse)
        
        call SetStableTool( modesextrabut[cyclA], BlzGetAbilityTooltip(udg_DB_ModesFrame_Ability[cyclA], 0), BlzGetAbilityExtendedTooltip(udg_DB_ModesFrame_Ability[cyclA], 0) )
        set cyclA = cyclA + 1
    endloop
    
    //=========Mods=========
    set modebase = BlzCreateFrame("QuestButtonBackdropTemplate", modesback, 0, 0)
    call BlzFrameSetPoint(modebase, FRAMEPOINT_TOPLEFT, modesback, FRAMEPOINT_TOPLEFT, 0.005*x,-0.195*y) 
    call BlzFrameSetSize(modebase, 0.25*x, 0.12*y)
    
    set frame = BlzCreateFrameByType("TEXT", "", modebase, "StandartFrameTemplate", 0)
	call BlzFrameSetSize( frame, 0.04*x, 0.02*y )
	call BlzFrameSetPoint(frame, FRAMEPOINT_TOP, modebase, FRAMEPOINT_TOP, 0,-0.01*y) 
	call BlzFrameSetText( frame, "Mods" )
    
    set cyclA = 1
    //set i = 0
    loop
        exitwhen cyclA > udg_DB_ModesFrame_ModeLR
        set cyclB = 1
        loop
            exitwhen cyclB > udg_DB_ModesFrame_ModeUD
            //set i = i + 1
            if DB_ModesFrame_Mode[cyclA][cyclB] != 0 then
                set modesmodeicon[cyclA][cyclB]  = BlzCreateFrameByType("BACKDROP", "", modebase, "StandartFrameTemplate", 0)
                call BlzFrameSetSize( modesmodeicon[cyclA][cyclB], 0.04*x, 0.04*y )
                call BlzFrameSetPoint(modesmodeicon[cyclA][cyclB], FRAMEPOINT_TOP, modebase, FRAMEPOINT_TOP, (-0.11+(cyclA*0.045))*x,(0.02+(-0.045*cyclB))*y)
                call BlzFrameSetTexture( modesmodeicon[cyclA][cyclB], BlzGetAbilityIcon( DB_ModesFrame_Mode[cyclA][cyclB]), 0, true )
                
                //call DisplayTimedTextToForce( GetPlayersAll(), 5.00, "==================" )
                //call DisplayTimedTextToForce( GetPlayersAll(), 5.00, R2S((-0.09+(cyclA*0.045))*x) )
                //call DisplayTimedTextToForce( GetPlayersAll(), 5.00, R2S((0.02+(-0.045*cyclB))*y) )
                
                set modesmodebut[cyclA][cyclB] = BlzCreateFrameByType("GLUEBUTTON", "", modebase, "ScoreScreenTabButtonTemplate", 0)
                call BlzFrameSetSize( modesmodebut[cyclA][cyclB], 0.04*x, 0.04*y )
                call BlzFrameSetPoint(modesmodebut[cyclA][cyclB], FRAMEPOINT_CENTER, modesmodeicon[cyclA][cyclB], FRAMEPOINT_CENTER, 0,0)
                
                set trig = CreateTrigger()
                call BlzTriggerRegisterFrameEvent(trig, modesmodebut[cyclA][cyclB], FRAMEEVENT_CONTROL_CLICK)
                call TriggerAddAction(trig, function ModsModeUse)
                
                set modesDescription[cyclA][cyclB] = SetStableTool( modesmodebut[cyclA][cyclB], BlzGetAbilityTooltip(DB_ModesFrame_Mode[cyclA][cyclB], 0), BlzGetAbilityExtendedTooltip(DB_ModesFrame_Mode[cyclA][cyclB], 0) )
            endif
            set cyclB = cyclB + 1
        endloop
        set cyclA = cyclA + 1
    endloop  
    
    //=========Rotation=========
    set rotbase = BlzCreateFrame("QuestButtonBackdropTemplate", modesback, 0, 0)
    call BlzFrameSetPoint(rotbase, FRAMEPOINT_TOPLEFT, modesback, FRAMEPOINT_TOPLEFT, 0.255*x,-0.005*y) 
    call BlzFrameSetSize(rotbase, 0.305*x, 0.31*y)
    
    set frame = BlzCreateFrameByType("TEXT", "", rotbase, "StandartFrameTemplate", 0)
	call BlzFrameSetSize( frame, 0.04*x, 0.02*y )
	call BlzFrameSetPoint(frame, FRAMEPOINT_TOP, rotbase, FRAMEPOINT_TOP, 0,-0.01*y) 
	call BlzFrameSetText( frame, "Rotation" )
    
    set cyclA = 1
    loop
        exitwhen cyclA > udg_DB_ModesFrame_RotationLR
        set cyclB = 1
        loop
            exitwhen cyclB > udg_DB_ModesFrame_RotationUD
            if DB_ModesFrame_Rotation[cyclA][cyclB] != 0 then
                set modesroticon[cyclA][cyclB] = BlzCreateFrameByType("BACKDROP", "", rotbase, "StandartFrameTemplate", 0)
                call BlzFrameSetSize( modesroticon[cyclA][cyclB], 0.04*x, 0.04*y )
                call BlzFrameSetPoint(modesroticon[cyclA][cyclB], FRAMEPOINT_TOP, rotbase, FRAMEPOINT_TOP, (-0.14+(cyclA*0.045))*x,(0.02+(-0.045*cyclB))*y)
                call BlzFrameSetTexture( modesroticon[cyclA][cyclB], BlzGetAbilityIcon( DB_ModesFrame_Rotation[cyclA][cyclB]), 0, true )
                
                set modesrotebut[cyclA][cyclB] = BlzCreateFrameByType("GLUEBUTTON", "", rotbase, "ScoreScreenTabButtonTemplate", 0)
                call BlzFrameSetSize( modesrotebut[cyclA][cyclB], 0.04*x, 0.04*y )
                call BlzFrameSetPoint(modesrotebut[cyclA][cyclB], FRAMEPOINT_CENTER, modesroticon[cyclA][cyclB], FRAMEPOINT_CENTER, 0,0)
                
                set trig = CreateTrigger()
                call BlzTriggerRegisterFrameEvent(trig, modesrotebut[cyclA][cyclB], FRAMEEVENT_CONTROL_CLICK)
                call TriggerAddAction(trig, function RotationModeUse)
                
                call SetStableTool( modesrotebut[cyclA][cyclB], BlzGetAbilityTooltip(DB_ModesFrame_Rotation[cyclA][cyclB], 0), BlzGetAbilityExtendedTooltip(DB_ModesFrame_Rotation[cyclA][cyclB], 0) )
            endif
            set cyclB = cyclB + 1
        endloop
        set cyclA = cyclA + 1
    endloop  
    
    set trig = null
    set frame = null
    set framebase = null
endfunction

//===========================================================================
function InitTrig_ModesFrame takes nothing returns nothing
    set gg_trg_ModesFrame = CreateTrigger(  )
    call TriggerRegisterTimerExpireEvent( gg_trg_ModesFrame, udg_StartTimer )
    call TriggerAddAction( gg_trg_ModesFrame, function Trig_ModesFrame_Actions )
endfunction