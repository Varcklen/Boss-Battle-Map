library BonusFrameLib



function StringSize takes string s returns real
	return 0.04+(0.0002*StringLength(s))
endfunction



function CreateIcon takes integer i returns nothing
    local framehandle bns
    
    set bonusframe[i] = BlzCreateFrameByType("BACKDROP", "", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), "StandartFrameTemplate", 0)

    call BlzFrameSetAbsPoint(bonusframe[i], FRAMEPOINT_CENTER, 0.4+(i*0.025), 0.4)	
    call BlzFrameSetSize(bonusframe[i], 0.025, 0.025)

    set bns = BlzCreateFrameByType("BUTTON", "", bonusframe[i], "StandartFrameTemplate", 0)
    call BlzFrameSetSize( bns, 0.025, 0.025 )
    call BlzFrameSetPoint(bns, FRAMEPOINT_CENTER, bonusframe[i], FRAMEPOINT_CENTER, 0.0,0.0)

    if i == 5 then
        set bnfrtlp[i] = BlzCreateFrame( "LastBossText", bonusframe[i], 0, 0 )
    elseif i == 8 then
        set bnfrtlp[i] = BlzCreateFrame( "SecondBossText", bonusframe[i], 0, 0 )
    elseif i == 0 then
        set bnfrtlp[i] = BlzCreateFrame( "BonusText", bonusframe[i], 0, 0 )
    else
        set bnfrtlp[i] = BlzCreateFrame( "BackdropText", bonusframe[i], 0, 0 )
    endif
    call BlzFrameSetAbsPoint(bnfrtlp[i], FRAMEPOINT_BOTTOM, 0.7, 0.16)
    call BlzFrameSetTooltip( bns, bnfrtlp[i] )

    set bonustxt[i] = BlzCreateFrameByType("TEXT", "",  bnfrtlp[i], "StandartFrameTemplate", 0)
    call BlzFrameSetPoint( bonustxt[i], FRAMEPOINT_TOPLEFT, bnfrtlp[i], FRAMEPOINT_TOPLEFT, 0.005,-0.025) 
    call BlzFrameSetSize(bonustxt[i], 0.3, 0.6)

    set bonustxtnm[i] = BlzCreateFrameByType("TEXT", "",  bnfrtlp[i], "StandartFrameTemplate", 0)
    call BlzFrameSetPoint( bonustxtnm[i], FRAMEPOINT_TOPLEFT, bnfrtlp[i], FRAMEPOINT_TOPLEFT, 0.005,-0.005) 
    call BlzFrameSetSize(bonustxtnm[i], 0.3, 0.6)
    
    call BlzFrameSetSize( bnfrtlp[i], 0.35, StringSize(udg_DB_BonusFrame_Tooltip[i]))
    call BlzFrameSetText( bonustxt[i], udg_DB_BonusFrame_Tooltip[i] )
    call BlzFrameSetText( bonustxtnm[i], udg_DB_BonusFrame_Name[i] )
    call BlzFrameSetTexture(bonusframe[i], udg_DB_BonusFrame_Icon[i], 0, true)
    call BlzFrameSetVisible(bonusframe[i], false)
    
    set bns = null
endfunction

function BonusFrameSet takes integer i, boolean l returns nothing
        //if bonusframe[i] == null then
        //    call CreateIcon(i)
        //endif
        //call BlzFrameSetVisible(bonusframe[i], true)
endfunction

endlibrary 