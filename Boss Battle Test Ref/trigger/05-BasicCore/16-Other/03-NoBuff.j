function Trig_NoBuff_Actions takes nothing returns nothing
    local player i
    local integer cyclA = 1
    
    call DisableTrigger( GetTriggeringTrigger() )
    loop
        exitwhen cyclA > 4
        set i = Player(cyclA - 1)
        if GetPlayerSlotState(i) == PLAYER_SLOT_STATE_PLAYING then
            call SetPlayerAbilityAvailable( i, 'A1A0', false)
            call SetPlayerAbilityAvailable( i, 'A0HX', false)
            call SetPlayerAbilityAvailable( i, 'A0RJ', false)
            call SetPlayerAbilityAvailable( i, 'A0DS', false)
            call SetPlayerAbilityAvailable( i, 'A09T', false)
            call SetPlayerAbilityAvailable( i, 'A05J', false)
            call SetPlayerAbilityAvailable( i, 'A0ZR', false)
            call SetPlayerAbilityAvailable( i, 'A0YE', false)
            call SetPlayerAbilityAvailable( i, 'A0SU', false)
            call SetPlayerAbilityAvailable( i, 'A0GE', false)
            call SetPlayerAbilityAvailable( i, 'A0S4', false)
            call SetPlayerAbilityAvailable( i, 'A0VX', false)
            call SetPlayerAbilityAvailable( i, 'A0U5', false)
            call SetPlayerAbilityAvailable( i, 'A0IU', false)
            call SetPlayerAbilityAvailable( i, 'A0P0', false)
            call SetPlayerAbilityAvailable( i, 'A0O4', false)
            call SetPlayerAbilityAvailable( i, 'A0EA', false)
            call SetPlayerAbilityAvailable( i, 'A0LO', false)
            call SetPlayerAbilityAvailable( i, 'A0K8', false)
            call SetPlayerAbilityAvailable( i, 'A0FU', false)
            call SetPlayerAbilityAvailable( i, 'A0FP', false)
            call SetPlayerAbilityAvailable( i, 'A0DZ', false)
            call SetPlayerAbilityAvailable( i, 'A081', false)
            call SetPlayerAbilityAvailable( i, 'A013', false)
            call SetPlayerAbilityAvailable( i, 'A17I', false)
            call SetPlayerAbilityAvailable( i, 'A17G', false)
            call SetPlayerAbilityAvailable( i, 'A17E', false)
            call SetPlayerAbilityAvailable( i, 'A172', false)
            call SetPlayerAbilityAvailable( i, 'A179', false)
            call SetPlayerAbilityAvailable( i, 'A16S', false)
            call SetPlayerAbilityAvailable( i, 'A16P', false)
            call SetPlayerAbilityAvailable( i, 'A16M', false)
            call SetPlayerAbilityAvailable( i, 'A16I', false)
            call SetPlayerAbilityAvailable( i, 'A162', false)
            call SetPlayerAbilityAvailable( i, 'A15P', false)
            call SetPlayerAbilityAvailable( i, 'A15K', false)
            call SetPlayerAbilityAvailable( i, 'A15A', false)
            call SetPlayerAbilityAvailable( i, 'A152', false)
            call SetPlayerAbilityAvailable( i, 'A14Z', false)
            call SetPlayerAbilityAvailable( i, 'A11W', false)
            call SetPlayerAbilityAvailable( i, 'A11Q', false)
            call SetPlayerAbilityAvailable( i, 'A11H', false)
            call SetPlayerAbilityAvailable( i, 'A103', false)
            call SetPlayerAbilityAvailable( i, 'A0S2', false)
            call SetPlayerAbilityAvailable( i, 'A0PN', false)
            call SetPlayerAbilityAvailable( i, 'A0LT', false)
            call SetPlayerAbilityAvailable( i, 'A0MN', false)
            call SetPlayerAbilityAvailable( i, 'A0KP', false)
            call SetPlayerAbilityAvailable( i, 'A0H0', false)
            call SetPlayerAbilityAvailable( i, 'A0GZ', false)
            call SetPlayerAbilityAvailable( i, 'A0GX', false)
            call SetPlayerAbilityAvailable( i, 'A0EO', false)
            call SetPlayerAbilityAvailable( i, 'A0E1', false)
            call SetPlayerAbilityAvailable( i, 'A0DP', false)
            call SetPlayerAbilityAvailable( i, 'A092', false)
            call SetPlayerAbilityAvailable( i, 'A06V', false)
            call SetPlayerAbilityAvailable( i, 'A07L', false)
            call SetPlayerAbilityAvailable( i, 'A0JS', false)
            call SetPlayerAbilityAvailable( i, 'A07C', false)
            call SetPlayerAbilityAvailable( i, 'A0D5', false)
            call SetPlayerAbilityAvailable( i, 'A090', false)
            call SetPlayerAbilityAvailable( i, 'A0QP', false)
            call SetPlayerAbilityAvailable( i, 'A0QU', false)
            call SetPlayerAbilityAvailable( i, 'A0QQ', false)
            call SetPlayerAbilityAvailable( i, 'A0QU', false)
            call SetPlayerAbilityAvailable( i, 'A0QT', false)
            call SetPlayerAbilityAvailable( i, 'A0K6', false)
            call SetPlayerAbilityAvailable( i, 'A0KN', false)
            call SetPlayerAbilityAvailable( i, 'A0LV', false)
            call SetPlayerAbilityAvailable( i, 'A0L4', false)
            call SetPlayerAbilityAvailable( i, 'A0M2', false)
            call SetPlayerAbilityAvailable( i, 'A0BO', false)
            call SetPlayerAbilityAvailable( i, 'A004', false)
            call SetPlayerAbilityAvailable( i, 'A0BJ', false)
            call SetPlayerAbilityAvailable( i, 'A0MA', false)
            call SetPlayerAbilityAvailable( i, 'A0MR', false)
            call SetPlayerAbilityAvailable( i, 'A0ML', false)
            call SetPlayerAbilityAvailable( i, 'A0CJ', false)
            call SetPlayerAbilityAvailable( i, 'A0N9', false)
            call SetPlayerAbilityAvailable( i, 'A0NJ', false)
            call SetPlayerAbilityAvailable( i, 'A0O6', false)
            call SetPlayerAbilityAvailable( i, 'A0LJ', false)
            call SetPlayerAbilityAvailable( i, 'A0O7', false)
            call SetPlayerAbilityAvailable( i, 'A0PF', false)
            call SetPlayerAbilityAvailable( i, 'A0PG', false)
            call SetPlayerAbilityAvailable( i, 'A0SF', false)
            call SetPlayerAbilityAvailable( i, 'A09X', false)
            call SetPlayerAbilityAvailable( i, 'A0YJ', false)
            call SetPlayerAbilityAvailable( i, 'A0YO', false)
            call SetPlayerAbilityAvailable( i, 'A07U', false)
            call SetPlayerAbilityAvailable( i, 'A07V', false)
            call SetPlayerAbilityAvailable( i, 'A0HZ', false)
            call SetPlayerAbilityAvailable( i, 'A0KE', false)
            call SetPlayerAbilityAvailable( i, 'A0Y2', false)
            call SetPlayerAbilityAvailable( i, 'A0AV', false)
            call SetPlayerAbilityAvailable( i, 'A0PX', false)
            call SetPlayerAbilityAvailable( i, 'A0R2', false)
            call SetPlayerAbilityAvailable( i, 'A0R3', false)
            call SetPlayerAbilityAvailable( i, 'A0GN', false)
            call SetPlayerAbilityAvailable( i, 'A0R9', false)
            call SetPlayerAbilityAvailable( i, 'A0RP', false)
            call SetPlayerAbilityAvailable( i, 'A0S0', false)
            call SetPlayerAbilityAvailable( i, 'A1A1', false)
            call SetPlayerAbilityAvailable( i, 'A1A2', false)
            call SetPlayerAbilityAvailable( i, 'A1A3', false)
            call SetPlayerAbilityAvailable( i, 'A1A4', false)
            call SetPlayerAbilityAvailable( i, 'A0SL', false)
            call SetPlayerAbilityAvailable( i, 'A0T4', false)
            call SetPlayerAbilityAvailable( i, 'A0TD', false)
            call SetPlayerAbilityAvailable( i, 'A0U2', false)
            call SetPlayerAbilityAvailable( i, 'A0U8', false)
            call SetPlayerAbilityAvailable( i, 'A0XU', false)
            call SetPlayerAbilityAvailable( i, 'A0Y0', false)
            call SetPlayerAbilityAvailable( i, 'A0YC', false)
            call SetPlayerAbilityAvailable( i, 'A0B3', false)
            call SetPlayerAbilityAvailable( i, 'A0ZY', false)
            call SetPlayerAbilityAvailable( i, 'A0ZZ', false)
            call SetPlayerAbilityAvailable( i, 'A0BL', false)
            call SetPlayerAbilityAvailable( i, 'A0C4', false)
            call SetPlayerAbilityAvailable( i, 'A0J0', false)
            call SetPlayerAbilityAvailable( i, 'A0L6', false)
            call SetPlayerAbilityAvailable( i, 'A0L9', false)
            call SetPlayerAbilityAvailable( i, 'A0M9', false)
            call SetPlayerAbilityAvailable( i, 'A0MC', false)
            call SetPlayerAbilityAvailable( i, 'A0MO', false)
            call SetPlayerAbilityAvailable( i, 'A0MP', false)
            call SetPlayerAbilityAvailable( i, 'A0N2', false)
            call SetPlayerAbilityAvailable( i, 'A0N4', false)
            call SetPlayerAbilityAvailable( i, 'A08Q', false)
            call SetPlayerAbilityAvailable( i, 'A0C3', false)
            call SetPlayerAbilityAvailable( i, 'A0E7', false)
            call SetPlayerAbilityAvailable( i, 'A0N7', false)
            call SetPlayerAbilityAvailable( i, 'A0O9', false)
            call SetPlayerAbilityAvailable( i, 'A0PE', false)
            call SetPlayerAbilityAvailable( i, 'A0PJ', false)
            call SetPlayerAbilityAvailable( i, 'A0RC', false)
            call SetPlayerAbilityAvailable( i, 'A0RK', false)
            call SetPlayerAbilityAvailable( i, 'A0RL', false)
            call SetPlayerAbilityAvailable( i, 'A05A', false)
            call SetPlayerAbilityAvailable( i, 'A05C', false)
            call SetPlayerAbilityAvailable( i, 'A0SX', false)
            call SetPlayerAbilityAvailable( i, 'A0T3', false)
            call SetPlayerAbilityAvailable( i, 'A0TG', false)
            call SetPlayerAbilityAvailable( i, 'A0TM', false)
            call SetPlayerAbilityAvailable( i, 'A0TW', false)
            call SetPlayerAbilityAvailable( i, 'A0U1', false)
            call SetPlayerAbilityAvailable( i, 'A0UA', false)
            call SetPlayerAbilityAvailable( i, 'A02O', false)
            call SetPlayerAbilityAvailable( i, 'A054', false)
            call SetPlayerAbilityAvailable( i, 'A0TN', false)
            call SetPlayerAbilityAvailable( i, 'A0UP', false)
            call SetPlayerAbilityAvailable( i, 'A0UU', false)
            call SetPlayerAbilityAvailable( i, 'A0UX', false)
            call SetPlayerAbilityAvailable( i, 'A0V3', false)
            call SetPlayerAbilityAvailable( i, 'A0V7', false)
            call SetPlayerAbilityAvailable( i, 'A09H', false)
            call SetPlayerAbilityAvailable( i, 'A0F6', false)
            call SetPlayerAbilityAvailable( i, 'A0QM', false)
            call SetPlayerAbilityAvailable( i, 'A0VE', false)
            call SetPlayerAbilityAvailable( i, 'A0VO', false)
            call SetPlayerAbilityAvailable( i, 'A0VQ', false)
            call SetPlayerAbilityAvailable( i, 'A0HU', false)
            call SetPlayerAbilityAvailable( i, 'A0I5', false)
            call SetPlayerAbilityAvailable( i, 'A0VS', false)
            call SetPlayerAbilityAvailable( i, 'A0VV', false)
            call SetPlayerAbilityAvailable( i, 'A0WL', false) 
            call SetPlayerAbilityAvailable( i, 'A0WO', false)
            call SetPlayerAbilityAvailable( i, 'A0WP', false)
            call SetPlayerAbilityAvailable( i, 'A0WX', false)
            call SetPlayerAbilityAvailable( i, 'A0XG', false)
            call SetPlayerAbilityAvailable( i, 'A0ZU', false)
            call SetPlayerAbilityAvailable( i, 'A11F', false)
            call SetPlayerAbilityAvailable( i, 'A01C', false)
            call SetPlayerAbilityAvailable( i, 'A128', false)
            call SetPlayerAbilityAvailable( i, 'A12N', false)
            call SetPlayerAbilityAvailable( i, 'A12P', false)
            call SetPlayerAbilityAvailable( i, 'A12R', false)
            call SetPlayerAbilityAvailable( i, 'A12V', false)
            call SetPlayerAbilityAvailable( i, 'A13V', false)
            call SetPlayerAbilityAvailable( i, 'A0EE', false)
            call SetPlayerAbilityAvailable( i, 'A031', false)
            call SetPlayerAbilityAvailable( i, 'A03G', false)
            call SetPlayerAbilityAvailable( i, 'A04B', false)
            call SetPlayerAbilityAvailable( i, 'A05X', false)
        endif
        set cyclA = cyclA + 1
    endloop
    
    set i = null
endfunction

//===========================================================================
function InitTrig_NoBuff takes nothing returns nothing
    set gg_trg_NoBuff = CreateTrigger(  )
    call TriggerRegisterTimerEventSingle( gg_trg_NoBuff, 0.50 )
    call TriggerAddAction( gg_trg_NoBuff, function Trig_NoBuff_Actions )
endfunction

