function Trig_Untitled_Trigger_001_Actions takes nothing returns nothing
    call AddLightningLoc( "PISU", GetUnitLoc(gg_unit_hmpr_0001), GetRectCenter(gg_rct_Region_000) )
    call AddLightningLoc( "CLPB", GetUnitLoc(gg_unit_oshm_0010), GetRectCenter(gg_rct_Region_000) )
endfunction

//===========================================================================
function InitTrig_Untitled_Trigger_001 takes nothing returns nothing
    set gg_trg_Untitled_Trigger_001 = CreateTrigger(  )
    call TriggerRegisterPlayerChatEvent( gg_trg_Untitled_Trigger_001, Player(0), "1", true )
    call TriggerAddAction( gg_trg_Untitled_Trigger_001, function Trig_Untitled_Trigger_001_Actions )
endfunction

