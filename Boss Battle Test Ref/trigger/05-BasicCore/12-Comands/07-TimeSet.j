function Trig_TimeSet_Conditions takes nothing returns boolean
    local integer time = S2I(SubString(GetEventPlayerChatString(), 6, 10))
    return GetTriggerPlayer() == udg_Host and SubString(GetEventPlayerChatString(), 0, 5) == "-time" and ((time >= 60 and time <= 300) or time == 0 ) 
endfunction

function Trig_TimeSet_Actions takes nothing returns nothing
	set udg_real[1] = S2I(SubString(GetEventPlayerChatString(), 6, 10))

    call DisplayTimedTextToForce( bj_FORCE_ALL_PLAYERS, 10, "|cffffcc00Out-of-combat timer set:|r " + I2S( R2I(udg_real[1]) ) + " seconds." )
endfunction

//===========================================================================
function InitTrig_TimeSet takes nothing returns nothing
    local integer cyclA = 0
    set gg_trg_TimeSet = CreateTrigger(  )
    loop
        exitwhen cyclA > 3
        call TriggerRegisterPlayerChatEvent( gg_trg_TimeSet, Player(cyclA), "-time ", false )
        set cyclA = cyclA + 1
    endloop
    call TriggerAddCondition( gg_trg_TimeSet, Condition( function Trig_TimeSet_Conditions ) )
    call TriggerAddAction( gg_trg_TimeSet, function Trig_TimeSet_Actions )
endfunction

