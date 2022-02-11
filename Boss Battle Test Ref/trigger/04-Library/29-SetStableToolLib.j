library SetStableToolLib

    function StringSizeStableTool takes string s returns real
        return 0.05+(0.0003*StringLength(s))
    endfunction

    globals
        private framehandle description = null
    endglobals

    function SetStableTool takes framehandle f, string name, string disc returns framehandle
        local framehandle frame
        local framehandle tool

        set tool = BlzCreateFrame( "QuestButtonBaseTemplate", f, 0, 0 )
        call BlzFrameSetAbsPoint(tool, FRAMEPOINT_BOTTOM, 0.7, 0.16)
        call BlzFrameSetTooltip( f, tool )
        call BlzFrameSetSize( tool, 0.35, StringSizeStableTool(disc) )

        set frame = BlzCreateFrameByType("TEXT", "",  tool, "StandartFrameTemplate", 0)
        call BlzFrameSetPoint( frame, FRAMEPOINT_TOPLEFT, tool, FRAMEPOINT_TOPLEFT, 0.008,-0.008) 
        call BlzFrameSetSize(frame, 0.25, StringSizeStableTool(disc)+0.05)
        call BlzFrameSetText( frame, name )

        set description = BlzCreateFrameByType("TEXT", "",  tool, "StandartFrameTemplate", 0)
        call BlzFrameSetPoint( description, FRAMEPOINT_TOPLEFT, tool, FRAMEPOINT_TOPLEFT, 0.008,-0.023) 
        call BlzFrameSetSize( description, 0.25, StringSizeStableTool(disc)+0.05)
        call BlzFrameSetText( description, disc )

        set tool = null
        set frame = null
        set f = null
        return description
    endfunction
    
    function SetStableToolDescription takes framehandle f, string disc returns nothing
        local framehandle parent = BlzFrameGetParent(f)
    
        call BlzFrameSetSize( parent, 0.35, StringSizeStableTool(disc) )
        call BlzFrameSetSize( f, 0.25, StringSizeStableTool(disc)+0.05)
        call BlzFrameSetText( f, disc )
        
        set f = null
        set parent = null
    endfunction

endlibrary