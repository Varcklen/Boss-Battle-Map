function CheatEnable takes nothing returns nothing
    call EnableTrigger( gg_trg_Cheatnext )
    call EnableTrigger( gg_trg_Cheattp )
    call EnableTrigger( gg_trg_Cheatmoney )
    call EnableTrigger( gg_trg_Cheateasy )
    call EnableTrigger( gg_trg_Cheattpboss )
    call EnableTrigger( gg_trg_Cheatcast )
    call EnableTrigger( gg_trg_Cheatheroes )
    call EnableTrigger( gg_trg_Cheatcombat )
    call EnableTrigger( gg_trg_Cheatboss )
    call EnableTrigger( gg_trg_Cheattest )
    call EnableTrigger( gg_trg_Cheatmodgood )
    call EnableTrigger( gg_trg_Cheatmodbad )
    call EnableTrigger( gg_trg_CheatSwap )
    call EnableTrigger( gg_trg_OtherPlayers )
    call EnableTrigger( gg_trg_Exchange )
    call EnableTrigger( gg_trg_Half )
endfunction

function Trig_CheatPas_Actions takes nothing returns nothing
    local integer cyclA = 0

    call DisableTrigger( GetTriggeringTrigger() )
    if GetPlayerName(Player(0)) == "WorldEdit" then
        set udg_logic[0] = true
        loop
            exitwhen cyclA > 3
            if GetPlayerSlotState( Player( cyclA ) ) == PLAYER_SLOT_STATE_PLAYING then
                set udg_cheater = Player( cyclA )
            endif
            set cyclA = cyclA + 1
        endloop
        call CheatEnable()
    endif
endfunction

//===========================================================================
function InitTrig_CheatPas takes nothing returns nothing
    set gg_trg_CheatPas = CreateTrigger(  )
    call TriggerRegisterTimerEvent(gg_trg_CheatPas, 0.1, false)
    call TriggerAddAction( gg_trg_CheatPas, function Trig_CheatPas_Actions )
endfunction

