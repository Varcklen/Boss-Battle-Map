globals 
framehandle InfoBackground = null 
trigger TriggerInfoBackground = null 
framehandle InfoButton = null 
trigger TriggerInfoButton = null 
framehandle InfoPanelName = null 
trigger TriggerInfoPanelName = null 
framehandle InfoPanelDifficulty = null 
trigger TriggerInfoPanelDifficulty = null 
framehandle InfoPanelAuthor = null 
trigger TriggerInfoPanelAuthor = null 
framehandle InfoPanelStat = null 
trigger TriggerInfoPanelStat = null 
framehandle InfoPanelType = null 
trigger TriggerInfoPanelType = null 
framehandle InfoPanelRole = null 
trigger TriggerInfoPanelRole = null 
framehandle InfoPanelStory = null 
trigger TriggerInfoPanelStory = null 
framehandle InfoPanelAspects = null 
trigger TriggerInfoPanelAspects = null 
framehandle InfoPanelNameText = null 
trigger TriggerInfoPanelNameText = null 
framehandle InfoPanelDifficultyText = null 
trigger TriggerInfoPanelDifficultyText = null 
framehandle InfoPanelAuthorText = null 
trigger TriggerInfoPanelAuthorText = null 
framehandle InfoPanelStatText = null 
trigger TriggerInfoPanelStatText = null 
framehandle InfoPanelTypeText = null 
trigger TriggerInfoPanelTypeText = null 
framehandle InfoPanelRoleTextCopy = null 
trigger TriggerInfoPanelRoleTextCopy = null 
framehandle TEMP1 = null 
trigger TriggerTEMP1 = null 
framehandle TEMP2 = null 
trigger TriggerTEMP2 = null 
framehandle TEMP3 = null 
trigger TriggerTEMP3 = null 
endglobals 
 
library HeroTableInfo initializer init 
function InfoButtonFunc takes nothing returns nothing 
call BlzFrameSetEnable(InfoButton, false) 
call BlzFrameSetEnable(InfoButton, true) 
endfunction 
 
private function init takes nothing returns nothing 


set InfoBackground = BlzCreateFrame("QuestButtonBaseTemplate", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0),0,0) 
 call BlzFrameSetAbsPoint(InfoBackground, FRAMEPOINT_TOPLEFT, 0.0159600, 0.552600) 
 call BlzFrameSetAbsPoint(InfoBackground, FRAMEPOINT_BOTTOMRIGHT, 0.366060, 0.235700) 

set InfoButton = BlzCreateFrame("ScriptDialogButton", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0),0,0) 
 call BlzFrameSetAbsPoint(InfoButton, FRAMEPOINT_TOPLEFT, 0.0728900, 0.190050) 
 call BlzFrameSetAbsPoint(InfoButton, FRAMEPOINT_BOTTOMRIGHT, 0.132900, 0.166200) 
 call BlzFrameSetText(InfoButton, "|cffFCD20DInfo|r") 
call BlzFrameSetScale(InfoButton, 1.00) 
 set TriggerInfoButton = CreateTrigger() 
 call BlzTriggerRegisterFrameEvent(TriggerInfoButton, InfoButton, FRAMEEVENT_CONTROL_CLICK) 
 call TriggerAddAction(TriggerInfoButton, function InfoButtonFunc) 

set InfoPanelName = BlzCreateFrameByType("TEXT", "name", InfoBackground, "", 0) 
call BlzFrameSetAbsPoint(InfoPanelName, FRAMEPOINT_TOPLEFT, 0.0259600, 0.538780) 
call BlzFrameSetAbsPoint(InfoPanelName, FRAMEPOINT_BOTTOMRIGHT, 0.0813500, 0.523400) 
call BlzFrameSetText(InfoPanelName, "|cffe1a019Name:|r") 
call BlzFrameSetEnable(InfoPanelName, false) 
call BlzFrameSetScale(InfoPanelName, 1.00) 
call BlzFrameSetTextAlignment(InfoPanelName, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT) 

set InfoPanelDifficulty = BlzCreateFrameByType("TEXT", "name", InfoBackground, "", 0) 
call BlzFrameSetAbsPoint(InfoPanelDifficulty, FRAMEPOINT_TOPLEFT, 0.0259600, 0.517280) 
call BlzFrameSetAbsPoint(InfoPanelDifficulty, FRAMEPOINT_BOTTOMRIGHT, 0.0828900, 0.501900) 
call BlzFrameSetText(InfoPanelDifficulty, "|cffe1a019Difficulty:|r") 
call BlzFrameSetEnable(InfoPanelDifficulty, false) 
call BlzFrameSetScale(InfoPanelDifficulty, 1.00) 
call BlzFrameSetTextAlignment(InfoPanelDifficulty, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT) 

