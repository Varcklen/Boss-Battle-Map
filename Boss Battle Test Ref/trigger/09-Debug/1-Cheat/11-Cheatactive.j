function Trig_Cheatactive_Actions takes nothing returns nothing
    local integer i = GetPlayerId(GetTriggerPlayer()) + 1
    
    if GetTriggerPlayer() == udg_cheater  then
        call coldstop( udg_hero[1] )
        call coldstop( udg_hero[2] )
        call coldstop( udg_hero[3] )
        call coldstop( udg_hero[4] )
        call SetUnitState( udg_hero[i], UNIT_STATE_MANA, GetUnitState(udg_hero[i], UNIT_STATE_MAX_MANA) )
    endif
endfunction

//===========================================================================
function InitTrig_Cheatactive takes nothing returns nothing
    local integer cyclA = 0
    set gg_trg_Cheatactive = CreateTrigger(  )
    call DisableTrigger( gg_trg_Cheatactive )
    loop
        exitwhen cyclA > 3
            call TriggerRegisterPlayerEvent( gg_trg_Cheatactive, Player(cyclA), EVENT_PLAYER_ARROW_UP_DOWN)
        set cyclA = cyclA + 1
    endloop
    call TriggerAddAction( gg_trg_Cheatactive, function Trig_Cheatactive_Actions )
endfunction

