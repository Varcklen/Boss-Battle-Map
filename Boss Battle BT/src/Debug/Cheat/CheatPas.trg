{
  "Id": 50332347,
  "Comment": "",
  "IsScript": true,
  "RunOnMapInit": false,
  "Script": "function CheatEnable takes nothing returns nothing\r\n    call EnableTrigger( gg_trg_Cheatnext )\r\n    call EnableTrigger( gg_trg_Cheattp )\r\n    call EnableTrigger( gg_trg_Cheatmoney )\r\n    call EnableTrigger( gg_trg_Cheateasy )\r\n    call EnableTrigger( gg_trg_Cheattpboss )\r\n    call EnableTrigger( gg_trg_Cheatcast )\r\n    call EnableTrigger( gg_trg_Cheatheroes )\r\n    call EnableTrigger( gg_trg_Cheatcombat )\r\n    call EnableTrigger( gg_trg_Cheatboss )\r\n    call EnableTrigger( gg_trg_Cheattest )\r\n    call EnableTrigger( gg_trg_Cheatmodgood )\r\n    call EnableTrigger( gg_trg_Cheatmodbad )\r\n    call EnableTrigger( gg_trg_CheatSwap )\r\n    call EnableTrigger( gg_trg_CreatePlayers )\r\n    call EnableTrigger( gg_trg_Exchange )\r\n    call EnableTrigger( gg_trg_Half )\r\n    call EnableTrigger( gg_trg_CastRandom )\r\n    call EnableTrigger( gg_trg_ManaReg )\r\n    call EnableTrigger( gg_trg_Cast )\r\n    call EnableTrigger( gg_trg_Refresh )\r\n    call EnableTrigger( gg_trg_CheatLowHp )\r\n    call EnableTrigger( CheatPvPStart )\r\n    call EnableTrigger( CheatKill )\r\n    call EnableTrigger( trig_CheatBuff )\r\n    call EnableTrigger( trig_CheatOutOfCombatTimer )\r\n    call EnableTrigger( trig_CheatSimulateLeaver )\r\nendfunction\r\n\r\nfunction Trig_CheatPas_Actions takes nothing returns nothing\r\n    local integer cyclA = 0\r\n\r\n    call DisableTrigger( GetTriggeringTrigger() )\r\n    if GetPlayerName(Player(0)) == \"WorldEdit\" then\r\n        set udg_logic[0] = true\r\n        loop\r\n            exitwhen cyclA > 3\r\n            if GetPlayerSlotState( Player( cyclA ) ) == PLAYER_SLOT_STATE_PLAYING then\r\n                set udg_cheater = Player( cyclA )\r\n            endif\r\n            set cyclA = cyclA + 1\r\n        endloop\r\n        call CheatEnable()\r\n    endif\r\nendfunction\r\n\r\n//===========================================================================\r\nfunction InitTrig_CheatPas takes nothing returns nothing\r\n    set gg_trg_CheatPas = CreateTrigger(  )\r\n    call TriggerRegisterTimerEvent(gg_trg_CheatPas, 0.1, false)\r\n    call TriggerAddAction( gg_trg_CheatPas, function Trig_CheatPas_Actions )\r\nendfunction\r\n\r\n",
  "Events": [],
  "LocalVariables": [],
  "Conditions": [],
  "Actions": []
}