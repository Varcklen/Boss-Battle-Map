globals
    framehandle lucktext
	string array luckstr 
endglobals

function Trig_LuckBar_Actions takes nothing returns nothing
    local framehandle icon
    
    set icon = BlzCreateFrameByType( "BACKDROP", "", BlzGetOriginFrame( ORIGIN_FRAME_GAME_UI, 0), "StandardFrameTemplate", 0)
    call BlzFrameSetSize( icon, 0.016, 0.016 ) 
    call BlzFrameSetAbsPoint( icon, FRAMEPOINT_CENTER, 0.644, 0.589 ) 
    call BlzFrameSetTexture( icon, "ReplaceableTextures\\PassiveButtons\\PASBTNPillage.blp", 0, true )

    set lucktext = BlzCreateFrameByType( "TEXT", "", BlzGetOriginFrame( ORIGIN_FRAME_GAME_UI, 0), "StandardFrameTemplate", 0)
    call BlzFrameSetSize( lucktext, 0.03, 0.03 ) 
    call BlzFrameSetAbsPoint( lucktext, FRAMEPOINT_CENTER, 0.711, 0.578 )
    call BlzFrameSetText(lucktext, "0%")
    
    set icon = null
endfunction

//===========================================================================
function InitTrig_LuckBar takes nothing returns nothing
    set gg_trg_LuckBar = CreateTrigger(  )
    call TriggerRegisterTimerExpireEventBJ( gg_trg_LuckBar, udg_StartTimer )
    call TriggerAddAction( gg_trg_LuckBar, function Trig_LuckBar_Actions )
endfunction

