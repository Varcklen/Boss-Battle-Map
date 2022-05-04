globals 
framehandle Background = null 
trigger TriggerBackground = null 
framehandle Aspect0 = null 
 framehandle BackdropAspect0 = null 
trigger TriggerAspect0 = null 
framehandle Aspect1 = null 
 framehandle BackdropAspect1 = null 
trigger TriggerAspect1 = null 
framehandle Aspect2 = null 
 framehandle BackdropAspect2 = null 
trigger TriggerAspect2 = null 
framehandle Aspect3 = null 
 framehandle BackdropAspect3 = null 
trigger TriggerAspect3 = null 
framehandle ChoosedAspect = null 
trigger TriggerChoosedAspect = null 
endglobals 
 
library AspectFrames initializer init 
function Aspect0Func takes nothing returns nothing 
call BlzFrameSetEnable(Aspect0, false) 
call BlzFrameSetEnable(Aspect0, true) 
endfunction 
 
function Aspect1Func takes nothing returns nothing 
call BlzFrameSetEnable(Aspect1, false) 
call BlzFrameSetEnable(Aspect1, true) 
endfunction 
 
function Aspect2Func takes nothing returns nothing 
call BlzFrameSetEnable(Aspect2, false) 
call BlzFrameSetEnable(Aspect2, true) 
endfunction 
 
function Aspect3Func takes nothing returns nothing 
call BlzFrameSetEnable(Aspect3, false) 
call BlzFrameSetEnable(Aspect3, true) 
endfunction 
 
private function init takes nothing returns nothing 


set Background = BlzCreateFrame("CheckListBox", BlzGetFrameByName("ConsoleUIBackdrop", 0),0,0) 
 call BlzFrameSetAbsPoint(Background, FRAMEPOINT_TOPLEFT, 0.00519000, 0.216140) 
 call BlzFrameSetAbsPoint(Background, FRAMEPOINT_BOTTOMRIGHT, 0.184490, 0.164600) 

set Aspect0 = BlzCreateFrame("ScriptDialogButton", Background, 0, 0) 
 call BlzFrameSetAbsPoint(Aspect0, FRAMEPOINT_TOPLEFT, 0.0100000, 0.210000) 
 call BlzFrameSetAbsPoint(Aspect0, FRAMEPOINT_BOTTOMRIGHT, 0.0500100, 0.170000) 
 set BackdropAspect0 = BlzCreateFrameByType("BACKDROP", "BackdropAspect0", Aspect0, "", 1) 
 call BlzFrameSetAllPoints(BackdropAspect0, Aspect0) 
 call BlzFrameSetTexture(BackdropAspect0, "", 0, true) 
set TriggerAspect0 = CreateTrigger() 
 call BlzTriggerRegisterFrameEvent(TriggerAspect0, Aspect0, FRAMEEVENT_CONTROL_CLICK) 
 call TriggerAddAction(TriggerAspect0, function Aspect0Func) 

set Aspect1 = BlzCreateFrame("ScriptDialogButton", Background, 0, 0) 
 call BlzFrameSetAbsPoint(Aspect1, FRAMEPOINT_TOPLEFT, 0.0520100, 0.210000) 
 call BlzFrameSetAbsPoint(Aspect1, FRAMEPOINT_BOTTOMRIGHT, 0.0920200, 0.170000) 
 set BackdropAspect1 = BlzCreateFrameByType("BACKDROP", "BackdropAspect1", Aspect1, "", 1) 
 call BlzFrameSetAllPoints(BackdropAspect1, Aspect1) 
 call BlzFrameSetTexture(BackdropAspect1, "", 0, true) 
set TriggerAspect1 = CreateTrigger() 
 call BlzTriggerRegisterFrameEvent(TriggerAspect1, Aspect1, FRAMEEVENT_CONTROL_CLICK) 
 call TriggerAddAction(TriggerAspect1, function Aspect1Func) 

set Aspect2 = BlzCreateFrame("ScriptDialogButton", Background, 0, 0) 
 call BlzFrameSetAbsPoint(Aspect2, FRAMEPOINT_TOPLEFT, 0.0940200, 0.210000) 
 call BlzFrameSetAbsPoint(Aspect2, FRAMEPOINT_BOTTOMRIGHT, 0.134030, 0.170000) 
 set BackdropAspect2 = BlzCreateFrameByType("BACKDROP", "BackdropAspect2", Aspect2, "", 1) 
 call BlzFrameSetAllPoints(BackdropAspect2, Aspect2) 
 call BlzFrameSetTexture(BackdropAspect2, "", 0, true) 
set TriggerAspect2 = CreateTrigger() 
 call BlzTriggerRegisterFrameEvent(TriggerAspect2, Aspect2, FRAMEEVENT_CONTROL_CLICK) 
 call TriggerAddAction(TriggerAspect2, function Aspect2Func) 

set Aspect3 = BlzCreateFrame("ScriptDialogButton", Background, 0, 0) 
 call BlzFrameSetAbsPoint(Aspect3, FRAMEPOINT_TOPLEFT, 0.136030, 0.210000) 
 call BlzFrameSetAbsPoint(Aspect3, FRAMEPOINT_BOTTOMRIGHT, 0.176040, 0.170000) 
 set BackdropAspect3 = BlzCreateFrameByType("BACKDROP", "BackdropAspect3", Aspect3, "", 1) 
 call BlzFrameSetAllPoints(BackdropAspect3, Aspect3) 
 call BlzFrameSetTexture(BackdropAspect3, "", 0, true) 
set TriggerAspect3 = CreateTrigger() 
 call BlzTriggerRegisterFrameEvent(TriggerAspect3, Aspect3, FRAMEEVENT_CONTROL_CLICK) 
 call TriggerAddAction(TriggerAspect3, function Aspect3Func) 

set ChoosedAspect = BlzCreateFrameByType("BACKDROP", "ChoosedAspect", Background, "", 1) 
 call BlzFrameSetAbsPoint(ChoosedAspect, FRAMEPOINT_TOPLEFT, 0.00980600, 0.211070) 
 call BlzFrameSetAbsPoint(ChoosedAspect, FRAMEPOINT_BOTTOMRIGHT, 0.0498060, 0.170300) 
 call BlzFrameSetTexture(ChoosedAspect, "", 0, true) 
endfunction 
endlibrary