set InfoPanelAuthor = BlzCreateFrameByType("TEXT", "name", InfoBackground, "", 0) 
call BlzFrameSetAbsPoint(InfoPanelAuthor, FRAMEPOINT_TOPLEFT, 0.0275000, 0.493780) 
call BlzFrameSetAbsPoint(InfoPanelAuthor, FRAMEPOINT_BOTTOMRIGHT, 0.0844300, 0.478400) 
call BlzFrameSetText(InfoPanelAuthor, "|cffe1a019Author:|r") 
call BlzFrameSetEnable(InfoPanelAuthor, false) 
call BlzFrameSetScale(InfoPanelAuthor, 1.00) 
call BlzFrameSetTextAlignment(InfoPanelAuthor, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT) 

set InfoPanelStat = BlzCreateFrameByType("TEXT", "name", InfoBackground, "", 0) 
call BlzFrameSetAbsPoint(InfoPanelStat, FRAMEPOINT_TOPLEFT, 0.0275000, 0.469180) 
call BlzFrameSetAbsPoint(InfoPanelStat, FRAMEPOINT_BOTTOMRIGHT, 0.0844300, 0.453800) 
call BlzFrameSetText(InfoPanelStat, "|cffe1a019Main Stat:\n|r") 
call BlzFrameSetEnable(InfoPanelStat, false) 
call BlzFrameSetScale(InfoPanelStat, 1.00) 
call BlzFrameSetTextAlignment(InfoPanelStat, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT) 

set InfoPanelType = BlzCreateFrameByType("TEXT", "name", InfoBackground, "", 0) 
call BlzFrameSetAbsPoint(InfoPanelType, FRAMEPOINT_TOPLEFT, 0.0267300, 0.446080) 
call BlzFrameSetAbsPoint(InfoPanelType, FRAMEPOINT_BOTTOMRIGHT, 0.0836600, 0.430700) 
call BlzFrameSetText(InfoPanelType, "|cffe1a019Type:\n|r") 
call BlzFrameSetEnable(InfoPanelType, false) 
call BlzFrameSetScale(InfoPanelType, 1.00) 
call BlzFrameSetTextAlignment(InfoPanelType, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT) 

set InfoPanelRole = BlzCreateFrameByType("TEXT", "name", InfoBackground, "", 0) 
call BlzFrameSetAbsPoint(InfoPanelRole, FRAMEPOINT_TOPLEFT, 0.0259600, 0.425380) 
call BlzFrameSetAbsPoint(InfoPanelRole, FRAMEPOINT_BOTTOMRIGHT, 0.0828900, 0.410000) 
call BlzFrameSetText(InfoPanelRole, "|cffe1a019Role:\n|r") 
call BlzFrameSetEnable(InfoPanelRole, false) 
call BlzFrameSetScale(InfoPanelRole, 1.00) 
call BlzFrameSetTextAlignment(InfoPanelRole, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT) 

set InfoPanelStory = BlzCreateFrameByType("TEXT", "name", InfoBackground, "", 0) 
call BlzFrameSetAbsPoint(InfoPanelStory, FRAMEPOINT_TOPLEFT, 0.0275000, 0.363080) 
call BlzFrameSetAbsPoint(InfoPanelStory, FRAMEPOINT_BOTTOMRIGHT, 0.0844300, 0.347700) 
call BlzFrameSetText(InfoPanelStory, "|cffe1a019Story:\n|r") 
call BlzFrameSetEnable(InfoPanelStory, false) 
call BlzFrameSetScale(InfoPanelStory, 1.00) 
call BlzFrameSetTextAlignment(InfoPanelStory, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT) 

set InfoPanelAspects = BlzCreateFrameByType("TEXT", "name", InfoBackground, "", 0) 
call BlzFrameSetAbsPoint(InfoPanelAspects, FRAMEPOINT_TOPLEFT, 0.0259600, 0.399980) 
call BlzFrameSetAbsPoint(InfoPanelAspects, FRAMEPOINT_BOTTOMRIGHT, 0.0828900, 0.384600) 
call BlzFrameSetText(InfoPanelAspects, "|cffe1a019Aspects:\n|r") 
call BlzFrameSetEnable(InfoPanelAspects, false) 
call BlzFrameSetScale(InfoPanelAspects, 1.00) 
call BlzFrameSetTextAlignment(InfoPanelAspects, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT) 

set InfoPanelNameText = BlzCreateFrameByType("TEXT", "name", InfoPanelName, "", 0) 
call BlzFrameSetAbsPoint(InfoPanelNameText, FRAMEPOINT_TOPLEFT, 0.0859700, 0.538780) 
call BlzFrameSetAbsPoint(InfoPanelNameText, FRAMEPOINT_BOTTOMRIGHT, 0.272970, 0.523400) 
call BlzFrameSetText(InfoPanelNameText, "|cffFFFFFFSome One|r") 
call BlzFrameSetEnable(InfoPanelNameText, false) 
call BlzFrameSetScale(InfoPanelNameText, 1.00) 
call BlzFrameSetTextAlignment(InfoPanelNameText, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT) 

