{
  "Id": 50333500,
  "Comment": "",
  "IsScript": true,
  "RunOnMapInit": false,
  "Script": "globals\r\n    boolean NewbieModeDisabled = false\r\nendglobals\r\n\r\nfunction Trig_Notnew_Conditions takes nothing returns boolean\r\n    return NewbieModeDisabled == false\r\nendfunction\r\n\r\nfunction Trig_Notnew_Actions takes nothing returns nothing\r\n    local integer i = GetPlayerId( GetTriggerPlayer() ) + 1\r\n\r\n    set NewbieModeDisabled = true\r\n    call DisplayTimedTextToForce( bj_FORCE_ALL_PLAYERS, 5, udg_DB_Player_Color[i] + GetPlayerName(GetTriggerPlayer()) + \"|r turned off beginner mode. All shops are available to you.\" )\r\n    call ShowUnit( udg_UNIT_JULE, true )\r\n    call ShowUnit( udg_UNIT_QUARTERMASTER, true )\r\n    call ShowUnit(udg_UNIT_MAGIC_TRANSFORMER, true)\r\nendfunction\r\n\r\n/*function NptnewTip takes nothing returns nothing\r\n    local integer cyclA = 0\r\n    loop\r\n        exitwhen cyclA > 3\r\n        if udg_LvL[cyclA] <= 5 then\r\n            call DisplayTimedTextToPlayer(Player(cyclA), 0, 0, 10, \"*If you want to turn off \\\"beginner mode\\\",\")\r\n            call DisplayTimedTextToPlayer(Player(cyclA), 0, 0, 10, \"type \\\"-notnew\\\" in the chat.\")\r\n        endif\r\n        set cyclA = cyclA + 1\r\n    endloop\r\nendfunction*/\r\n\r\n//===========================================================================\r\nfunction InitTrig_Notnew takes nothing returns nothing\r\n    local integer cyclA = 0\r\n    local trigger trig = CreateTrigger()\r\n    set gg_trg_Notnew = CreateTrigger()\r\n    loop\r\n        exitwhen cyclA > 3\r\n        call TriggerRegisterPlayerChatEvent( gg_trg_Notnew, Player(cyclA), \"-notnew\", true )\r\n        set cyclA = cyclA + 1\r\n    endloop\r\n    call TriggerAddCondition( gg_trg_Notnew, Condition( function Trig_Notnew_Conditions ) )\r\n    call TriggerAddAction( gg_trg_Notnew, function Trig_Notnew_Actions )\r\n    \r\n    /*call TriggerRegisterTimerEvent(trig, 1, false)\r\n    call TriggerAddAction( trig, function NptnewTip )*/\r\n    \r\n    set trig = null\r\nendfunction",
  "Events": [],
  "LocalVariables": [],
  "Conditions": [],
  "Actions": []
}