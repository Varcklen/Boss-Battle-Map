globals
    framehandle spelltext
    string array spellstr
    framehandle extraPanelButton
    framehandle extraPanelBackground
    framehandle extraPanelNumPotion
    framehandle extraPanelNumUnique
endglobals

function SpellBar_ExtraPanels takes nothing returns nothing
    if GetTriggerPlayer() == GetLocalPlayer() then
		call BlzFrameSetVisible( extraPanelButton,false)
		call BlzFrameSetVisible( extraPanelButton,true)
        if not(BlzFrameIsVisible(extraPanelBackground)) then
            call BlzFrameSetText(extraPanelButton, "-")
            call BlzFrameSetVisible(extraPanelBackground, true)
        else
            call BlzFrameSetText(extraPanelButton, "+")
            call BlzFrameSetVisible(extraPanelBackground, false)
        endif
	endif
endfunction

function Trig_SpellBar_Actions takes nothing returns nothing
    local framehandle icon
    local framehandle frame
    local trigger trig

    set icon = BlzCreateFrameByType( "BACKDROP", "", BlzGetOriginFrame( ORIGIN_FRAME_GAME_UI, 0), "StandardFrameTemplate", 0)
    call BlzFrameSetSize( icon, 0.016, 0.016 ) 
    call BlzFrameSetAbsPoint( icon, FRAMEPOINT_CENTER, 0.558, 0.589 ) 
    call BlzFrameSetTexture( icon, "ReplaceableTextures\\PassiveButtons\\PASBTNFeedBack.blp", 0, true )

    set spelltext = BlzCreateFrameByType( "TEXT", "", BlzGetOriginFrame( ORIGIN_FRAME_GAME_UI, 0), "StandardFrameTemplate", 0)
    call BlzFrameSetSize( spelltext, 0.05, 0.03 ) 
    call BlzFrameSetAbsPoint( spelltext, FRAMEPOINT_CENTER, 0.62, 0.578 )
    call BlzFrameSetText(spelltext, "0.00%")
    
    //Extra Panels
    set extraPanelButton = BlzCreateFrame("ScriptDialogButton", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), 0,0) 
    call BlzFrameSetSize(extraPanelButton, 0.025,0.025)
    call BlzFrameSetAbsPoint(extraPanelButton, FRAMEPOINT_CENTER, 0.575, 0.588)
    call BlzFrameSetText(extraPanelButton, "+")
    set trig = CreateTrigger()
    call BlzTriggerRegisterFrameEvent(trig, extraPanelButton, FRAMEEVENT_CONTROL_CLICK)
	call TriggerAddAction(trig, function SpellBar_ExtraPanels)
    call BlzFrameSetLevel( extraPanelButton, 2 )
    
    set extraPanelBackground = BlzCreateFrame("QuestButtonBaseTemplate", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI,0), 0, 0)
    call BlzFrameSetAbsPoint(extraPanelBackground, FRAMEPOINT_TOP, 0.585, 0.59)
    call BlzFrameSetSize(extraPanelBackground, 0.07, 0.06)
    call BlzFrameSetVisible( extraPanelBackground, false )
    call BlzFrameSetLevel( extraPanelBackground, -1 )
    
    //Potion
    set extraPanelNumPotion = BlzCreateFrameByType("TEXT", "", extraPanelBackground, "StandartFrameTemplate", 0)
    call BlzFrameSetSize( extraPanelNumPotion, 0.05, 0.03 )
    call BlzFrameSetPoint(extraPanelNumPotion, FRAMEPOINT_LEFT, extraPanelBackground, FRAMEPOINT_LEFT, 0.035,-0.006)
    call BlzFrameSetText(extraPanelNumPotion, "0.00%")
    
    set frame = BlzCreateFrameByType( "BACKDROP", "", extraPanelBackground, "StandardFrameTemplate", 0)
    call BlzFrameSetSize( frame, 0.016, 0.016 ) 
    call BlzFrameSetPoint(frame, FRAMEPOINT_LEFT, extraPanelBackground, FRAMEPOINT_LEFT, 0.01,0.005) 
    call BlzFrameSetTexture( frame, "ReplaceableTextures\\PassiveButtons\\PASBTNLiquidFire.blp", 0, true )
    
    //Uniques
    set extraPanelNumUnique = BlzCreateFrameByType("TEXT", "", extraPanelBackground, "StandartFrameTemplate", 0)
    call BlzFrameSetSize( extraPanelNumUnique, 0.05, 0.03 )
    call BlzFrameSetPoint(extraPanelNumUnique, FRAMEPOINT_LEFT, extraPanelBackground, FRAMEPOINT_LEFT, 0.035,-0.025)
    call BlzFrameSetText(extraPanelNumUnique, "0.00%")
    
    set frame = BlzCreateFrameByType( "BACKDROP", "", extraPanelBackground, "StandardFrameTemplate", 0)
    call BlzFrameSetSize( frame, 0.016, 0.016 ) 
    call BlzFrameSetPoint(frame, FRAMEPOINT_LEFT, extraPanelBackground, FRAMEPOINT_LEFT, 0.01,-0.015) 
    call BlzFrameSetTexture( frame, "war3mapImported\\PASINV_Jewelry_Ring_34.blp", 0, true )
    
    set icon = null
    set trig = null
endfunction

//===========================================================================
function InitTrig_SpellBar takes nothing returns nothing
    set gg_trg_SpellBar = CreateTrigger(  )
    call TriggerRegisterTimerExpireEventBJ( gg_trg_SpellBar, udg_StartTimer )
    call TriggerAddAction( gg_trg_SpellBar, function Trig_SpellBar_Actions )
endfunction

