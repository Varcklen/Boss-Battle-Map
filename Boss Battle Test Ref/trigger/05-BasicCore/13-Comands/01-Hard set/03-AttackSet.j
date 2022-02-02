function Trig_AttackSet_Conditions takes nothing returns boolean
    return GetTriggerPlayer() == udg_Host and SubString(GetEventPlayerChatString(), 0, 7) == "-set at" and not( udg_fightmod[0] ) and udg_Boss_LvL == 1 and udg_Heroes_Chanse > 0
endfunction

function Trig_AttackSet_Actions takes nothing returns nothing
	local real r = S2I(SubString(GetEventPlayerChatString(), 8, 12))

	set udg_BossChange = true
    	set udg_BossAT = r/100

	if udg_BossAT < 0.2 then
		set udg_BossHP = 0.2
	elseif udg_BossAT > 10 then
		set udg_BossAT = 10
	endif
        call DisplayTimedTextToForce( bj_FORCE_ALL_PLAYERS, 10, "|cffffcc00Enemy attack power:|r " + I2S( R2I((udg_BossAT*100)) ) + "%." )
endfunction

//===========================================================================
function InitTrig_AttackSet takes nothing returns nothing
    local integer cyclA = 0
    set gg_trg_AttackSet = CreateTrigger(  )
    loop
        exitwhen cyclA > 3
        call TriggerRegisterPlayerChatEvent( gg_trg_AttackSet, Player(cyclA), "-set at ", false )
        set cyclA = cyclA + 1
    endloop
    call TriggerAddCondition( gg_trg_AttackSet, Condition( function Trig_AttackSet_Conditions ) )
    call TriggerAddAction( gg_trg_AttackSet, function Trig_AttackSet_Actions )
endfunction

