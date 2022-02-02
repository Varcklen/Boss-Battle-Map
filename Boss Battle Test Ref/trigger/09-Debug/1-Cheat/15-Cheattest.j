function Trig_Cheattest_Actions takes nothing returns nothing
    local integer i = GetPlayerId(GetTriggerPlayer()) + 1
    
    set udg_combatlogic[i] = true
    call moneyst( udg_hero[1], 100000 )
    call EnableTrigger( gg_trg_Cheatactive )
    call SetHeroLevel( udg_hero[i], 20, true )
endfunction

//===========================================================================
function InitTrig_Cheattest takes nothing returns nothing
    local integer cyclA = 0
    set gg_trg_Cheattest = CreateTrigger(  )
    call DisableTrigger( gg_trg_Cheattest )
    loop
        exitwhen cyclA > 3
            call TriggerRegisterPlayerChatEvent( gg_trg_Cheattest, Player(cyclA), "-test", true )
        set cyclA = cyclA + 1
    endloop
    call TriggerAddAction( gg_trg_Cheattest, function Trig_Cheattest_Actions )
endfunction

