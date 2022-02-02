function Trig_Cheatmodgood_Conditions takes nothing returns boolean
    return SubString(GetEventPlayerChatString(), 0, 8) == "-modgood"
endfunction

function Trig_Cheatmodgood_Actions takes nothing returns nothing
    local integer i = S2I(SubString(GetEventPlayerChatString(), 9, 11))
    local integer p
    
	if i > 0 and i <= udg_Database_NumberItems[7] then
		if udg_modgood[i] then
		    set udg_modgood[i] = false
		    call DisplayTimedTextToForce( bj_FORCE_ALL_PLAYERS, 5.00, "Бонус (GOOD) |cffffcc00№" + I2S(i) + "|r выключен." )
            call IconFrameDel( "ModGood" + I2S(i) )
		else
		    set udg_modgood[i] = true
		    call DisplayTimedTextToForce( bj_FORCE_ALL_PLAYERS, 5.00, "Бонус (GOOD) |cffffcc00№" + I2S(i) + "|r активирован." )
            set p = udg_DB_GoodMod[i]
            call IconFrame( "ModGood" + I2S(i), BlzGetAbilityIcon(p), BlzGetAbilityTooltip(p, 0), BlzGetAbilityExtendedTooltip(p, 0) )
		endif
	endif
endfunction

//===========================================================================
function InitTrig_Cheatmodgood takes nothing returns nothing
    local integer cyclA = 0
    set gg_trg_Cheatmodgood = CreateTrigger(  )
    call DisableTrigger( gg_trg_Cheatmodgood )
    loop
        exitwhen cyclA > 3
        call TriggerRegisterPlayerChatEvent( gg_trg_Cheatmodgood, Player(cyclA), "-modgood ", false )
        set cyclA = cyclA + 1
    endloop
    call TriggerAddCondition( gg_trg_Cheatmodgood, Condition( function Trig_Cheatmodgood_Conditions ) )
    call TriggerAddAction( gg_trg_Cheatmodgood, function Trig_Cheatmodgood_Actions )
endfunction

