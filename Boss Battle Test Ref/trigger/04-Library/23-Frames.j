library Frames

    globals
        private trigger TempTrigger = null
        
        private constant integer KEY_EXIT = StringHash("exit")
    endglobals

    private function Exit takes nothing returns nothing
        local framehandle frame = LoadFrameHandle(udg_hash, GetHandleId(BlzGetTriggerFrame()), KEY_EXIT )
        if GetLocalPlayer() == GetTriggerPlayer() then
            call BlzFrameSetVisible( frame,false)
        endif
        set frame = null
    endfunction

    public function AddExitButton takes framehandle background returns trigger
        local framehandle clickButton
        local framehandle icon
    
        if udg_hash == null then
            set udg_hash = InitHashtable()
        endif
    
        set icon = BlzCreateFrameByType("BACKDROP", "", background, "StandartFrameTemplate", 0)
        call BlzFrameSetSize( icon, 0.022, 0.022)
        call BlzFrameSetPoint( icon, FRAMEPOINT_CENTER, background, FRAMEPOINT_TOPRIGHT, -0.01, -0.01 )
        call BlzFrameSetTexture(icon, "war3mapImported\\BTNExit.blp", 0, true)
    
        set clickButton = BlzCreateFrameByType("GLUEBUTTON", "", background, "ScoreScreenTabButtonTemplate", 0)
        call BlzFrameSetSize( clickButton, 0.025, 0.025 )
        call BlzFrameSetPoint( clickButton, FRAMEPOINT_CENTER, icon, FRAMEPOINT_CENTER, 0, 0 )
        call SaveFrameHandle(udg_hash, GetHandleId(clickButton), KEY_EXIT, background )
        
        set TempTrigger = CreateTrigger()
        call BlzTriggerRegisterFrameEvent(TempTrigger, clickButton, FRAMEEVENT_CONTROL_CLICK)
        call TriggerAddAction(TempTrigger, function Exit)
        
        set icon = null
        set clickButton = null
        set background = null
        return TempTrigger
    endfunction

endlibrary