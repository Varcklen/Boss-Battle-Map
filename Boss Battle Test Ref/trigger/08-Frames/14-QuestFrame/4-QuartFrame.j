globals
    framehandle quartback
    framehandle quartbut
	framehandle array quartart
    framehandle array quarticon
endglobals

function ButtonExitGuild takes nothing returns nothing
    if GetLocalPlayer() == GetTriggerPlayer() then
        call BlzFrameSetVisible( quartback,false)
	endif
endfunction

function IsHeroHaveNoQuest takes unit hero returns boolean
    local boolean isHasNoQuest = true
    local integer i
    local integer iEnd
    
    set i = 1
    set iEnd = udg_QuestItemNum
    loop
        exitwhen i > iEnd or isHasNoQuest == false
        if IsHeroHasItem(hero, udg_QuestItem[i]) then
            set isHasNoQuest = false
        endif
        set i = i + 1
    endloop

    set hero = null
    return isHasNoQuest
endfunction

function QuartBuy takes nothing returns nothing
    local player triggerPlayer = GetTriggerPlayer()
    local integer i = GetPlayerId( triggerPlayer ) + 1
    local unit hero = udg_hero[i]
    local integer cyclA 
    local integer cyclAEnd
    local boolean l = false
    
    if GetLocalPlayer() == triggerPlayer then
        call BlzFrameSetVisible( BlzGetTriggerFrame(),false)
		call BlzFrameSetVisible( BlzGetTriggerFrame(),true)
	endif
    
    if GetPlayerState(triggerPlayer, PLAYER_STATE_RESOURCE_GOLD) >= 100 and hero != null and UnitInventoryCount(hero) < 6 and IsHeroHaveNoQuest(hero) then
        set cyclA = 1
        set cyclAEnd = udg_QuestItemNum
        loop
            exitwhen cyclA > cyclAEnd
            if quartart[cyclA] == BlzGetTriggerFrame() then
                call BlzFrameSetVisible( quartart[cyclA],false)
                call BlzFrameSetVisible( quarticon[cyclA],false)
                if inv(hero, udg_QuestItem[cyclA]) == 0 then
                    call UnitAddItem( hero, CreateItem( udg_QuestItem[cyclA], GetUnitX(hero), GetUnitY(hero) ) )
                    set l = true
                endif
                set cyclA = cyclAEnd
            endif
            set cyclA = cyclA + 1
        endloop
        if l then
            set udg_QuestLimit[i] = true
            call SetPlayerState( triggerPlayer, PLAYER_STATE_RESOURCE_GOLD, IMaxBJ( 0, GetPlayerState(triggerPlayer, PLAYER_STATE_RESOURCE_GOLD) - 100 ) )
            if GetLocalPlayer() == triggerPlayer then
                call BlzFrameSetVisible( quartback, false )
            endif
        endif
    endif
    
    set triggerPlayer = null
    set hero = null
endfunction

function Trig_QuartFrame_Actions takes nothing returns nothing
	local trigger trig
    local framehandle frame
    local integer cyclA
    local integer i
    local real scale
    local item it
    local real size = 0
    
    set quartback = BlzCreateFrame("QuestButtonBaseTemplate", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI,0), 0, 0)
    call BlzFrameSetAbsPoint(quartback, FRAMEPOINT_TOPRIGHT, 0.75, 0.53)
    call BlzFrameSetVisible( quartback, false )
    call BlzFrameSetLevel( quartback, -1 )
    
    set frame = BlzCreateFrameByType("TEXT", "", quartback, "StandartFrameTemplate", 0)
	call BlzFrameSetSize( frame, 0.25, 0.03 )
	call BlzFrameSetPoint(frame, FRAMEPOINT_BOTTOMLEFT, quartback, FRAMEPOINT_BOTTOMLEFT, 0.01,0.005) 
	call BlzFrameSetText( frame, "|cffffcc00Cost:|r 100 gold|n|cffffcc00You can choose only 1 quest.|r|n|cffffcc00Choose carefully.|r" )
    
    set frame = BlzCreateFrameByType("BACKDROP", "", quartback, "StandartFrameTemplate", 0)
    call BlzFrameSetSize(frame, 0.022, 0.022)
    call BlzFrameSetPoint( frame, FRAMEPOINT_CENTER, quartback, FRAMEPOINT_TOPRIGHT, -0.01, -0.01 )
    call BlzFrameSetTexture(frame, "war3mapImported\\BTNExit.blp", 0, true)
    
    set quartbut = BlzCreateFrameByType("GLUEBUTTON", "", quartback, "ScoreScreenTabButtonTemplate", 0)
	call BlzFrameSetSize( quartbut, 0.025, 0.025 )
	call BlzFrameSetPoint( quartbut, FRAMEPOINT_CENTER, frame, FRAMEPOINT_CENTER, 0, 0 )
    
    set trig = CreateTrigger()
	call BlzTriggerRegisterFrameEvent(trig, quartbut, FRAMEEVENT_CONTROL_CLICK)
	call TriggerAddAction(trig, function ButtonExitGuild)
    
    set cyclA = 1
    set i = 0 
    set scale = 0
    loop
        exitwhen cyclA > udg_QuestItemNum
        set i = i + 1
        if i > 4 then
            set i = 1
            set scale = scale - 0.04
            set size = size + 0.04
        endif
        
        set it = CreateItem(udg_QuestItem[cyclA], 0, 0 )
        
        set quarticon[cyclA] = BlzCreateFrameByType("BACKDROP", "", quartback, "StandartFrameTemplate", 0)
        call BlzFrameSetSize(quarticon[cyclA], 0.04, 0.04)
        call BlzFrameSetPoint( quarticon[cyclA], FRAMEPOINT_CENTER, quartback, FRAMEPOINT_TOPLEFT, i*0.04, -0.04+scale )
        call BlzFrameSetTexture(quarticon[cyclA], udg_QuestItemString[cyclA], 0, true)
        
        set quartart[cyclA] = BlzCreateFrameByType("GLUEBUTTON", "", quartback, "ScoreScreenTabButtonTemplate", 0)
        call BlzFrameSetSize( quartart[cyclA], 0.04, 0.04 )
        call BlzFrameSetPoint( quartart[cyclA], FRAMEPOINT_CENTER, quarticon[cyclA], FRAMEPOINT_CENTER, 0, 0 )
        
        set trig = CreateTrigger()
        call BlzTriggerRegisterFrameEvent(trig, quartart[cyclA], FRAMEEVENT_CONTROL_CLICK)
        call TriggerAddAction(trig, function QuartBuy)
        
        call SetStableTool( quartart[cyclA], GetItemName(it), BlzGetItemDescription(it) )
        
        call RemoveItem(it)
        set cyclA = cyclA + 1
    endloop
    
    call BlzFrameSetSize(quartback, 0.2, 0.1+size)
    
    set it = null
	set trig = null
    set frame = null
endfunction

//===========================================================================
function InitTrig_QuartFrame takes nothing returns nothing
    set gg_trg_QuartFrame = CreateTrigger(  )
    call TriggerRegisterTimerExpireEvent( gg_trg_QuartFrame, udg_StartTimer )
    call TriggerAddAction( gg_trg_QuartFrame, function Trig_QuartFrame_Actions )
endfunction

