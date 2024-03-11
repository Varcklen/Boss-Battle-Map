{
  "Id": 50332282,
  "Comment": "",
  "IsScript": true,
  "RunOnMapInit": false,
  "Script": "globals\r\n    framehandle expbar = null\r\n    framehandle expicon = null\r\n    framehandle expword = null\r\n    framehandle expfon = null\r\n    framehandle expgive = null\r\nendglobals\r\n\r\nfunction Trig_ExpBar_Actions takes nothing returns nothing\r\n    call BlzLoadTOCFile(\"war3mapImported\\\\ExpBar.toc\")//keep?\r\n     \r\n    set expbar = BlzCreateSimpleFrame(\"ExpBarEx\", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), 1)\r\n    call BlzFrameSetAbsPoint(expbar, FRAMEPOINT_CENTER, 0.4, 0.4)\r\n    call BlzFrameSetValue(BlzGetFrameByName(\"ExpBarEx\",1), 0 )\r\n    call BlzFrameSetText(BlzGetFrameByName(\"ExpBarExText\",1), \"\")\r\n    call BlzFrameSetSize(expbar, 0.3, 0.02)\r\n    call BlzFrameSetTexture(expbar, \"Replaceabletextures\\\\Teamcolor\\\\Teamcolor05.blp\", 0, true)\r\n    call BlzFrameSetVisible( expbar, false )\r\n    \r\n    set expicon = BlzCreateFrameByType(\"BACKDROP\", \"\", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), \"\", 0)\r\n    call BlzFrameSetAbsPoint(expicon, FRAMEPOINT_CENTER, 0.56, 0.4)\t\r\n    call BlzFrameSetSize(expicon, 0.018, 0.018)\r\n    call BlzFrameSetLevel( expicon, -1 )\r\n    call BlzFrameSetVisible( expicon, false )\r\n    \r\n    set expgive = BlzCreateFrameByType(\"TEXT\", \"\", expicon, \"StandartFrameTemplate\", 0)\r\n    call BlzFrameSetSize( expgive, 0.18, 0.06 )\r\n    call BlzFrameSetAbsPoint(expgive, FRAMEPOINT_CENTER, 0.35, 0.36)\r\n    call BlzFrameSetText( expgive, \"\" )\r\n    \r\n    set expfon = BlzCreateFrame(\"QuestButtonBaseTemplate\", expicon, 0, 0)\r\n    call BlzFrameSetPoint( expfon, FRAMEPOINT_TOP, expbar, FRAMEPOINT_TOP, 0, -0.013 )\r\n    call BlzFrameSetSize(expfon, 0.2, 0.07)\r\n    call BlzFrameSetVisible( expfon, false )\r\n    \r\n    set expword = BlzCreateFrameByType(\"TEXT\", \"\", expfon, \"StandartFrameTemplate\", 0)\r\n    call BlzFrameSetSize( expword, 0.18, 0.06 )\r\n    call BlzFrameSetPoint( expword, FRAMEPOINT_CENTER, expfon, FRAMEPOINT_CENTER, 0, -0.01 ) \r\n    call BlzFrameSetText( expword, \"\" )\r\nendfunction\r\n\r\n//===========================================================================\r\nfunction InitTrig_ExpBar takes nothing returns nothing\r\n    set gg_trg_ExpBar = CreateTrigger(  )\r\n    call TriggerRegisterTimerExpireEventBJ( gg_trg_ExpBar, udg_StartTimer )\r\n    call TriggerAddAction( gg_trg_ExpBar, function Trig_ExpBar_Actions )\r\nendfunction\r\n\r\n",
  "Events": [],
  "LocalVariables": [],
  "Conditions": [],
  "Actions": []
}