globals
    framehandle resback
    framehandle restext
endglobals

function ResTrame takes nothing returns nothing
    local framehandle frame
    local real x = 1.2
    local real y = 1.2
    
    set resback = BlzCreateFrameByType("BACKDROP", "", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), "StandartFrameTemplate", 0)
    call BlzFrameSetAbsPoint(resback, FRAMEPOINT_CENTER, 0.35, 0.565)	
    call BlzFrameSetSize(resback, 0.02*x, 0.012*y)
    call BlzFrameSetTexture( resback, "war3mapImported\\BTNfeed-icon-red-1_result.blp",0, true)
    call BlzFrameSetVisible( resback, false )
    
    set frame = BlzCreateFrameByType("BACKDROP", "", resback, "StandartFrameTemplate", 0)
    call BlzFrameSetPoint( frame, FRAMEPOINT_CENTER, resback, FRAMEPOINT_CENTER, -0.005*x, 0*y )
    call BlzFrameSetSize(frame, 0.01*x, 0.01*y)
    call BlzFrameSetTexture( frame, "ReplaceableTextures\\CommandButtons\\BTNAnkh.blp",0, true)
        
    set restext = BlzCreateFrameByType("TEXT", "", resback, "StandartFrameTemplate", 0)
    call BlzFrameSetSize( restext, 0.01*x, 0.01*y )
    call BlzFrameSetPoint(restext, FRAMEPOINT_BOTTOMLEFT, resback, FRAMEPOINT_BOTTOMLEFT, 0.012*x,0*y) 
    call BlzFrameSetText( restext, "0" )
    
    set frame = null
endfunction

//===========================================================================
function InitTrig_ResTrame takes nothing returns nothing
    set gg_trg_ResTrame = CreateTrigger(  )
    call TriggerRegisterTimerExpireEvent( gg_trg_ResTrame, udg_StartTimer )
    call TriggerAddAction( gg_trg_ResTrame, function ResTrame )
endfunction

