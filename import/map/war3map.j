globals
    // User-defined
leaderboard udg_HandleBoard= null

    // Generated
rect gg_rct_Region_000= null
trigger gg_trg_Handle= null
trigger gg_trg_Minion= null
trigger gg_trg_Untitled_Trigger_003= null
trigger gg_trg_Untitled_Trigger_003_Copy= null
trigger gg_trg_Untitled_Trigger_002= null
trigger gg_trg_Untitled_Trigger_001= null
unit gg_unit_hmpr_0001= null
unit gg_unit_oshm_0010= null
unit gg_unit_Hamg_0029= null
unit gg_unit_hrif_0037= null
unit gg_unit_hrif_0038= null


//JASSHelper struct globals:

endglobals


//===========================================================================
// 
// 123123
// 
//   Warcraft III map script
//   Generated by the Warcraft III World Editor
//   Map Author: Unknown
// 
//===========================================================================

//***************************************************************************
//*
//*  Global Variables
//*
//***************************************************************************


function InitGlobals takes nothing returns nothing
endfunction

//***************************************************************************
//*
//*  Custom Script Code
//*
//***************************************************************************

//***************************************************************************
//*
//*  Items
//*
//***************************************************************************

function CreateAllItems takes nothing returns nothing
    local integer itemID

    call BlzCreateItemWithSkin('dsum', - 971.0, - 1087.1, 'dsum')
    call BlzCreateItemWithSkin('penr', - 442.8, - 1107.7, 'penr')
    call BlzCreateItemWithSkin('pmna', - 631.7, - 1102.9, 'pmna')
    call BlzCreateItemWithSkin('rat6', - 1359.6, - 62.8, 'rat6')
    call BlzCreateItemWithSkin('rat6', - 1179.4, - 77.0, 'rat6')
    call BlzCreateItemWithSkin('rat6', - 1250.0, - 239.2, 'rat6')
    call BlzCreateItemWithSkin('ratc', 13.1, - 1144.6, 'ratc')
    call BlzCreateItemWithSkin('spsh', - 811.4, - 1104.1, 'spsh')
    call BlzCreateItemWithSkin('tgrh', - 394.8, - 1365.9, 'tgrh')
    call BlzCreateItemWithSkin('tgrh', - 149.8, - 1384.3, 'tgrh')
    call BlzCreateItemWithSkin('tgrh', - 860.5, - 1349.7, 'tgrh')
    call BlzCreateItemWithSkin('tgrh', - 631.4, - 1365.9, 'tgrh')
    call BlzCreateItemWithSkin('tgrh', - 1016.3, - 1354.3, 'tgrh')
    call BlzCreateItemWithSkin('ward', - 216.1, - 1131.6, 'ward')
endfunction

//***************************************************************************
//*
//*  Unit Creation
//*
//***************************************************************************

