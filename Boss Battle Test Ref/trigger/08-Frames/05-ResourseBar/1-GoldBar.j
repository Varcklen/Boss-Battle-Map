globals
    framehandle goldtext
	string array goldstr 
endglobals

function Trig_GoldBar_Actions takes nothing returns nothing
    local framehandle icon
    
    set icon = BlzCreateFrameByType( "BACKDROP", "", BlzGetOriginFrame( ORIGIN_FRAME_GAME_UI, 0), "StandardFrameTemplate", 0)
    call BlzFrameSetSize( icon, 0.016, 0.016 ) 
    call BlzFrameSetAbsPoint( icon, FRAMEPOINT_CENTER, 0.47, 0.589 ) 
    call BlzFrameSetTexture( icon, "UI\\Feedback\\Resources\\ResourceGold.blp", 0, true )

    set goldtext = BlzCreateFrameByType( "TEXT", "", BlzGetOriginFrame( ORIGIN_FRAME_GAME_UI, 0), "StandardFrameTemplate", 0)
    call BlzFrameSetSize( goldtext, 0.03, 0.03 ) 
    call BlzFrameSetAbsPoint( goldtext, FRAMEPOINT_CENTER, 0.543, 0.578 )
    call BlzFrameSetText(goldtext, "0")
    
    set icon = null
endfunction

//===========================================================================
function InitTrig_GoldBar takes nothing returns nothing
    set gg_trg_GoldBar = CreateTrigger(  )
    call TriggerRegisterTimerExpireEventBJ( gg_trg_GoldBar, udg_StartTimer )
    call TriggerAddAction( gg_trg_GoldBar, function Trig_GoldBar_Actions )
endfunction

