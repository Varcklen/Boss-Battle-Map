{
  "Id": 50332164,
  "Comment": "",
  "IsScript": true,
  "RunOnMapInit": false,
  "Script": "function Trig_SetDamageMgPl_Conditions takes nothing returns boolean\r\n    return GetTriggerPlayer() == udg_Host and SubString(GetEventPlayerChatString(), 0, 11) == \"-set dmg mg\" and SubString(GetEventPlayerChatString(), 0, 15) != \"-set dmg mg all\" and not( udg_fightmod[0] ) and udg_Boss_LvL == 1 and udg_Heroes_Chanse > 0\r\nendfunction\r\n\r\nfunction Trig_SetDamageMgPl_Actions takes nothing returns nothing\r\n    \tlocal integer i = GetPlayerId( GetTriggerPlayer() ) + 1\r\n    \tlocal integer k = S2I(SubString(GetEventPlayerChatString(), 12, 13))\r\n\tlocal real r = S2I(SubString(GetEventPlayerChatString(), 14, 19)) \r\n\r\n\tif k >= 1 and k <= 4 then\r\n\t\tset udg_BossChange = true\r\n    \t\tset udg_BossDamageMagical[k] = (r/100)-1\r\n\r\n\t\tif udg_BossDamageMagical[k] < -0.8 then\r\n\t\t\tset udg_BossDamageMagical[k] = -0.8\r\n\t\telseif udg_BossDamageMagical[k] > 9 then\r\n\t\t\tset udg_BossDamageMagical[k] = 9\r\n\t\tendif\r\n            \tcall DisplayTimedTextToForce( bj_FORCE_ALL_PLAYERS, 10, udg_Player_Color[k] + GetPlayerName(Player(k-1)) + \"|r. |cffffcc00Magical damage:|r \" + I2S( R2I(((udg_BossDamageMagical[k]+1)*100)) ) + \"%.\" ) \r\n\telse\r\n\t        call DisplayTimedTextToForce( GetForceOfPlayer(GetTriggerPlayer()), 10, \"The player is not selected correctly.\" )\t\r\n\tendif\r\nendfunction\r\n\r\n//===========================================================================\r\nfunction InitTrig_SetDamageMgPl takes nothing returns nothing\r\n    local integer cyclA = 0\r\n    set gg_trg_SetDamageMgPl = CreateTrigger(  )\r\n    loop\r\n        exitwhen cyclA > 3\r\n        call TriggerRegisterPlayerChatEvent( gg_trg_SetDamageMgPl, Player(cyclA), \"-set dmg mg\", false )\r\n        set cyclA = cyclA + 1\r\n    endloop\r\n    call TriggerAddCondition( gg_trg_SetDamageMgPl, Condition( function Trig_SetDamageMgPl_Conditions ) )\r\n    call TriggerAddAction( gg_trg_SetDamageMgPl, function Trig_SetDamageMgPl_Actions )\r\nendfunction\r\n\r\n",
  "Events": [],
  "LocalVariables": [],
  "Conditions": [],
  "Actions": []
}