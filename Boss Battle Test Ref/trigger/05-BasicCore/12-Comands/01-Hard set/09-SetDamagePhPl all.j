function Trig_SetDamagePhPl_all_Conditions takes nothing returns boolean
    return GetTriggerPlayer() == udg_Host and SubString(GetEventPlayerChatString(), 0, 15) == "-set dmg ph all" and not( udg_fightmod[0] ) and udg_Boss_LvL == 1 and udg_Heroes_Chanse > 0
endfunction

function Trig_SetDamagePhPl_all_Actions takes nothing returns nothing
    	local integer i = GetPlayerId( GetTriggerPlayer() ) + 1
	local real r = S2I(SubString(GetEventPlayerChatString(), 16, 21)) 
	local integer cyclA = 1

	set udg_BossChange = true
	loop
		exitwhen cyclA > 4
    		set udg_BossDamagePhysical[cyclA] = (r/100)-1
		if udg_BossDamagePhysical[cyclA] < -0.8 then
			set udg_BossDamagePhysical[cyclA] = -0.8
		elseif udg_BossDamagePhysical[cyclA] > 9 then
			set udg_BossDamagePhysical[cyclA] = 9
		endif
		set cyclA = cyclA + 1
	endloop
        call DisplayTimedTextToForce( bj_FORCE_ALL_PLAYERS, 10, "|cffffcc00ALL PLAYERS. Physical damage:|r " + I2S( R2I(r) ) + "%." ) 
endfunction

//===========================================================================
function InitTrig_SetDamagePhPl_all takes nothing returns nothing
    local integer cyclA = 0
    set gg_trg_SetDamagePhPl_all = CreateTrigger(  )
    loop
        exitwhen cyclA > 3
        call TriggerRegisterPlayerChatEvent( gg_trg_SetDamagePhPl_all, Player(cyclA), "-set dmg ph all", false )
        set cyclA = cyclA + 1
    endloop
    call TriggerAddCondition( gg_trg_SetDamagePhPl_all, Condition( function Trig_SetDamagePhPl_all_Conditions ) )
    call TriggerAddAction( gg_trg_SetDamagePhPl_all, function Trig_SetDamagePhPl_all_Actions )
endfunction

