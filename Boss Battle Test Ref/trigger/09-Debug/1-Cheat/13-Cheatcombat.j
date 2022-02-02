function Trig_Cheatcombat_Actions takes nothing returns nothing
    local integer cyclA = 1
    if GetTriggerPlayer() == udg_cheater then
        if udg_combatlogic[1] then
            set udg_combatlogic[1] = false
            call DisplayTimedTextToForce( bj_FORCE_ALL_PLAYERS, 5.00, "Бой выключен." )
            loop
                exitwhen cyclA > 4
                set udg_combatlogic[cyclA] = false
                set cyclA = cyclA + 1
            endloop
        else
            call DisplayTimedTextToForce( bj_FORCE_ALL_PLAYERS, 5.00, "Бой включен." )
            set udg_combatlogic[1] = true
            loop
                exitwhen cyclA > 4
                set udg_combatlogic[cyclA] = true
                set cyclA = cyclA + 1
            endloop
        endif
    endif
endfunction

//===========================================================================
function InitTrig_Cheatcombat takes nothing returns nothing
    local integer cyclA = 0
    set gg_trg_Cheatcombat = CreateTrigger(  )
    call DisableTrigger( gg_trg_Cheatcombat )
    loop
        exitwhen cyclA > 3
        call TriggerRegisterPlayerChatEvent( gg_trg_Cheatcombat, Player(cyclA), "-combat", true )
        set cyclA = cyclA + 1
    endloop
    call TriggerAddAction( gg_trg_Cheatcombat, function Trig_Cheatcombat_Actions )
endfunction

