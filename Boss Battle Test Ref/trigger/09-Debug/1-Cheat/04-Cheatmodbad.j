function Trig_Cheatmodbad_Conditions takes nothing returns boolean
    return SubString(GetEventPlayerChatString(), 0, 7) == "-modbad"
endfunction

function Trig_Cheatmodbad_Actions takes nothing returns nothing
    local integer i = S2I(SubString(GetEventPlayerChatString(), 8, 10))
    local integer p
    
	if i > 0 and i <= udg_Database_NumberItems[22] then
		if udg_modbad[i] then
		    set udg_modbad[i] = false
		    call DisplayTimedTextToForce( bj_FORCE_ALL_PLAYERS, 5.00, "Бонус (BAD) |cffffcc00№" + I2S(i) + "|r выключен." )
            call IconFrameDel( "ModBad" + I2S(i) )
		else
		    set udg_modbad[i] = true
		    call DisplayTimedTextToForce( bj_FORCE_ALL_PLAYERS, 5.00, "Бонус (BAD) |cffffcc00№" + I2S(i) + "|r активирован." )
            set p = udg_DB_BadMod[i]
            call IconFrame( "ModBad" + I2S(i), BlzGetAbilityIcon(p), BlzGetAbilityTooltip(p, 0), BlzGetAbilityExtendedTooltip(p, 0) )
		endif
	endif
endfunction

//===========================================================================
function InitTrig_Cheatmodbad takes nothing returns nothing
    local integer cyclA = 0
    set gg_trg_Cheatmodbad = CreateTrigger(  )
    call DisableTrigger( gg_trg_Cheatmodbad )
    loop
        exitwhen cyclA > 3
        call TriggerRegisterPlayerChatEvent( gg_trg_Cheatmodbad, Player(cyclA), "-modbad ", false )
        set cyclA = cyclA + 1
    endloop
    call TriggerAddCondition( gg_trg_Cheatmodbad, Condition( function Trig_Cheatmodbad_Conditions ) )
    call TriggerAddAction( gg_trg_Cheatmodbad, function Trig_Cheatmodbad_Actions )
endfunction

