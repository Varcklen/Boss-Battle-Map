globals
	framehandle lvltext
endglobals

function Trig_LevelBar_Actions takes nothing returns nothing
    set lvltext = BlzCreateFrameByType( "TEXT", "", BlzGetOriginFrame( ORIGIN_FRAME_GAME_UI, 0), "StandardFrameTemplate", 0)
    call BlzFrameSetSize( lvltext, 0.03, 0.016 ) 
    call BlzFrameSetAbsPoint( lvltext, FRAMEPOINT_CENTER, 0.76, 0.584 )
    call BlzFrameSetText(lvltext, "1/10")
endfunction

//===========================================================================
function InitTrig_LevelBar takes nothing returns nothing
    set gg_trg_LevelBar = CreateTrigger(  )
    call TriggerRegisterTimerExpireEventBJ( gg_trg_LevelBar, udg_StartTimer )
    call TriggerAddAction( gg_trg_LevelBar, function Trig_LevelBar_Actions )
endfunction

