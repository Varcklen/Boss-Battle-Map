function Trig_SetHealPl_all_Conditions takes nothing returns boolean
    return GetTriggerPlayer() == udg_Host and SubString(GetEventPlayerChatString(), 0, 13) == "-set heal all" and not( udg_fightmod[0] ) and udg_Boss_LvL == 1 and udg_Heroes_Chanse > 0
endfunction

function Trig_SetHealPl_all_Actions takes nothing returns nothing
    	local integer i = GetPlayerId( GetTriggerPlayer() ) + 1
	local real r = S2I(SubString(GetEventPlayerChatString(), 14, 19)) 
	local integer cyclA = 1

	set udg_BossChange = true
	loop
		exitwhen cyclA > 4
    		set udg_BossHeal[cyclA] = r/100
		if udg_BossHeal[cyclA] < -0.8 then
			set udg_BossHeal[cyclA] = -0.8
		elseif udg_BossHeal[cyclA] > 9 then
			set udg_BossHeal[cyclA] = 9
		endif
		set cyclA = cyclA + 1
	endloop
        call DisplayTimedTextToForce( bj_FORCE_ALL_PLAYERS, 10, "|cffffcc00ALL PLAYERS. Health and mana healing:|r " + I2S( R2I(r) ) + "%." ) 
endfunction

//===========================================================================
function InitTrig_SetHealPl_all takes nothing returns nothing
    local integer cyclA = 0
    set gg_trg_SetHealPl_all = CreateTrigger(  )
    loop
        exitwhen cyclA > 3
        call TriggerRegisterPlayerChatEvent( gg_trg_SetHealPl_all, Player(cyclA), "-set heal all", false )
        set cyclA = cyclA + 1
    endloop
    call TriggerAddCondition( gg_trg_SetHealPl_all, Condition( function Trig_SetHealPl_all_Conditions ) )
    call TriggerAddAction( gg_trg_SetHealPl_all, function Trig_SetHealPl_all_Actions )
endfunction

