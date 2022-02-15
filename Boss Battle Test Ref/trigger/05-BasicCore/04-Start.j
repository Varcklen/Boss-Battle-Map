function Start2 takes nothing returns nothing
    call DisplayTimedTextToForce( bj_FORCE_ALL_PLAYERS,  15, "|cffffcc00Support us at Patreon:|r www.patreon.com/bbwc3" )
endfunction

function Trig_Start_Actions takes nothing returns nothing
    local integer cyclA
    local integer cyclB
    local integer rand
    local integer array u
    local integer i = GetPlayerId(udg_Host) + 1
    
    call DisableTrigger( GetTriggeringTrigger() )
    
    set cyclA = 0
    loop
        exitwhen cyclA > 3
        if GetPlayerSlotState(Player(cyclA)) == PLAYER_SLOT_STATE_PLAYING then
            call RemoveLocation( udg_Bufer_Zone[cyclA+1])
        endif
        set cyclA = cyclA + 1
    endloop
    
    set udg_Boss_Random = GetRandomInt(1, 5)
    call Init_Multiboard()
    call UnitAddAbility( gg_unit_u00F_0006, 'A03U')
    call SetMapMusicIndexedBJ( "music", 3 )
    call EnableTrigger( gg_trg_TimeGame )
    
    if not(udg_logic[54]) then
    	call TimerStart( udg_timer[1], 120, false, null )
    	set udg_timerdialog[2] = CreateTimerDialog(udg_timer[1])
    	call TimerDialogSetTitle(udg_timerdialog[2], "Start of the battle:" )
    	call TimerDialogDisplay(udg_timerdialog[2], true)
        call PauseTimer(udg_timer[1])
        
        call TimerStart( udg_timer[3], 115, false, null )
        call PauseTimer(udg_timer[3])
    endif
    
    if not(AnyHasLvL(3)) then
        call ShowUnit( gg_unit_h01G_0201, false )
    endif
    if not(AnyHasLvL(4)) then
        call ShowUnit( gg_unit_h00P_0089, false )
    endif
    if not(AnyHasLvL(5)) then
        call ShowUnit(gg_unit_h027_0035, false)
    endif
    if not(AnyHasLvL(5)) then
        set udg_logic[89] = true
    endif
    if AnyHasLvL(2) then
        set udg_LogicModes = true
    endif
    set udg_HeroChooseMode = 2
    call BlzFrameSetVisible( herobut, true )
    set cyclA = 0
    loop
        exitwhen cyclA > 3
        if udg_Host == Player(cyclA) then
            if GetLocalPlayer() == Player(cyclA) then
                call BlzFrameSetVisible( banbut, true )
            endif
            set cyclA = 3
        endif
        set cyclA = cyclA + 1
    endloop

    call TimerStart( CreateTimer(), 25, false, function Start2 )
endfunction

//===========================================================================
function InitTrig_Start takes nothing returns nothing
    set gg_trg_Start = CreateTrigger()
    call TriggerRegisterTimerEvent( gg_trg_Start, 2, false)
    call TriggerAddAction( gg_trg_Start, function Trig_Start_Actions )
endfunction

