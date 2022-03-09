globals
    constant integer GAME_STATUS_OFFLINE = 0
    constant integer GAME_STATUS_ONLINE = 1
    constant integer GAME_STATUS_REPLAY = 2
endglobals

function Trig_GameStatus_Actions takes nothing returns nothing
    local integer i

    // Initialize
    
    // Find a playing player. Its Just Works
    set i = 1
    loop
        exitwhen i > 12
        set udg_GameStatus_TempPlayer = Player(i - 1)
        if GetPlayerController(udg_GameStatus_TempPlayer) == MAP_CONTROL_USER and GetPlayerSlotState(udg_GameStatus_TempPlayer) == PLAYER_SLOT_STATE_PLAYING then
            set i = 99
        endif
        set i = i + 1
    endloop
    // Find out the game status
    call CreateNUnitsAtLoc( 1, 'hfoo', udg_GameStatus_TempPlayer, GetPlayerStartLocationLoc(udg_GameStatus_TempPlayer), bj_UNIT_FACING )
    call SelectUnitForPlayerSingle( bj_lastCreatedUnit, udg_GameStatus_TempPlayer )
    if IsUnitSelected(bj_lastCreatedUnit, udg_GameStatus_TempPlayer) then
        if ReloadGameCachesFromDisk() then
            set udg_GameStatus = GAME_STATUS_OFFLINE
        else
            //С этим стоит пользоватся осторожно. Может сломать реплеи
            set udg_GameStatus = GAME_STATUS_REPLAY
        endif
    else
        set udg_GameStatus = GAME_STATUS_ONLINE
    endif
    call RemoveUnit( bj_lastCreatedUnit )
endfunction

//===========================================================================
function InitTrig_GameStatus takes nothing returns nothing
    set gg_trg_GameStatus = CreateTrigger(  )
    call TriggerRegisterTimerEventSingle( gg_trg_GameStatus, 0.00 )
    call TriggerAddAction( gg_trg_GameStatus, function Trig_GameStatus_Actions )
endfunction

