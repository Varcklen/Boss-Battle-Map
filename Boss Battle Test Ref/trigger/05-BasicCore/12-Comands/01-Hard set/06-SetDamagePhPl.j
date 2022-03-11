function Trig_SetDamagePhPl_Conditions takes nothing returns boolean
    return GetTriggerPlayer() == udg_Host and SubString(GetEventPlayerChatString(), 0, 11) == "-set dmg ph" and GetTriggerPlayer() == udg_Host and SubString(GetEventPlayerChatString(), 0, 15) != "-set dmg ph all" and not( udg_fightmod[0] ) and udg_Boss_LvL == 1 and udg_Heroes_Chanse > 0
endfunction

function Trig_SetDamagePhPl_Actions takes nothing returns nothing
    	local integer i = GetPlayerId( GetTriggerPlayer() ) + 1
    	local integer k = S2I(SubString(GetEventPlayerChatString(), 12, 13))
	local real r = S2I(SubString(GetEventPlayerChatString(), 14, 19)) 

	if k >= 1 and k <= 4 then
		set udg_BossChange = true
    		set udg_BossDamagePhysical[k] = (r/100)-1

		if udg_BossDamagePhysical[k] < -0.8 then
			set udg_BossDamagePhysical[k] = -0.8
		elseif udg_BossDamagePhysical[k] > 9 then
			set udg_BossDamagePhysical[k] = 9
		endif
            	call DisplayTimedTextToForce( bj_FORCE_ALL_PLAYERS, 10, udg_Player_Color[k] + GetPlayerName(Player(k-1)) + "|r. |cffffcc00Physical damage:|r " + I2S( R2I(((udg_BossDamagePhysical[k]+1)*100)) ) + "%." ) 
	else
	        call DisplayTimedTextToForce( GetForceOfPlayer(GetTriggerPlayer()), 10, "The player is not selected correctly." )	
	endif
endfunction

//===========================================================================
function InitTrig_SetDamagePhPl takes nothing returns nothing
    local integer cyclA = 0
    set gg_trg_SetDamagePhPl = CreateTrigger(  )
    loop
        exitwhen cyclA > 3
        call TriggerRegisterPlayerChatEvent( gg_trg_SetDamagePhPl, Player(cyclA), "-set dmg ph", false )
        set cyclA = cyclA + 1
    endloop
    call TriggerAddCondition( gg_trg_SetDamagePhPl, Condition( function Trig_SetDamagePhPl_Conditions ) )
    call TriggerAddAction( gg_trg_SetDamagePhPl, function Trig_SetDamagePhPl_Actions )
endfunction

