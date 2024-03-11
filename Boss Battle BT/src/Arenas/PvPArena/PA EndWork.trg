{
  "Id": 50333701,
  "Comment": "",
  "IsScript": true,
  "RunOnMapInit": false,
  "Script": "function Trig_PA_EndWork_Actions takes nothing returns nothing\r\n    local integer cyclA \r\n    local integer i = GetPlayerId(GetOwningPlayer(udg_unit[57])) + 1\r\n    local integer p = GetPlayerId(GetOwningPlayer(udg_unit[58])) + 1\r\n    \r\n    set udg_fightmod[0] = false\r\n    call FightEnd()\r\n    set udg_fightmod[3] = false\r\n    set udg_combatlogic[i] = false\r\n    set udg_combatlogic[p] = false\r\n    call SetUnitPositionLoc( udg_unit[57], udg_point[i + 21])\r\n    call SetUnitFacing( udg_unit[57], 90 )\r\n    call SetUnitPositionLoc(udg_unit[58], udg_point[p + 21])\r\n    call SetUnitFacing(udg_unit[58], 90 )\r\n    call ReviveHeroLoc( udg_unit[57], udg_point[i + 21], true )\r\n    call ReviveHeroLoc( udg_unit[58], udg_point[p + 21], true )\r\n    call PanCameraToTimedLocForPlayer( GetOwningPlayer(udg_unit[57]), udg_point[i + 21], 0 )\r\n    call PanCameraToTimedLocForPlayer( GetOwningPlayer(udg_unit[58]), udg_point[p + 21], 0 )\r\n    call SetPlayerAllianceStateBJ( GetOwningPlayer(udg_unit[57]), GetOwningPlayer(udg_unit[58]), bj_ALLIANCE_ALLIED_VISION )\r\n    call SetPlayerAllianceStateBJ( GetOwningPlayer(udg_unit[58]), GetOwningPlayer(udg_unit[57]), bj_ALLIANCE_ALLIED_VISION )\r\n    if not( udg_logic[43] ) then\r\n        call DisplayTimedTextToPlayer( GetOwningPlayer(udg_unit[57]), 0, 0, 5, \"|cffffcc00Attempts available:|r \" + I2S(udg_number[i + 69] ) )\r\n        call DisplayTimedTextToPlayer( GetOwningPlayer(udg_unit[58]), 0, 0, 5, \"|cffffcc00Attempts available:|r \" + I2S(udg_number[p + 69] ) )\r\n    endif\r\n    set udg_logic[62] = false\r\n    call PauseTimer( LoadTimerHandle( udg_hash, GetHandleId( udg_UNIT_CUTE_BOB ), StringHash( \"PA\" ) ) )\r\n    call TimerDialogDisplay( bj_lastCreatedTimerDialog, false )\r\n    set cyclA = 1\r\n    loop\r\n        exitwhen cyclA > 4\r\n        if GetPlayerSlotState(Player(cyclA - 1)) == PLAYER_SLOT_STATE_PLAYING then\r\n            if udg_logic[43] or ( udg_number[cyclA + 69] > 0 and udg_Heroes_Amount > 1 ) then\r\n                if GetLocalPlayer() == Player(cyclA - 1) then\r\n                    call BlzFrameSetVisible( pvpbk,true)\r\n                endif\r\n            endif\r\n        endif\r\n        set cyclA = cyclA + 1\r\n    endloop\r\n    set udg_unit[57] = null\r\n    set udg_unit[58] = null\r\nendfunction\r\n\r\n//===========================================================================\r\nfunction InitTrig_PA_EndWork takes nothing returns nothing\r\n    set gg_trg_PA_EndWork = CreateTrigger()\r\n    call TriggerAddAction( gg_trg_PA_EndWork, function Trig_PA_EndWork_Actions )\r\nendfunction\r\n\r\n",
  "Events": [],
  "LocalVariables": [],
  "Conditions": [],
  "Actions": []
}