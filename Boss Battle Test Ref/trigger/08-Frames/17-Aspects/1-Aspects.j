library AspectFrames initializer init requires Tooltip, Aspects
    globals 
        private framehandle AspectBackground = null 
        private trigger TriggerAspectBackGround = null 
        private framehandle AspectVision = null 
        
        private framehandle array AspectButton[4]
        private framehandle array BackdropAspect[4]
        private trigger array TriggerAspect[4]
        string array AspectName[PLAYERS_LIMIT_ARRAYS][4]//players/aspect position
        string array AspectDescription[PLAYERS_LIMIT_ARRAYS][4]//players/aspect position
        
        framehandle ChoosedAspect = null 
        private trigger TriggerChoosedAspect = null 
        
        private constant string ASPECT_CANCEL_NAME = "Disable Aspect"
        private constant string ASPECT_CANCEL_DESCRIPTION = "You turn off the current aspect. It will no longer give positive and negative effects."
        
        real Event_AspectAdded_Real
        integer Event_AspectAdded_Key01
        integer Event_AspectAdded_Key02
        unit Event_AspectAdded_Hero
        
        real Event_AspectRemoved_Real
        integer Event_AspectRemoved_Key01
        integer Event_AspectRemoved_Key02
        unit Event_AspectRemoved_Hero
        
        integer array ChoosedAspect[5]
    endglobals

    public function SetAspectButtons takes player localPlayer, integer whichButton, integer aspectAbility returns nothing 
        local integer playerIndex = GetPlayerId(localPlayer)
    
        if whichButton < 1 or whichButton > 3 then
            call BJDebugMsg("Error! You are trying to access an AspectButton button that does not exist. You cannot change its description. Please contact the developer. Current: " + I2S(whichButton))
            return
        endif
        set AspectName[playerIndex][whichButton] = BlzGetAbilityTooltip(aspectAbility, 0)
        set AspectDescription[playerIndex][whichButton] = BlzGetAbilityExtendedTooltip(aspectAbility, 0)

        if GetLocalPlayer() == localPlayer then
            call BlzFrameSetTexture(BackdropAspect[whichButton], BlzGetAbilityIcon(aspectAbility), 0, true) 
        endif
        
        set localPlayer = null
    endfunction 
    
    private function AddAspect takes unit hero, integer key01, integer key02 returns nothing
        if IsAspectActive[key01][key02] == false then
            set IsAspectActive[key01][key02] = true
            //call BJDebugMsg("add key 01 02: " + I2S(key01) + " " + I2S(key02))
            
            set Event_AspectAdded_Key01 = key01
            set Event_AspectAdded_Key02 = key02
            set Event_AspectAdded_Hero = hero
            
            set Event_AspectAdded_Real = 0.00
            set Event_AspectAdded_Real = 1.00
            set Event_AspectAdded_Real = 0.00
        endif
        
        set hero = null
    endfunction 
    
    private function EnableHeroAspectTimer takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer() )
        local unit hero = LoadUnitHandle( udg_hash, id, StringHash( "acpe" ) )
        local integer heroIndex = LoadInteger( udg_hash, id, StringHash( "acpe" ) )
        local integer usedButton = LoadInteger( udg_hash, id, StringHash( "acpeb" ) )
        
        call AddAspect(hero, heroIndex, usedButton)
        
        set hero = null
    endfunction
    
    private function EnableHeroAspect takes player owner, integer heroIndex, integer usedButton returns nothing
        local integer id
        
        set id = InvokeTimerWithUnit(udg_hero[GetPlayerId(owner) + 1], "acpe", 0.02, false, function EnableHeroAspectTimer )
        call SaveInteger( udg_hash, id, StringHash( "acpe" ), heroIndex )
        call SaveInteger( udg_hash, id, StringHash( "acpeb" ), usedButton)

        set owner = null
    endfunction 
    
    private function RemoveAspect takes unit hero, integer key01, integer key02 returns nothing
        if IsAspectActive[key01][key02] == true then
            set IsAspectActive[key01][key02] = false
            //call BJDebugMsg("remove key 01 02: " + I2S(key01) + " " + I2S(key02))
            
            set Event_AspectRemoved_Key01 = key01
            set Event_AspectRemoved_Key02 = key02
            set Event_AspectRemoved_Hero = hero
            
            set Event_AspectRemoved_Real = 0.00
            set Event_AspectRemoved_Real = 1.00
            set Event_AspectRemoved_Real = 0.00
        endif
        
        set hero = null
    endfunction 
    
    private function DisableHeroAspectsTimer takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer() )
        local integer i = 0
        local unit hero = LoadUnitHandle( udg_hash, id, StringHash( "acpc" ) )
        local integer heroIndex = LoadInteger( udg_hash, id, StringHash( "acpc" ) )
        
        set i = 1
        loop
            exitwhen i > ASPECT_LIMIT
            call RemoveAspect(hero, heroIndex, i)
            set i = i + 1
        endloop
        
        set hero = null
    endfunction
    
    private function DisableHeroAspects takes player owner, integer heroIndex returns nothing
        local integer id
        
        set id = InvokeTimerWithUnit(udg_hero[GetPlayerId(owner) + 1], "acpc", 0.01, false, function DisableHeroAspectsTimer )
        call SaveInteger( udg_hash, id, StringHash( "acpc" ), heroIndex )

        set owner = null
    endfunction 
    
    //Buttons
    private function UseButton takes integer usedButton returns nothing
        local player owner = GetTriggerPlayer()
        local integer playerIndex = GetPlayerId(owner) + 1
        local integer heroIndex = udg_HeroNum[playerIndex]
        if usedButton < 0 or usedButton > 3 then
            call BJDebugMsg("Invalid AspectButton button pressed. Please notify the map developer about this. Current button: " + I2S(usedButton) + ".")
            return
        endif
        //call BJDebugMsg("used button: " + I2S(usedButton))
        call DisableHeroAspects(owner, heroIndex)
        if usedButton != 0 then
            call EnableHeroAspect(owner, heroIndex, usedButton)
            set ChoosedAspect[playerIndex] = Aspect[heroIndex][usedButton]
        else
            set ChoosedAspect[playerIndex] = 0
        endif
        
        if GetLocalPlayer() == owner then
            call BlzFrameSetEnable(AspectButton[usedButton], false) 
            call BlzFrameSetEnable(AspectButton[usedButton], true) 
            call BlzFrameSetAllPoints(ChoosedAspect, AspectButton[usedButton])
            if usedButton > 0 then
                call BlzFrameSetVisible( AspectVision, true )
                call BlzFrameSetTexture(AspectVision, BlzGetAbilityIcon(ChoosedAspect[playerIndex]), 0, true)
            else
                call BlzFrameSetVisible( AspectVision, false )
            endif
        endif
        
        set owner = null
    endfunction 
    
    function Aspect0Func takes nothing returns nothing 
        call UseButton(0)
    endfunction 
     
    function Aspect1Func takes nothing returns nothing 
        call UseButton(1)
    endfunction 
     
    function Aspect2Func takes nothing returns nothing 
        call UseButton(2)
    endfunction 
     
    function Aspect3Func takes nothing returns nothing 
        call UseButton(3)
    endfunction 
    
    //Tooltip
    private function TooltipEnable takes integer index returns nothing 
        local player owner = GetTriggerPlayer()
        local integer playerIndex = GetPlayerId(owner)
    
        /*if GetLocalPlayer() == owner then
            call BlzFrameSetVisible( TooltipBackdrop, true )
        endif*/
        call Tooltip_SetLocalTooltipText(owner, AspectName[playerIndex][index], AspectDescription[playerIndex][index])
        
        set owner = null
    endfunction 
    
    private function TooltipEnable0 takes nothing returns nothing 
        call TooltipEnable(0)
    endfunction
    
    private function TooltipEnable1 takes nothing returns nothing 
        call TooltipEnable(1)
    endfunction
    
    private function TooltipEnable2 takes nothing returns nothing 
        call TooltipEnable(2)
    endfunction
    
    private function TooltipEnable3 takes nothing returns nothing 
        call TooltipEnable(3)
    endfunction
   
    //Events
    private function IsHeroHasAspects takes unit hero returns boolean 
        local boolean hasAspect = false
        
        if Aspects_IsHeroCanUseAspects(hero) then
            set hasAspect = true
        endif
        
        set hero = null
        return hasAspect
    endfunction 
    
    //OnBattleStart
    private function Aspects_Start_Actions takes nothing returns nothing 
        call BlzFrameSetVisible( AspectBackground, false )
    endfunction
    
    //OnBattleEnd
    private function Aspects_End_Condition takes nothing returns boolean
        return IsHeroHasAspects(udg_FightEnd_Unit)
    endfunction
    
    private function Aspects_End_Actions takes nothing returns nothing 
        if GetLocalPlayer() == GetOwningPlayer(udg_FightEnd_Unit) then
            call BlzFrameSetVisible( AspectBackground, true )
        endif
    endfunction
    
    //OnHeroRepick
    private function Aspects_Repick_Actions takes nothing returns nothing 
        local integer heroIndex = udg_HeroNum[GetUnitUserData(Event_HeroRepick_Hero)]
        if GetLocalPlayer() == GetOwningPlayer(Event_HeroRepick_Hero) then
            call BlzFrameSetVisible( AspectBackground, false )
            call BlzFrameSetAllPoints(ChoosedAspect, AspectButton[0])
        endif
        call DisableHeroAspects(GetOwningPlayer(Event_HeroRepick_Hero), heroIndex)
    endfunction
    
    //OnHeroCreate
    private function Choose_Condition takes nothing returns boolean
        return IsHeroHasAspects(Event_HeroChoose_Hero)
    endfunction
    
    private function Choose_Actions takes nothing returns nothing 
        local player owner = GetOwningPlayer(Event_HeroChoose_Hero)
        local integer heroIndex = udg_HeroNum[GetUnitUserData(Event_HeroChoose_Hero)]
        local integer i 
        
        if GetLocalPlayer() == owner then
            call BlzFrameSetVisible( AspectBackground, true )
        endif

        set i = 1
        loop
            exitwhen i > ASPECT_LIMIT
            call SetAspectButtons(owner, i, Aspect[heroIndex][i])
            set i = i + 1
        endloop
        
        set owner = null
    endfunction
    
    //Initialization
    private function init takes nothing returns nothing
        local framehandle outline = null
        local integer i

         set AspectBackground = BlzCreateFrame("CheckListBox", BlzGetFrameByName("ConsoleUIBackdrop", 0),0,0) 
         call BlzFrameSetAbsPoint(AspectBackground, FRAMEPOINT_TOPLEFT, 0.00519000, 0.216140) 
         call BlzFrameSetAbsPoint(AspectBackground, FRAMEPOINT_BOTTOMRIGHT, 0.184490, 0.164600) 
         call BlzFrameSetVisible( AspectBackground, false )

         set AspectButton[0] = BlzCreateFrame("ScriptDialogButton", AspectBackground, 0, 0) 
         call BlzFrameSetAbsPoint(AspectButton[0], FRAMEPOINT_TOPLEFT, 0.0100000, 0.210000) 
         call BlzFrameSetAbsPoint(AspectButton[0], FRAMEPOINT_BOTTOMRIGHT, 0.0500100, 0.170000) 
         set BackdropAspect[0] = BlzCreateFrameByType("BACKDROP", "BackdropAspect0", AspectButton[0], "", 1) 
         call BlzFrameSetAllPoints(BackdropAspect[0], AspectButton[0]) 
         call BlzFrameSetTexture(BackdropAspect[0], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp", 0, true) 
         set TriggerAspect[0] = CreateTrigger() 
         call BlzTriggerRegisterFrameEvent(TriggerAspect[0], AspectButton[0], FRAMEEVENT_CONTROL_CLICK) 
         call TriggerAddAction(TriggerAspect[0], function Aspect0Func) 
         call Tooltip_AddEvent(AspectButton[0], function TooltipEnable0 )

         set AspectButton[1] = BlzCreateFrame("ScriptDialogButton", AspectBackground, 0, 0) 
         call BlzFrameSetAbsPoint(AspectButton[1], FRAMEPOINT_TOPLEFT, 0.0520100, 0.210000) 
         call BlzFrameSetAbsPoint(AspectButton[1], FRAMEPOINT_BOTTOMRIGHT, 0.0920200, 0.170000) 
         set BackdropAspect[1] = BlzCreateFrameByType("BACKDROP", "BackdropAspect1", AspectButton[1], "", 1) 
         call BlzFrameSetAllPoints(BackdropAspect[1], AspectButton[1]) 
         call BlzFrameSetTexture(BackdropAspect[1], "", 0, true) 
         set TriggerAspect[1] = CreateTrigger() 
         call BlzTriggerRegisterFrameEvent(TriggerAspect[1], AspectButton[1], FRAMEEVENT_CONTROL_CLICK) 
         call TriggerAddAction(TriggerAspect[1], function Aspect1Func) 
         call Tooltip_AddEvent(AspectButton[1], function TooltipEnable1 )

         set AspectButton[2] = BlzCreateFrame("ScriptDialogButton", AspectBackground, 0, 0) 
         call BlzFrameSetAbsPoint(AspectButton[2], FRAMEPOINT_TOPLEFT, 0.0940200, 0.210000) 
         call BlzFrameSetAbsPoint(AspectButton[2], FRAMEPOINT_BOTTOMRIGHT, 0.134030, 0.170000) 
         set BackdropAspect[2] = BlzCreateFrameByType("BACKDROP", "BackdropAspect2", AspectButton[2], "", 1) 
         call BlzFrameSetAllPoints(BackdropAspect[2], AspectButton[2]) 
         call BlzFrameSetTexture(BackdropAspect[2], "", 0, true) 
         set TriggerAspect[2] = CreateTrigger() 
         call BlzTriggerRegisterFrameEvent(TriggerAspect[2], AspectButton[2], FRAMEEVENT_CONTROL_CLICK) 
         call TriggerAddAction(TriggerAspect[2], function Aspect2Func) 
         call Tooltip_AddEvent(AspectButton[2], function TooltipEnable2 )

         set AspectButton[3] = BlzCreateFrame("ScriptDialogButton", AspectBackground, 0, 0) 
         call BlzFrameSetAbsPoint(AspectButton[3], FRAMEPOINT_TOPLEFT, 0.136030, 0.210000) 
         call BlzFrameSetAbsPoint(AspectButton[3], FRAMEPOINT_BOTTOMRIGHT, 0.176040, 0.170000) 
         set BackdropAspect[3] = BlzCreateFrameByType("BACKDROP", "BackdropAspect3", AspectButton[3], "", 1) 
         call BlzFrameSetAllPoints(BackdropAspect[3], AspectButton[3]) 
         call BlzFrameSetTexture(BackdropAspect[3], "", 0, true) 
         set TriggerAspect[3] = CreateTrigger() 
         call BlzTriggerRegisterFrameEvent(TriggerAspect[3], AspectButton[3], FRAMEEVENT_CONTROL_CLICK) 
         call TriggerAddAction(TriggerAspect[3], function Aspect3Func) 
         call Tooltip_AddEvent(AspectButton[3], function TooltipEnable3 )
         
         set i = 0
        loop
            exitwhen i > 3
            set ChoosedAspect[i+1] = 0
            set AspectName[i][0] = ASPECT_CANCEL_NAME
            set AspectDescription[i][0] = ASPECT_CANCEL_DESCRIPTION
            
            set outline = BlzCreateFrameByType("BACKDROP", "", AspectButton[i], "", 1) 
            call BlzFrameSetAllPoints(outline, AspectButton[i]) 
            call BlzFrameSetTexture(outline, "BTNOutline.blp", 0, true) 
            set i = i + 1
        endloop

        set ChoosedAspect = BlzCreateFrameByType("BACKDROP", "", AspectBackground, "", 1) 
        call BlzFrameSetAllPoints(ChoosedAspect, AspectButton[0])
        call BlzFrameSetTexture(ChoosedAspect, "ChoosedApsect.blp", 0, true) 
         
        call CreateEventTrigger( "udg_FightEnd_Real", function Aspects_End_Actions, function Aspects_End_Condition )
        call CreateEventTrigger( "udg_FightStartGlobal_Real", function Aspects_Start_Actions, null )
        
        call CreateEventTrigger( "Event_HeroChoose_Real", function Choose_Actions, function Choose_Condition )
        call CreateEventTrigger( "Event_HeroRepick_Real", function Aspects_Repick_Actions, null )
        
        //Small icon with aspect
        set AspectVision = BlzCreateFrameByType("BACKDROP", "AspectVision", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), "", 1) 
        call BlzFrameSetAbsPoint(AspectVision, FRAMEPOINT_BOTTOM, 0.202, 0.04)
        call BlzFrameSetSize( AspectVision, 0.017, 0.017 )
        call BlzFrameSetTexture( AspectVision, "", 0, true) 
        call BlzFrameSetVisible( AspectVision, false )
        
        set outline = null
    endfunction 
endlibrary