//===========================================================================
function CreateUnitsForPlayer0 takes nothing returns nothing
    local player p= Player(0)
    local unit u
    local integer unitID
    local trigger t
    local real life

    set u=BlzCreateUnitWithSkin(p, 'hmpr', - 408.3, 39.6, 290.476, 'hmpr')
    set u=BlzCreateUnitWithSkin(p, 'hmpr', - 170.5, 24.3, 273.116, 'hmpr')
    set u=BlzCreateUnitWithSkin(p, 'hmpr', 128.2, 3.0, 249.856, 'hmpr')
    set u=BlzCreateUnitWithSkin(p, 'hmtm', - 239.7, - 495.6, 310.968, 'hmtm')
    set u=BlzCreateUnitWithSkin(p, 'hmtm', - 104.3, - 463.4, 291.182, 'hmtm')
    set u=BlzCreateUnitWithSkin(p, 'hmtm', 146.4, - 516.2, 247.511, 'hmtm')
    set u=BlzCreateUnitWithSkin(p, 'uban', 135.8, 235.7, 230.962, 'uban')
    set u=BlzCreateUnitWithSkin(p, 'uban', - 49.9, 325.7, 82.675, 'uban')
    set u=BlzCreateUnitWithSkin(p, 'oshm', - 224.3, 401.0, 250.760, 'oshm')
    set u=BlzCreateUnitWithSkin(p, 'oshm', - 414.9, 409.8, 161.779, 'oshm')
    set u=BlzCreateUnitWithSkin(p, 'Otch', - 866.9, - 176.3, 314.141, 'Otch')
    set u=BlzCreateUnitWithSkin(p, 'Otch', - 765.7, 71.0, 304.265, 'Otch')
    set u=BlzCreateUnitWithSkin(p, 'Otch', - 665.6, - 114.9, 189.575, 'Otch')
    set u=BlzCreateUnitWithSkin(p, 'Hpal', - 1569.2, - 386.6, 272.233, 'Hpal')
    set u=BlzCreateUnitWithSkin(p, 'Hpal', - 1422.0, - 397.4, 270.064, 'Hpal')
    set u=BlzCreateUnitWithSkin(p, 'Hpal', - 1709.9, - 386.6, 267.149, 'Hpal')
    set u=BlzCreateUnitWithSkin(p, 'Ofar', - 591.2, - 633.4, 176.325, 'Ofar')
    set u=BlzCreateUnitWithSkin(p, 'Ofar', - 761.4, - 676.7, 304.012, 'Ofar')
    set u=BlzCreateUnitWithSkin(p, 'Ofar', - 889.5, - 709.3, 148.573, 'Ofar')
    set u=BlzCreateUnitWithSkin(p, 'hrif', 574.6, - 321.1, 258.410, 'hrif')
    set u=BlzCreateUnitWithSkin(p, 'hrif', 550.0, - 114.9, 267.027, 'hrif')
    set u=BlzCreateUnitWithSkin(p, 'hrif', 864.9, - 263.4, 220.516, 'hrif')
    set u=BlzCreateUnitWithSkin(p, 'hkni', 585.9, - 622.5, 287.071, 'hkni')
    set u=BlzCreateUnitWithSkin(p, 'hkni', 855.5, - 634.3, 12.843, 'hkni')
    set u=BlzCreateUnitWithSkin(p, 'hkni', 772.9, - 869.8, 211.120, 'hkni')
    set u=BlzCreateUnitWithSkin(p, 'hfoo', - 366.1, - 780.9, 353.869, 'hfoo')
    set u=BlzCreateUnitWithSkin(p, 'hfoo', - 268.1, - 729.6, 281.876, 'hfoo')
    set u=BlzCreateUnitWithSkin(p, 'hfoo', - 152.3, - 824.9, 254.209, 'hfoo')
    set gg_unit_Hamg_0029=BlzCreateUnitWithSkin(p, 'Hamg', - 1818.6, 321.4, 325.360, 'Hamg')
    call UnitAddItemToSlotById(gg_unit_Hamg_0029, 'rde4', 0)
    set u=BlzCreateUnitWithSkin(p, 'hrif', - 1755.2, - 105.1, 200.067, 'hrif')
    set gg_unit_hrif_0037=BlzCreateUnitWithSkin(p, 'hrif', - 2141.6, - 231.6, 255.804, 'hrif')
    set gg_unit_hrif_0038=BlzCreateUnitWithSkin(p, 'hrif', - 2380.6, - 232.0, 294.891, 'hrif')
    set u=BlzCreateUnitWithSkin(p, 'Emoo', 290.5, - 246.7, 276.084, 'Emoo')
    set u=BlzCreateUnitWithSkin(p, 'hkni', 484.3, - 891.9, 278.283, 'hkni')
    set u=BlzCreateUnitWithSkin(p, 'hspt', 150.8, - 1165.0, 234.532, 'hspt')
    set u=BlzCreateUnitWithSkin(p, 'hspt', 327.2, - 1258.5, 260.878, 'hspt')
    set u=BlzCreateUnitWithSkin(p, 'hspt', 281.3, - 1371.5, 181.939, 'hspt')
    set u=BlzCreateUnitWithSkin(p, 'hmpr', 878.9, - 1355.9, 280.443, 'hmpr')
    set u=BlzCreateUnitWithSkin(p, 'hmpr', 1157.6, - 1185.1, 100.495, 'hmpr')
    set u=BlzCreateUnitWithSkin(p, 'hmpr', 1322.0, - 1270.0, 354.781, 'hmpr')
    set u=BlzCreateUnitWithSkin(p, 'Nkjx', 112.8, - 825.1, 277.710, 'Nkjx')
endfunction

//===========================================================================
function CreatePlayerBuildings takes nothing returns nothing
endfunction

//===========================================================================
function CreatePlayerUnits takes nothing returns nothing
    call CreateUnitsForPlayer0()
endfunction

