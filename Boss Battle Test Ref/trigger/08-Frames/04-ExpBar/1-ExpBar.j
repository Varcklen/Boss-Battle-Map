globals
    framehandle expbar = null
    framehandle expicon = null
    framehandle expword = null
    framehandle expfon = null
    framehandle expgive = null
endglobals

function Trig_ExpBar_Actions takes nothing returns nothing
    call BlzLoadTOCFile("war3mapImported\\ExpBar.toc")//keep?
     
    set expbar = BlzCreateSimpleFrame("ExpBarEx", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), 1)
    call BlzFrameSetAbsPoint(expbar, FRAMEPOINT_CENTER, 0.4, 0.4)
    call BlzFrameSetValue(BlzGetFrameByName("ExpBarEx",1), 0 )
    call BlzFrameSetText(BlzGetFrameByName("ExpBarExText",1), "")
    call BlzFrameSetSize(expbar, 0.3, 0.02)
    call BlzFrameSetTexture(expbar, "Replaceabletextures\\Teamcolor\\Teamcolor05.blp", 0, true)
    call BlzFrameSetVisible( expbar, false )
    
    set expicon = BlzCreateFrameByType("BACKDROP", "", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), "", 0)
    call BlzFrameSetAbsPoint(expicon, FRAMEPOINT_CENTER, 0.56, 0.4)	
    call BlzFrameSetSize(expicon, 0.018, 0.018)
    call BlzFrameSetLevel( expicon, -1 )
    call BlzFrameSetVisible( expicon, false )
    
    set expgive = BlzCreateFrameByType("TEXT", "", expicon, "StandartFrameTemplate", 0)
    call BlzFrameSetSize( expgive, 0.18, 0.06 )
    call BlzFrameSetAbsPoint(expgive, FRAMEPOINT_CENTER, 0.35, 0.36)
    call BlzFrameSetText( expgive, "" )
    
    set expfon = BlzCreateFrame("QuestButtonBaseTemplate", expicon, 0, 0)
    call BlzFrameSetPoint( expfon, FRAMEPOINT_TOP, expbar, FRAMEPOINT_TOP, 0, -0.013 )
    call BlzFrameSetSize(expfon, 0.2, 0.07)
    call BlzFrameSetVisible( expfon, false )
    
    set expword = BlzCreateFrameByType("TEXT", "", expfon, "StandartFrameTemplate", 0)
    call BlzFrameSetSize( expword, 0.18, 0.06 )
    call BlzFrameSetPoint( expword, FRAMEPOINT_CENTER, expfon, FRAMEPOINT_CENTER, 0, -0.01 ) 
    call BlzFrameSetText( expword, "" )
endfunction

//===========================================================================
function InitTrig_ExpBar takes nothing returns nothing
    set gg_trg_ExpBar = CreateTrigger(  )
    call TriggerRegisterTimerExpireEventBJ( gg_trg_ExpBar, udg_StartTimer )
    call TriggerAddAction( gg_trg_ExpBar, function Trig_ExpBar_Actions )
endfunction

