globals
    framehandle specback
    framehandle specbut
	framehandle array spectart
    framehandle array specicon
    
    constant integer SPECIALS_IN_A_ROW = 5
    constant real SPECIALS_ICON_SIZE = 0.035
    constant integer SPECIALS_COST = 100
endglobals

function ButtonExitSpec takes nothing returns nothing
    if GetLocalPlayer() == GetTriggerPlayer() then
        call BlzFrameSetVisible( specback,false)
	endif
endfunction

function SpecBuy takes nothing returns nothing
    local player p = GetTriggerPlayer()
    local integer i = GetPlayerId( p ) + 1
    local unit u = udg_hero[i]
    local integer cyclA 
    local integer cyclAEnd
    local boolean l = false
    
    if GetLocalPlayer() == GetTriggerPlayer() then
        call BlzFrameSetVisible( BlzGetTriggerFrame(),false)
		call BlzFrameSetVisible( BlzGetTriggerFrame(),true)
	endif
    
    if GetPlayerState(p, PLAYER_STATE_RESOURCE_GOLD) >= SPECIALS_COST and u != null then
        set cyclA = 1
        set cyclAEnd = udg_Database_NumberItems[37]
        loop
            exitwhen cyclA > cyclAEnd
            if spectart[cyclA] == BlzGetTriggerFrame() then
                if udg_Ability_Spec[i] != udg_DB_Ability_Special[cyclA] then
                    call NewSpecial( u, udg_DB_Ability_Special[cyclA] )
                    set l = true
                endif
                set cyclA = cyclAEnd
            endif
            set cyclA = cyclA + 1
        endloop
        if l then
            call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Items\\TomeOfRetraining\\TomeOfRetrainingCaster.mdl", u, "origin" ) )
            call SetPlayerState( p, PLAYER_STATE_RESOURCE_GOLD, IMaxBJ( 0, GetPlayerState(p, PLAYER_STATE_RESOURCE_GOLD) - SPECIALS_COST ) )
            if GetLocalPlayer() == GetTriggerPlayer() then
                call BlzFrameSetVisible( specback,false)
            endif
        endif
    endif
    
    set p = null
    set u = null
endfunction

function Trig_SpecialFrame_Actions takes nothing returns nothing
	local trigger trig
    local framehandle frame
    local integer cyclA
    local integer i
    local real scale
    local real size = 0
    
    set specback = BlzCreateFrame("QuestButtonBaseTemplate", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI,0), 0, 0)
    call BlzFrameSetAbsPoint(specback, FRAMEPOINT_TOPRIGHT, 0.75, 0.53)
    call BlzFrameSetVisible( specback, false )
    call BlzFrameSetLevel( specback, -1 )
    
    set frame = BlzCreateFrameByType("TEXT", "", specback, "StandartFrameTemplate", 0)
	call BlzFrameSetSize( frame, 0.25, 0.02 )
	call BlzFrameSetPoint(frame, FRAMEPOINT_BOTTOMLEFT, specback, FRAMEPOINT_BOTTOMLEFT, 0.01,0.005)  
	call BlzFrameSetText( frame, "Choose a |cff8080ffspecial|r ability. |cffffcc00Cost:|r 100 gold|n|cFF959697The ability can be changed at any time.|r" )
    
    set frame = BlzCreateFrameByType("BACKDROP", "", specback, "StandartFrameTemplate", 0)
    call BlzFrameSetSize(frame, 0.022, 0.022)
    call BlzFrameSetPoint( frame, FRAMEPOINT_CENTER, specback, FRAMEPOINT_TOPRIGHT, -0.01, -0.01 )
    call BlzFrameSetTexture(frame, "war3mapImported\\BTNExit.blp", 0, true)
    
    set specbut = BlzCreateFrameByType("GLUEBUTTON", "", specback, "ScoreScreenTabButtonTemplate", 0)
	call BlzFrameSetSize( specbut, 0.025, 0.025 )
	call BlzFrameSetPoint( specbut, FRAMEPOINT_CENTER, frame, FRAMEPOINT_CENTER, 0, 0 )
    
    set trig = CreateTrigger()
	call BlzTriggerRegisterFrameEvent(trig, specbut, FRAMEEVENT_CONTROL_CLICK)
	call TriggerAddAction(trig, function ButtonExitSpec)
    
    set cyclA = 1
    set i = 0 
    set scale = 0
    loop
        exitwhen cyclA > udg_Database_NumberItems[37]
        set i = i + 1
        if i > SPECIALS_IN_A_ROW then
            set i = 1
            set scale = scale - SPECIALS_ICON_SIZE
            set size = size + SPECIALS_ICON_SIZE
        endif
        
        set specicon[cyclA] = BlzCreateFrameByType("BACKDROP", "", specback, "StandartFrameTemplate", 0)
        call BlzFrameSetSize(specicon[cyclA], SPECIALS_ICON_SIZE, SPECIALS_ICON_SIZE)
        call BlzFrameSetPoint( specicon[cyclA], FRAMEPOINT_CENTER, specback, FRAMEPOINT_TOPLEFT, i*SPECIALS_ICON_SIZE, -SPECIALS_ICON_SIZE+scale )
        call BlzFrameSetTexture( specicon[cyclA], BlzGetAbilityIcon( udg_DB_Ability_Special[cyclA]), 0, true )
        
        set spectart[cyclA] = BlzCreateFrameByType("GLUEBUTTON", "", specback, "ScoreScreenTabButtonTemplate", 0)
        call BlzFrameSetSize( spectart[cyclA], SPECIALS_ICON_SIZE, SPECIALS_ICON_SIZE )
        call BlzFrameSetPoint( spectart[cyclA], FRAMEPOINT_CENTER, specicon[cyclA], FRAMEPOINT_CENTER, 0, 0 )
        
        set trig = CreateTrigger()
        call BlzTriggerRegisterFrameEvent(trig, spectart[cyclA], FRAMEEVENT_CONTROL_CLICK)
        call TriggerAddAction(trig, function SpecBuy)
        
        call SetStableTool( spectart[cyclA], BlzGetAbilityTooltip(udg_DB_Ability_Special[cyclA], 0), BlzGetAbilityExtendedTooltip(udg_DB_Ability_Special[cyclA], 0) )
        set cyclA = cyclA + 1
    endloop

    call BlzFrameSetSize(specback, 0.05+(SPECIALS_IN_A_ROW*SPECIALS_ICON_SIZE), 0.09+size)

	set trig = null
    set frame = null
endfunction

//===========================================================================
function InitTrig_SpecialFrame takes nothing returns nothing
    set gg_trg_SpecialFrame = CreateTrigger(  )
    call TriggerRegisterTimerExpireEvent( gg_trg_SpecialFrame, udg_StartTimer )
    call TriggerAddAction( gg_trg_SpecialFrame, function Trig_SpecialFrame_Actions )
endfunction

