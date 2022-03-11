function Trig_SpellSet_Conditions takes nothing returns boolean
    return GetTriggerPlayer() == udg_Host and SubString(GetEventPlayerChatString(), 0, 7) == "-set sp" and not( udg_fightmod[0] ) and udg_Boss_LvL == 1 and udg_Heroes_Chanse > 0
endfunction

function Trig_SpellSet_Actions takes nothing returns nothing
	local real r = S2I(SubString(GetEventPlayerChatString(), 8, 12))

	set udg_BossChange = true
    call SpellPower_SetBossSpellPower(r/100)

    call DisplayTimedTextToForce( bj_FORCE_ALL_PLAYERS, 10, "|cffffcc00Enemy spell power:|r " + I2S( R2I((SpellPower_GetBossSpellPower()*100)) ) + "%." )
endfunction

//===========================================================================
function InitTrig_SpellSet takes nothing returns nothing
    local integer cyclA = 0
    set gg_trg_SpellSet = CreateTrigger(  )
    loop
        exitwhen cyclA > 3
        call TriggerRegisterPlayerChatEvent( gg_trg_SpellSet, Player(cyclA), "-set sp ", false )
        set cyclA = cyclA + 1
    endloop
    call TriggerAddCondition( gg_trg_SpellSet, Condition( function Trig_SpellSet_Conditions ) )
    call TriggerAddAction( gg_trg_SpellSet, function Trig_SpellSet_Actions )
endfunction

