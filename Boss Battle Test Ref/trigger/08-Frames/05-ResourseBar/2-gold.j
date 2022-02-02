function Trig_gold_Actions takes nothing returns nothing
	local real i
	local integer k = GetConvertedPlayerId(GetTriggerPlayer())
	if GetLocalPlayer() == GetTriggerPlayer() then
		set goldstr[k] = I2S(GetPlayerState(GetTriggerPlayer(), PLAYER_STATE_RESOURCE_GOLD))
		set i = StringLength(goldstr[k]) * 0.004
		call BlzFrameSetText(goldtext, goldstr[k])
		call BlzFrameSetAbsPoint( goldtext, FRAMEPOINT_CENTER, 0.547 - i, 0.578 )
	endif
endfunction

//===========================================================================
function InitTrig_gold takes nothing returns nothing
    set gg_trg_gold = CreateTrigger(  )
    call TriggerRegisterPlayerStateEvent( gg_trg_gold, Player(0), PLAYER_STATE_RESOURCE_GOLD, NOT_EQUAL, 0.01 )
	call TriggerRegisterPlayerStateEvent( gg_trg_gold, Player(1), PLAYER_STATE_RESOURCE_GOLD, NOT_EQUAL, 0.01 )
call TriggerRegisterPlayerStateEvent( gg_trg_gold, Player(2), PLAYER_STATE_RESOURCE_GOLD, NOT_EQUAL, 0.01 )
call TriggerRegisterPlayerStateEvent( gg_trg_gold, Player(3), PLAYER_STATE_RESOURCE_GOLD, NOT_EQUAL, 0.01 )
    call TriggerAddAction( gg_trg_gold, function Trig_gold_Actions )
endfunction

