function Trig_Cheatheroes_Actions takes nothing returns nothing
    local integer cyclA = 1

    if GetTriggerPlayer() == udg_cheater then
        call DisplayTimedTextToForce( GetForceOfPlayer(GetTriggerPlayer()), 10., ( "Количество игроков: " + I2S(udg_Heroes_Amount) ) )
        loop
            exitwhen cyclA > 4
            call DisplayTimedTextToForce( GetForceOfPlayer(GetTriggerPlayer()), 10., GetUnitName(udg_hero[cyclA]) )
            set cyclA = cyclA + 1
        endloop
    endif
endfunction

//===========================================================================
function InitTrig_Cheatheroes takes nothing returns nothing
    local integer cyclA = 0
    set gg_trg_Cheatheroes = CreateTrigger(  )
    call DisableTrigger( gg_trg_Cheatheroes )
    loop
        exitwhen cyclA > 3
            call TriggerRegisterPlayerChatEvent( gg_trg_Cheatheroes, Player(cyclA), "-heroes", true )
        set cyclA = cyclA + 1
    endloop
    call TriggerAddAction( gg_trg_Cheatheroes, function Trig_Cheatheroes_Actions )
endfunction

