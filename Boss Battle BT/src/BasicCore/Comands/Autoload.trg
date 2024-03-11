{
  "Id": 50332175,
  "Comment": "",
  "IsScript": true,
  "RunOnMapInit": false,
  "Script": "function Trig_Autoload_Conditions takes nothing returns boolean\r\n    return not( udg_logic[43] ) and not(udg_logic[1])\r\nendfunction\r\n\r\nfunction AutoloadCast takes nothing returns nothing\r\n    local integer id = GetHandleId( GetExpiredTimer() )\r\n    local integer i = LoadInteger( udg_hash, id, StringHash( \"auto\" ) )\r\n\r\n    call LoadProgress( i, \"\" )\r\n    call BonusLoad(i)\r\n    call FlushChildHashtable( udg_hash, id )\r\nendfunction\r\n\r\nfunction Trig_Autoload_Actions takes nothing returns nothing\r\n    local integer i = GetPlayerId(GetTriggerPlayer()) + 1\r\n    local integer id = GetHandleId( GetTriggerPlayer() )\r\n    \r\n    call Preloader(\"BossBattleSave\\\\Boss Battle Progress.txt\")\r\n    \r\n    if LoadTimerHandle( udg_hash, id, StringHash( \"auto\" ) ) == null  then\r\n        call SaveTimerHandle( udg_hash, id, StringHash( \"auto\" ), CreateTimer() )\r\n    endif\r\n\tset id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( \"auto\" ) ) ) \r\n    call SaveInteger( udg_hash, id, StringHash( \"auto\" ), i )\r\n\tcall TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetTriggerPlayer() ), StringHash( \"auto\" ) ), 0.5, false, function AutoloadCast )\r\nendfunction\r\n\r\n//===========================================================================\r\nfunction InitTrig_Autoload takes nothing returns nothing\r\n    local integer cyclA = 0\r\n    set gg_trg_Autoload = CreateTrigger()\r\n    loop\r\n        exitwhen cyclA > 3\r\n        call TriggerRegisterPlayerChatEvent( gg_trg_Autoload, Player(cyclA), \"-autoload\", true )\r\n        set cyclA = cyclA + 1\r\n    endloop\r\n    call TriggerAddCondition( gg_trg_Autoload, Condition( function Trig_Autoload_Conditions ) )\r\n    call TriggerAddAction( gg_trg_Autoload, function Trig_Autoload_Actions )\r\nendfunction",
  "Events": [],
  "LocalVariables": [],
  "Conditions": [],
  "Actions": []
}