set InfoPanelDifficultyText = BlzCreateFrameByType("TEXT", "name", InfoPanelDifficulty, "", 0) 
call BlzFrameSetAbsPoint(InfoPanelDifficultyText, FRAMEPOINT_TOPLEFT, 0.0867400, 0.516880) 
call BlzFrameSetAbsPoint(InfoPanelDifficultyText, FRAMEPOINT_BOTTOMRIGHT, 0.273740, 0.501500) 
call BlzFrameSetText(InfoPanelDifficultyText, "|cffFFFFFFEasy\n|r") 
call BlzFrameSetEnable(InfoPanelDifficultyText, false) 
call BlzFrameSetScale(InfoPanelDifficultyText, 1.00) 
call BlzFrameSetTextAlignment(InfoPanelDifficultyText, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT) 

set InfoPanelAuthorText = BlzCreateFrameByType("TEXT", "name", InfoPanelAuthor, "", 0) 
call BlzFrameSetAbsPoint(InfoPanelAuthorText, FRAMEPOINT_TOPLEFT, 0.0867400, 0.493080) 
call BlzFrameSetAbsPoint(InfoPanelAuthorText, FRAMEPOINT_BOTTOMRIGHT, 0.273740, 0.477700) 
call BlzFrameSetText(InfoPanelAuthorText, "|cffFFFFFFMe\n|r") 
call BlzFrameSetEnable(InfoPanelAuthorText, false) 
call BlzFrameSetScale(InfoPanelAuthorText, 1.00) 
call BlzFrameSetTextAlignment(InfoPanelAuthorText, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT) 

set InfoPanelStatText = BlzCreateFrameByType("TEXT", "name", InfoPanelStat, "", 0) 
call BlzFrameSetAbsPoint(InfoPanelStatText, FRAMEPOINT_TOPLEFT, 0.0882800, 0.468480) 
call BlzFrameSetAbsPoint(InfoPanelStatText, FRAMEPOINT_BOTTOMRIGHT, 0.275280, 0.453100) 
call BlzFrameSetText(InfoPanelStatText, "|cffFFFFFFAgility|r") 
call BlzFrameSetEnable(InfoPanelStatText, false) 
call BlzFrameSetScale(InfoPanelStatText, 1.00) 
call BlzFrameSetTextAlignment(InfoPanelStatText, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT) 

set InfoPanelTypeText = BlzCreateFrameByType("TEXT", "name", InfoPanelType, "", 0) 
call BlzFrameSetAbsPoint(InfoPanelTypeText, FRAMEPOINT_TOPLEFT, 0.0890500, 0.446080) 
call BlzFrameSetAbsPoint(InfoPanelTypeText, FRAMEPOINT_BOTTOMRIGHT, 0.276050, 0.430700) 
call BlzFrameSetText(InfoPanelTypeText, "|cffFFFFFFNone|r") 
call BlzFrameSetEnable(InfoPanelTypeText, false) 
call BlzFrameSetScale(InfoPanelTypeText, 1.00) 
call BlzFrameSetTextAlignment(InfoPanelTypeText, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT) 

set InfoPanelRoleTextCopy = BlzCreateFrameByType("TEXT", "name", InfoPanelRole, "", 0) 
call BlzFrameSetAbsPoint(InfoPanelRoleTextCopy, FRAMEPOINT_TOPLEFT, 0.0890500, 0.423880) 
call BlzFrameSetAbsPoint(InfoPanelRoleTextCopy, FRAMEPOINT_BOTTOMRIGHT, 0.276050, 0.408500) 
call BlzFrameSetText(InfoPanelRoleTextCopy, "|cffFFFFFFHealer|r") 
call BlzFrameSetEnable(InfoPanelRoleTextCopy, false) 
call BlzFrameSetScale(InfoPanelRoleTextCopy, 1.00) 
call BlzFrameSetTextAlignment(InfoPanelRoleTextCopy, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT) 

set TEMP1 = BlzCreateFrameByType("BACKDROP", "TEMP1", InfoPanelAspects, "", 1) 
 call BlzFrameSetAbsPoint(TEMP1, FRAMEPOINT_TOPLEFT, 0.0882800, 0.400700) 
 call BlzFrameSetAbsPoint(TEMP1, FRAMEPOINT_BOTTOMRIGHT, 0.118280, 0.370700) 
 call BlzFrameSetTexture(TEMP1, "", 0, true) 

set TEMP2 = BlzCreateFrameByType("BACKDROP", "TEMP2", InfoPanelAspects, "", 1) 
 call BlzFrameSetAbsPoint(TEMP2, FRAMEPOINT_TOPLEFT, 0.124400, 0.399900) 
 call BlzFrameSetAbsPoint(TEMP2, FRAMEPOINT_BOTTOMRIGHT, 0.154400, 0.369900) 
 call BlzFrameSetTexture(TEMP2, "", 0, true) 

set TEMP3 = BlzCreateFrameByType("BACKDROP", "TEMP3", InfoPanelAspects, "", 1) 
 call BlzFrameSetAbsPoint(TEMP3, FRAMEPOINT_TOPLEFT, 0.159800, 0.399200) 
 call BlzFrameSetAbsPoint(TEMP3, FRAMEPOINT_BOTTOMRIGHT, 0.189800, 0.369200) 
 call BlzFrameSetTexture(TEMP3, "", 0, true) 
endfunction 
endlibrary