//===========================================================================
function CreateAllUnits takes nothing returns nothing
    call CreatePlayerBuildings()
    call CreateUnitsForPlayer0() // INLINED!!
endfunction

//***************************************************************************
//*
//*  Regions
//*
//***************************************************************************

function CreateRegions takes nothing returns nothing
    local weathereffect we

    set gg_rct_Region_000=Rect(- 128.0, - 224.0, 32.0, - 64.0)
endfunction

//***************************************************************************
//*
//*  Triggers
//*
//***************************************************************************

//===========================================================================
// Trigger: Handle
//===========================================================================
function HandleCounter_Update takes nothing returns nothing
   local integer i= 0
   local integer id
   local location array P
   local real result=0
   loop
      exitwhen i >= 50
      set i=i + 1
      set P[i]=Location(0, 0)
      set id=GetHandleId(P[i])
      set result=result + ( id - 0x100000 )
   endloop
   set result=result / i - i / 2
   loop
      call RemoveLocation(P[i])
      set P[i]=null
      exitwhen i <= 1
      set i=i - 1
   endloop
   call LeaderboardSetItemValue(udg_HandleBoard, 0, R2I(result))
endfunction

function HandleCounter_Actions takes nothing returns nothing
   set udg_HandleBoard=CreateLeaderboard()
   call LeaderboardSetLabel(udg_HandleBoard, "Handle Counter")
   call PlayerSetLeaderboard(GetLocalPlayer(), udg_HandleBoard)
   call LeaderboardDisplay(udg_HandleBoard, true)
   call LeaderboardAddItem(udg_HandleBoard, "Handles", 0, Player(0))
   call LeaderboardSetSizeByItemCount(udg_HandleBoard, 1)
   call HandleCounter_Update()
   call TimerStart(GetExpiredTimer(), 0.05, true, function HandleCounter_Update)
endfunction

function InitTrig_HandleCounter takes nothing returns nothing
   call TimerStart(CreateTimer(), 0, false, function HandleCounter_Actions)
endfunction

function Trig_Handle_Actions takes nothing returns nothing
    call TimerStart(CreateTimer(), 0, false, function HandleCounter_Actions) // INLINED!!
endfunction

//===========================================================================
function InitTrig_Handle takes nothing returns nothing
    set gg_trg_Handle=CreateTrigger()
    call TriggerAddAction(gg_trg_Handle, function Trig_Handle_Actions)
endfunction


//===========================================================================
// Trigger: Untitled Trigger 003
//===========================================================================
function Test1 takes unit u returns nothing
endfunction

function Trig_Untitled_Trigger_003_Actions takes nothing returns nothing
    call Test1(gg_unit_Hamg_0029)
endfunction

//===========================================================================
function InitTrig_Untitled_Trigger_003 takes nothing returns nothing
    set gg_trg_Untitled_Trigger_003=CreateTrigger()
    call TriggerRegisterPlayerChatEvent(gg_trg_Untitled_Trigger_003, Player(0), "1", true)
    call TriggerAddAction(gg_trg_Untitled_Trigger_003, function Trig_Untitled_Trigger_003_Actions)
endfunction


//===========================================================================
// Trigger: Untitled Trigger 003 Copy
//===========================================================================
function Test2 takes unit u returns nothing

    set u=null
endfunction

function Trig_Untitled_Trigger_003_Copy_Actions takes nothing returns nothing
    call Test2(gg_unit_Hamg_0029)
endfunction

//===========================================================================
function InitTrig_Untitled_Trigger_003_Copy takes nothing returns nothing
    set gg_trg_Untitled_Trigger_003_Copy=CreateTrigger()
    call TriggerRegisterPlayerChatEvent(gg_trg_Untitled_Trigger_003_Copy, Player(0), "2", true)
    call TriggerAddAction(gg_trg_Untitled_Trigger_003_Copy, function Trig_Untitled_Trigger_003_Copy_Actions)
endfunction

//===========================================================================
// Trigger: Untitled Trigger 002
//===========================================================================
function Trig_Untitled_Trigger_002_Actions takes nothing returns nothing
    call AddSpecialEffectLocBJ(GetUnitLoc(gg_unit_hrif_0038), "war3mapImported\\Longevity Aura Crimson.mdx")
    call AddSpecialEffectLocBJ(GetUnitLoc(gg_unit_hrif_0037), "war3mapImported\\Longevity Aura Spring.mdx")
