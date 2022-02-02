function Trig_SetHealPl_Conditions takes nothing returns boolean
    return GetTriggerPlayer() == udg_Host and SubString(GetEventPlayerChatString(), 0, 9) == "-set heal" and SubString(GetEventPlayerChatString(), 0, 13) != "-set heal all" and not( udg_fightmod[0] ) and udg_Boss_LvL == 1 and udg_Heroes_Chanse > 0
endfunction

function Trig_SetHealPl_Actions takes nothing returns nothing
    	local integer i = GetPlayerId( GetTriggerPlayer() ) + 1
    	local integer k = S2I(SubString(GetEventPlayerChatString(), 10, 11))
	local real r = S2I(SubString(GetEventPlayerChatString(), 12, 16))

	if k >= 1 and k <= 4 then
		set udg_BossChange = true
    		set udg_BossHeal[k] = r/100

		if udg_BossHeal[k] < 0.2 then
			set udg_BossHeal[k] = 0.2
		elseif udg_BossHeal[k] > 10 then
			set udg_BossHeal[k] = 10
		endif
            	call DisplayTimedTextToForce( bj_FORCE_ALL_PLAYERS, 10, udg_Player_Color[k] + GetPlayerName(Player(k-1)) + "|r. |cffffcc00Health and mana healing:|r " + I2S( R2I((udg_BossHeal[k]*100)) ) + "%." ) 
	else
	        call DisplayTimedTextToForce( GetForceOfPlayer(GetTriggerPlayer()), 10, "The player is not selected correctly." )	
	endif
endfunction

//===========================================================================
function InitTrig_SetHealPl takes nothing returns nothing
    local integer cyclA = 0
    set gg_trg_SetHealPl = CreateTrigger(  )
    loop
        exitwhen cyclA > 3
        call TriggerRegisterPlayerChatEvent( gg_trg_SetHealPl, Player(cyclA), "-set heal ", false )
        set cyclA = cyclA + 1
    endloop
    call TriggerAddCondition( gg_trg_SetHealPl, Condition( function Trig_SetHealPl_Conditions ) )
    call TriggerAddAction( gg_trg_SetHealPl, function Trig_SetHealPl_Actions )
endfunction

