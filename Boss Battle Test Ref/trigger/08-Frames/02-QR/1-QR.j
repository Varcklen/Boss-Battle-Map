globals
    framehandle QRdiscordBackdrop
    framehandle QRpatreonBackdrop
endglobals

function QRPatreon takes nothing returns nothing
    if GetLocalPlayer() == GetTriggerPlayer() then
        call BlzFrameSetVisible( QRdiscordBackdrop, false )
        call BlzFrameSetVisible( QRpatreonBackdrop, true )
    endif
endfunction

function ButtonExitQRPat takes nothing returns nothing
    if GetLocalPlayer() == GetTriggerPlayer() then
        call BlzFrameSetVisible( QRpatreonBackdrop, false )
    endif
endfunction

function QRDiscord takes nothing returns nothing
    if GetLocalPlayer() == GetTriggerPlayer() then
        call BlzFrameSetVisible( QRpatreonBackdrop, false )
        call BlzFrameSetVisible( QRdiscordBackdrop, true )
    endif
endfunction

function ButtonExitQRDis takes nothing returns nothing
    if GetLocalPlayer() == GetTriggerPlayer() then
        call BlzFrameSetVisible( QRdiscordBackdrop, false )
    endif
endfunction

function Trig_QR_Actions takes nothing returns nothing
    local framehandle frame
    local framehandle but
    local trigger trig

    //======Discord======
    //Button
    set but = BlzCreateFrameByType("GLUEBUTTON", "", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), "ScoreScreenTabButtonTemplate", 0)
    call BlzFrameSetAbsPoint(but, FRAMEPOINT_CENTER, 0.2, 0.01)
	call BlzFrameSetSize( but, 0.02, 0.02 )
    call BlzFrameSetTexture(but, "war3mapImported\\BTNdc64.blp", 0, true)
    call BlzFrameSetLevel( but, 1 )

    set trig = CreateTrigger()
    call BlzTriggerRegisterFrameEvent(trig, but, FRAMEEVENT_CONTROL_CLICK)
    call TriggerAddAction(trig, function QRDiscord )

    set frame = BlzCreateFrameByType("BACKDROP", "", but, "StandartFrameTemplate", 0)
    call BlzFrameSetSize(frame, 0.02, 0.02)
    call BlzFrameSetPoint( frame, FRAMEPOINT_CENTER, but, FRAMEPOINT_CENTER, 0, 0 )
    call BlzFrameSetTexture(frame, "war3mapImported\\BTNdc64.blp", 0, true)

    call SetStableTool( but, "Discord", "Join us on Discord! Click to get a QR link to the server." )
    
    //QR-code
    set QRdiscordBackdrop = BlzCreateFrame("QuestButtonBaseTemplate", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI,0), 0, 0)
    call BlzFrameSetAbsPoint(QRdiscordBackdrop, FRAMEPOINT_BOTTOM, 0.56, 0.16)
    call BlzFrameSetSize( QRdiscordBackdrop, 0.17, 0.17 )
    call BlzFrameSetVisible( QRdiscordBackdrop, false )
    call BlzFrameSetLevel( QRdiscordBackdrop, 1 )
    
    set frame = BlzCreateFrameByType("BACKDROP", "", QRdiscordBackdrop, "StandartFrameTemplate", 0)
    call BlzFrameSetSize(frame, 0.022, 0.022)
    call BlzFrameSetPoint( frame, FRAMEPOINT_CENTER, QRdiscordBackdrop, FRAMEPOINT_TOPRIGHT, -0.01, -0.01 )
    call BlzFrameSetTexture(frame, "war3mapImported\\BTNExit.blp", 0, true)
    
    set but = BlzCreateFrameByType("GLUEBUTTON", "", QRdiscordBackdrop, "ScoreScreenTabButtonTemplate", 0)
	call BlzFrameSetSize(but, 0.025, 0.025 )
	call BlzFrameSetPoint( but, FRAMEPOINT_CENTER, frame, FRAMEPOINT_CENTER, 0, 0 )
    
    set trig = CreateTrigger()
	call BlzTriggerRegisterFrameEvent(trig, but, FRAMEEVENT_CONTROL_CLICK)
	call TriggerAddAction(trig, function ButtonExitQRDis)
    
    set frame = BlzCreateFrameByType("BACKDROP", "", QRdiscordBackdrop, "StandartFrameTemplate", 0)
    call BlzFrameSetSize(frame, 0.12, 0.12)
    call BlzFrameSetPoint( frame, FRAMEPOINT_CENTER, QRdiscordBackdrop, FRAMEPOINT_CENTER, 0, 0 )
    call BlzFrameSetTexture(frame, "war3mapImported\\QRDiscord.blp", 0, true)
    
    //======Patreon======
    //Button
    set but = BlzCreateFrameByType("GLUEBUTTON", "", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), "ScoreScreenTabButtonTemplate", 0)
    call BlzFrameSetAbsPoint(but, FRAMEPOINT_CENTER, 0.2, 0.03)
	call BlzFrameSetSize( but, 0.02, 0.02 )
    call BlzFrameSetLevel( but, 1 )

    set trig = CreateTrigger()
    call BlzTriggerRegisterFrameEvent(trig, but, FRAMEEVENT_CONTROL_CLICK)
    call TriggerAddAction(trig, function QRPatreon )
    
    set frame = BlzCreateFrameByType("BACKDROP", "", but, "StandartFrameTemplate", 0)
    call BlzFrameSetSize(frame, 0.02, 0.02)
    call BlzFrameSetPoint( frame, FRAMEPOINT_CENTER, but, FRAMEPOINT_CENTER, 0, 0 )
    call BlzFrameSetTexture(frame, "war3mapImported\\BTNpt64.blp", 0, true)

    call SetStableTool( but, "Patreon", "Join us on Patreon! Click to get a QR link to the site." )
    
    //QR-code
    set QRpatreonBackdrop = BlzCreateFrame("QuestButtonBaseTemplate", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI,0), 0, 0)
    call BlzFrameSetAbsPoint(QRpatreonBackdrop, FRAMEPOINT_BOTTOM, 0.56, 0.16)
    call BlzFrameSetSize( QRpatreonBackdrop, 0.17, 0.17 )
    call BlzFrameSetVisible( QRpatreonBackdrop, false )
    call BlzFrameSetLevel( QRpatreonBackdrop, 1 )
    
    set frame = BlzCreateFrameByType("BACKDROP", "", QRpatreonBackdrop, "StandartFrameTemplate", 0)
    call BlzFrameSetSize(frame, 0.022, 0.022)
    call BlzFrameSetPoint( frame, FRAMEPOINT_CENTER, QRpatreonBackdrop, FRAMEPOINT_TOPRIGHT, -0.01, -0.01 )
    call BlzFrameSetTexture(frame, "war3mapImported\\BTNExit.blp", 0, true)
    
    set but = BlzCreateFrameByType("GLUEBUTTON", "", QRpatreonBackdrop, "ScoreScreenTabButtonTemplate", 0)
	call BlzFrameSetSize(but, 0.025, 0.025 )
	call BlzFrameSetPoint( but, FRAMEPOINT_CENTER, frame, FRAMEPOINT_CENTER, 0, 0 )
    
    set trig = CreateTrigger()
	call BlzTriggerRegisterFrameEvent(trig, but, FRAMEEVENT_CONTROL_CLICK)
	call TriggerAddAction(trig, function ButtonExitQRPat)
    
    set frame = BlzCreateFrameByType("BACKDROP", "", QRpatreonBackdrop, "StandartFrameTemplate", 0)
    call BlzFrameSetSize(frame, 0.12, 0.12)
    call BlzFrameSetPoint( frame, FRAMEPOINT_CENTER, QRpatreonBackdrop, FRAMEPOINT_CENTER, 0, 0 )
    call BlzFrameSetTexture(frame, "war3mapImported\\QRPatreon.blp", 0, true)
    
    set frame = null
    set trig = null
    set but = null
endfunction

//===========================================================================
function InitTrig_QR takes nothing returns nothing
    set gg_trg_QR = CreateTrigger()
    call TriggerRegisterTimerExpireEvent( gg_trg_QR, udg_StartTimer )
    call TriggerAddAction( gg_trg_QR, function Trig_QR_Actions )
endfunction