endfunction

//===========================================================================
function InitTrig_Untitled_Trigger_002 takes nothing returns nothing
    set gg_trg_Untitled_Trigger_002=CreateTrigger()
    call TriggerRegisterPlayerChatEvent(gg_trg_Untitled_Trigger_002, Player(0), "1", true)
    call TriggerAddAction(gg_trg_Untitled_Trigger_002, function Trig_Untitled_Trigger_002_Actions)
endfunction

//===========================================================================
function InitCustomTriggers takes nothing returns nothing
    call InitTrig_Handle()
    call InitTrig_Untitled_Trigger_003()
    call InitTrig_Untitled_Trigger_003_Copy()
    call InitTrig_Untitled_Trigger_002()
endfunction

//===========================================================================
function RunInitializationTriggers takes nothing returns nothing
    call ConditionalTriggerExecute(gg_trg_Handle)
endfunction

//***************************************************************************
//*
//*  Upgrades
//*
//***************************************************************************

function InitUpgrades_Player0 takes nothing returns nothing
    call SetPlayerTechResearched(Player(0), 'Rost', 2)
    call SetPlayerTechResearched(Player(0), 'Rune', 2)
    call SetPlayerTechResearched(Player(0), 'Ruba', 2)
endfunction

function InitUpgrades takes nothing returns nothing
    call InitUpgrades_Player0()
endfunction

//***************************************************************************
//*
//*  Players
//*
//***************************************************************************

function InitCustomPlayerSlots takes nothing returns nothing

    // Player 0
    call SetPlayerStartLocation(Player(0), 0)
    call SetPlayerColor(Player(0), ConvertPlayerColor(0))
    call SetPlayerRacePreference(Player(0), RACE_PREF_HUMAN)
    call SetPlayerRaceSelectable(Player(0), true)
    call SetPlayerController(Player(0), MAP_CONTROL_USER)

endfunction

function InitCustomTeams takes nothing returns nothing
    // Force: TRIGSTR_002
    call SetPlayerTeam(Player(0), 0)

endfunction

//***************************************************************************
//*
//*  Main Initialization
//*
//***************************************************************************

//===========================================================================
function main takes nothing returns nothing
    call SetCameraBounds(- 3328.0 + GetCameraMargin(CAMERA_MARGIN_LEFT), - 3584.0 + GetCameraMargin(CAMERA_MARGIN_BOTTOM), 3328.0 - GetCameraMargin(CAMERA_MARGIN_RIGHT), 3072.0 - GetCameraMargin(CAMERA_MARGIN_TOP), - 3328.0 + GetCameraMargin(CAMERA_MARGIN_LEFT), 3072.0 - GetCameraMargin(CAMERA_MARGIN_TOP), 3328.0 - GetCameraMargin(CAMERA_MARGIN_RIGHT), - 3584.0 + GetCameraMargin(CAMERA_MARGIN_BOTTOM))
    call SetDayNightModels("Environment\\DNC\\DNCLordaeron\\DNCLordaeronTerrain\\DNCLordaeronTerrain.mdl", "Environment\\DNC\\DNCLordaeron\\DNCLordaeronUnit\\DNCLordaeronUnit.mdl")
    call NewSoundEnvironment("Default")
    call SetAmbientDaySound("LordaeronSummerDay")
    call SetAmbientNightSound("LordaeronSummerNight")
    call SetMapMusic("Music", true, 0)
    call CreateRegions()
    call InitUpgrades_Player0() // INLINED!!
    call CreateAllItems()
    call CreateAllUnits()
    call InitBlizzard()


    call InitGlobals()
    call InitCustomTriggers()
    call ConditionalTriggerExecute(gg_trg_Handle) // INLINED!!

endfunction

//***************************************************************************
//*
//*  Map Configuration
//*
//***************************************************************************

function config takes nothing returns nothing
    call SetMapName("123123")
    call SetMapDescription("Nondescript")
    call SetPlayers(1)
    call SetTeams(1)
    call SetGamePlacement(MAP_PLACEMENT_USE_MAP_SETTINGS)

    call DefineStartLocation(0, - 1088.0, 576.0)

    // Player setup
    call InitCustomPlayerSlots()
    call SetPlayerSlotAvailable(Player(0), MAP_CONTROL_USER)
    call InitGenericPlayerSlots()
endfunction




//Struct method generated initializers/callers:

