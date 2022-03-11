function Trig_PA_EndWork_Actions takes nothing returns nothing
    local integer cyclA 
    local integer i = GetPlayerId(GetOwningPlayer(udg_unit[57])) + 1
    local integer p = GetPlayerId(GetOwningPlayer(udg_unit[58])) + 1
    
    set udg_fightmod[0] = false
    call FightEnd()
    set udg_fightmod[3] = false
    set udg_combatlogic[i] = false
    set udg_combatlogic[p] = false
    call SetUnitPositionLoc( udg_unit[57], udg_point[i + 21])
    call SetUnitFacing( udg_unit[57], 90 )
    call SetUnitPositionLoc(udg_unit[58], udg_point[p + 21])
    call SetUnitFacing(udg_unit[58], 90 )
    call ReviveHeroLoc( udg_unit[57], udg_point[i + 21], true )
    call ReviveHeroLoc( udg_unit[58], udg_point[p + 21], true )
    call PanCameraToTimedLocForPlayer( GetOwningPlayer(udg_unit[57]), udg_point[i + 21], 0 )
    call PanCameraToTimedLocForPlayer( GetOwningPlayer(udg_unit[58]), udg_point[p + 21], 0 )
    call SetPlayerAllianceStateBJ( GetOwningPlayer(udg_unit[57]), GetOwningPlayer(udg_unit[58]), bj_ALLIANCE_ALLIED_VISION )
    call SetPlayerAllianceStateBJ( GetOwningPlayer(udg_unit[58]), GetOwningPlayer(udg_unit[57]), bj_ALLIANCE_ALLIED_VISION )
    if not( udg_logic[43] ) then
        call DisplayTimedTextToPlayer( GetOwningPlayer(udg_unit[57]), 0, 0, 5, "|cffffcc00Attempts available:|r " + I2S(udg_number[i + 69] ) )
        call DisplayTimedTextToPlayer( GetOwningPlayer(udg_unit[58]), 0, 0, 5, "|cffffcc00Attempts available:|r " + I2S(udg_number[p + 69] ) )
    endif
    set udg_logic[62] = false
    call PauseTimer( LoadTimerHandle( udg_hash, GetHandleId( gg_unit_h00A_0034 ), StringHash( "PA" ) ) )
    call TimerDialogDisplay( bj_lastCreatedTimerDialog, false )
    set cyclA = 1
    loop
        exitwhen cyclA > 4
        if GetPlayerSlotState(Player(cyclA - 1)) == PLAYER_SLOT_STATE_PLAYING then
            if udg_logic[43] or ( udg_number[cyclA + 69] > 0 and udg_Heroes_Amount > 1 ) then
                if GetLocalPlayer() == Player(cyclA - 1) then
                    call BlzFrameSetVisible( pvpbk,true)
                endif
            endif
        endif
        set cyclA = cyclA + 1
    endloop
    set udg_unit[57] = null
    set udg_unit[58] = null
endfunction

//===========================================================================
function InitTrig_PA_EndWork takes nothing returns nothing
    set gg_trg_PA_EndWork = CreateTrigger()
    call TriggerAddAction( gg_trg_PA_EndWork, function Trig_PA_EndWork_Actions )
endfunction

