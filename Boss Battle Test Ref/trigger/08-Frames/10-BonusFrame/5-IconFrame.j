function Trig_IconFrame_Actions takes nothing returns nothing
    local integer cyclA = 1
    local framehandle frame
    local integer x = 0
    local integer y = 0
    
    loop
        exitwhen cyclA > udg_IconLim
        set udg_IconKey[cyclA] = ""
        set x = x + 1
        if x > 8 then
            set x = 1
            set y = y + 1
        endif

        set bonusframe[cyclA] = BlzCreateFrameByType("BACKDROP", "", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), "StandartFrameTemplate", 0)
        call BlzFrameSetAbsPoint( bonusframe[cyclA], FRAMEPOINT_CENTER, (0.03*x)-0.015, 0.56-(0.03*y))
        call BlzFrameSetSize(bonusframe[cyclA], 0.025, 0.025)
        call BlzFrameSetVisible(bonusframe[cyclA], false)
        
        set frame = BlzCreateFrameByType("BACKDROP", "", bonusframe[cyclA], "StandartFrameTemplate", 0)
        call BlzFrameSetTexture(frame, "war3mapImported\\PAS_Effect.blp", 0, true)
        call BlzFrameSetAllPoints(frame, bonusframe[cyclA])
        
        set frame = BlzCreateFrameByType("BUTTON", "", bonusframe[cyclA], "StandartFrameTemplate", 0)
        call BlzFrameSetSize( frame, 0.025, 0.025 )
        call BlzFrameSetPoint(frame, FRAMEPOINT_CENTER, bonusframe[cyclA], FRAMEPOINT_CENTER, 0.0,0.0)
        
        set bnfrtlp[cyclA] = BlzCreateFrame( "QuestButtonBaseTemplate", bonusframe[cyclA], 0, 0 )
        call BlzFrameSetAbsPoint(bnfrtlp[cyclA], FRAMEPOINT_BOTTOM, 0.7, 0.16)
        call BlzFrameSetTooltip( frame, bnfrtlp[cyclA] )
        call BlzFrameSetSize(bnfrtlp[cyclA], 0.35, 0.2)

        set bonustxtnm[cyclA] = BlzCreateFrameByType("TEXT", "",  bnfrtlp[cyclA], "StandartFrameTemplate", 0)
        call BlzFrameSetPoint( bonustxtnm[cyclA], FRAMEPOINT_TOPLEFT, bnfrtlp[cyclA], FRAMEPOINT_TOPLEFT, 0.008,-0.008) 
        call BlzFrameSetSize(bonustxtnm[cyclA], 0.25, 0.2)
        
        set bonustxt[cyclA] = BlzCreateFrameByType("TEXT", "",  bnfrtlp[cyclA], "StandartFrameTemplate", 0)
        call BlzFrameSetPoint( bonustxt[cyclA], FRAMEPOINT_TOPLEFT, bnfrtlp[cyclA], FRAMEPOINT_TOPLEFT, 0.008,-0.023) 
        call BlzFrameSetSize(bonustxt[cyclA], 0.25, 0.2)
        set cyclA = cyclA + 1
    endloop

    set frame = null
endfunction

//===========================================================================
function InitTrig_IconFrame takes nothing returns nothing
    set gg_trg_IconFrame = CreateTrigger(  )
    call TriggerRegisterTimerExpireEvent( gg_trg_IconFrame, udg_StartTimer )
    call TriggerAddAction( gg_trg_IconFrame, function Trig_IconFrame_Actions )
endfunction

