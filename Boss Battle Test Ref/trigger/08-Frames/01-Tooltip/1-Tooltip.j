library Tooltip initializer init 
    globals
        framehandle TooltipName = null
        framehandle TooltipDescription = null
        framehandle TooltipBackdrop = null
        
        private constant real TOOLTIP_RETREAT = 0.01
        private constant real TOOLTIP_NAME_SIZE = 1.25
        private constant real TOOLTIP_NAME_RETREAT = TOOLTIP_NAME_SIZE*0.008
        
        private constant string TOOLTIP_NAME_COLOR = "|cffffcc00"
    endglobals
    
    public function SetLocalTooltipText takes player localPlayer, string newName, string newDescription returns nothing 
        if GetLocalPlayer() == localPlayer then
            call BlzFrameSetText( TooltipName, TOOLTIP_NAME_COLOR + newName + "|r" )
            call BlzFrameSetText( TooltipDescription, newDescription )

            call BlzFrameSetPoint(TooltipBackdrop, FRAMEPOINT_BOTTOMLEFT, TooltipDescription, FRAMEPOINT_BOTTOMLEFT, -TOOLTIP_RETREAT, -TOOLTIP_RETREAT)
            call BlzFrameSetPoint(TooltipBackdrop, FRAMEPOINT_TOPRIGHT, TooltipDescription, FRAMEPOINT_TOPRIGHT, TOOLTIP_RETREAT, TOOLTIP_RETREAT + (2*TOOLTIP_NAME_RETREAT))
        endif
        set localPlayer = null
    endfunction
    
    private function TooltipDisable takes nothing returns nothing 
        if GetLocalPlayer() == GetTriggerPlayer() then
            call BlzFrameSetVisible( TooltipBackdrop, false )
        endif
    endfunction

    public function AddEvent takes framehandle frameToAdd, code codeEnter returns trigger
        local trigger trig = CreateTrigger()
        local trigger trigExit = CreateTrigger()
        
        call BlzTriggerRegisterFrameEvent(trig, frameToAdd, FRAMEEVENT_MOUSE_ENTER)
        call TriggerAddAction( trig, codeEnter )
        
        call BlzTriggerRegisterFrameEvent(trigExit, frameToAdd, FRAMEEVENT_MOUSE_LEAVE)
        call TriggerAddAction( trigExit, function TooltipDisable )
        
        set frameToAdd = null
        set codeEnter = null
        return trig
    endfunction

    private function init takes nothing returns nothing 
        set TooltipBackdrop = BlzCreateFrame( "QuestButtonBaseTemplate", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI,0), 0, 0 )
        call BlzFrameSetVisible( TooltipBackdrop, false )
        call BlzFrameSetLevel( TooltipBackdrop, 1 )
        
        set TooltipName = BlzCreateFrameByType("TEXT", "",  TooltipBackdrop, "StandartFrameTemplate", 0)
        call BlzFrameSetPoint( TooltipName, FRAMEPOINT_TOPLEFT, TooltipBackdrop, FRAMEPOINT_TOPLEFT, TOOLTIP_RETREAT/TOOLTIP_NAME_SIZE,-0.01) 
        call BlzFrameSetScale(TooltipName, TOOLTIP_NAME_SIZE)

        set TooltipDescription = BlzCreateFrameByType("TEXT", "",  TooltipBackdrop, "StandartFrameTemplate", 0)
        call BlzFrameSetSize(TooltipDescription, 0.3, 0)
        call BlzFrameSetAbsPoint(TooltipDescription, FRAMEPOINT_BOTTOMRIGHT, 0.78, 0.16)
    endfunction
endlibrary