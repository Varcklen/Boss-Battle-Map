function Trig_HPBoss_Actions takes nothing returns nothing
     call BlzLoadTOCFile("war3mapImported\\myBar.toc")//keep?

    //First Bar
    set hpbar1 = BlzCreateSimpleFrame("MyBarEx", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), 1)
    call BlzFrameSetAbsPoint(hpbar1, FRAMEPOINT_CENTER, 0.4, 0.54)
    call BlzFrameSetText(BlzGetFrameByName("MyBarExText",1), "")
    call BlzFrameSetSize(hpbar1, 0.3, 0.02)
    call BlzFrameSetTexture(hpbar1, "Replaceabletextures\\Teamcolor\\Teamcolor22.blp", 0, true)
    call BlzFrameSetVisible( hpbar1, false )
    
    set hpPerc1 = BlzCreateFrameByType("TEXT", "", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), "StandartFrameTemplate", 0)
	call BlzFrameSetSize( hpPerc1, 0.1, 0.04 ) 
    call BlzFrameSetAbsPoint(hpPerc1, FRAMEPOINT_CENTER, 0.573, 0.525)
	call BlzFrameSetText( hpPerc1, "|cffbababc100%|r" )
    call BlzFrameSetVisible( hpPerc1, false )
    
    //Second Bar
    set hpbar2 = BlzCreateSimpleFrame("MyBarEx", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), 2)
    call BlzFrameSetAbsPoint(hpbar2, FRAMEPOINT_CENTER, 0.4, 0.518)
    call BlzFrameSetText(BlzGetFrameByName("MyBarExText",2), "")
    call BlzFrameSetSize(hpbar2, 0.3, 0.02)
    call BlzFrameSetTexture(hpbar2, "Replaceabletextures\\Teamcolor\\Teamcolor22.blp", 0, true)
    call BlzFrameSetVisible( hpbar2, false )
    
    set hpPerc2 = BlzCreateFrameByType("TEXT", "", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), "StandartFrameTemplate", 0)
	call BlzFrameSetSize( hpPerc2, 0.1, 0.04 )
    call BlzFrameSetAbsPoint(hpPerc2, FRAMEPOINT_CENTER, 0.573, 0.503)
	call BlzFrameSetText( hpPerc2, "|cffbababc100%|r" )
    call BlzFrameSetVisible( hpPerc2, false )
endfunction

//===========================================================================
function InitTrig_HPBoss takes nothing returns nothing
    set gg_trg_HPBoss = CreateTrigger(  )
    call TriggerRegisterTimerExpireEvent( gg_trg_HPBoss, udg_StartTimer )
    call TriggerAddAction( gg_trg_HPBoss, function Trig_HPBoss_Actions )
endfunction

