function Trig_HealthSet_Conditions takes nothing returns boolean
    return GetTriggerPlayer() == udg_Host and SubString(GetEventPlayerChatString(), 0, 7) == "-set hp" and not( udg_fightmod[0] ) and udg_Boss_LvL == 1 and udg_Heroes_Chanse > 0
endfunction

function Trig_HealthSet_Actions takes nothing returns nothing
	local real r = S2I(SubString(GetEventPlayerChatString(), 8, 12))

	set udg_BossChange = true
    	set udg_BossHP = r/100

	if udg_BossHP < 0.2 then
		set udg_BossHP = 0.2
	elseif udg_BossHP > 10 then
		set udg_BossHP = 10
	endif
        call DisplayTimedTextToForce( bj_FORCE_ALL_PLAYERS, 10, "|cffffcc00Enemy health:|r " + I2S( R2I((udg_BossHP*100)) ) + "%." )
endfunction

//===========================================================================
function InitTrig_HealthSet takes nothing returns nothing
    local integer cyclA = 0
    set gg_trg_HealthSet = CreateTrigger(  )
    loop
        exitwhen cyclA > 3
        call TriggerRegisterPlayerChatEvent( gg_trg_HealthSet, Player(cyclA), "-set hp ", false )
        set cyclA = cyclA + 1
    endloop
    call TriggerAddCondition( gg_trg_HealthSet, Condition( function Trig_HealthSet_Conditions ) )
    call TriggerAddAction( gg_trg_HealthSet, function Trig_HealthSet_Actions )
endfunction

