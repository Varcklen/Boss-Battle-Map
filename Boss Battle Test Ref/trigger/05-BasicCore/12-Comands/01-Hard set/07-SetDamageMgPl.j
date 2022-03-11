function Trig_SetDamageMgPl_Conditions takes nothing returns boolean
    return GetTriggerPlayer() == udg_Host and SubString(GetEventPlayerChatString(), 0, 11) == "-set dmg mg" and SubString(GetEventPlayerChatString(), 0, 15) != "-set dmg mg all" and not( udg_fightmod[0] ) and udg_Boss_LvL == 1 and udg_Heroes_Chanse > 0
endfunction

function Trig_SetDamageMgPl_Actions takes nothing returns nothing
    	local integer i = GetPlayerId( GetTriggerPlayer() ) + 1
    	local integer k = S2I(SubString(GetEventPlayerChatString(), 12, 13))
	local real r = S2I(SubString(GetEventPlayerChatString(), 14, 19)) 

	if k >= 1 and k <= 4 then
		set udg_BossChange = true
    		set udg_BossDamageMagical[k] = (r/100)-1

		if udg_BossDamageMagical[k] < -0.8 then
			set udg_BossDamageMagical[k] = -0.8
		elseif udg_BossDamageMagical[k] > 9 then
			set udg_BossDamageMagical[k] = 9
		endif
            	call DisplayTimedTextToForce( bj_FORCE_ALL_PLAYERS, 10, udg_Player_Color[k] + GetPlayerName(Player(k-1)) + "|r. |cffffcc00Magical damage:|r " + I2S( R2I(((udg_BossDamageMagical[k]+1)*100)) ) + "%." ) 
	else
	        call DisplayTimedTextToForce( GetForceOfPlayer(GetTriggerPlayer()), 10, "The player is not selected correctly." )	
	endif
endfunction

//===========================================================================
function InitTrig_SetDamageMgPl takes nothing returns nothing
    local integer cyclA = 0
    set gg_trg_SetDamageMgPl = CreateTrigger(  )
    loop
        exitwhen cyclA > 3
        call TriggerRegisterPlayerChatEvent( gg_trg_SetDamageMgPl, Player(cyclA), "-set dmg mg", false )
        set cyclA = cyclA + 1
    endloop
    call TriggerAddCondition( gg_trg_SetDamageMgPl, Condition( function Trig_SetDamageMgPl_Conditions ) )
    call TriggerAddAction( gg_trg_SetDamageMgPl, function Trig_SetDamageMgPl_Actions )
endfunction

