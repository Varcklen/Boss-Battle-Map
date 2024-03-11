{
  "Id": 50332380,
  "Comment": "",
  "IsScript": true,
  "RunOnMapInit": false,
  "Script": "function Trig_Armor_Knight_Conditions takes nothing returns boolean\r\n    return inv(GetManipulatingUnit(), 'I001') > 0 and inv(GetManipulatingUnit(), 'I002') > 0 and inv(GetManipulatingUnit(), 'I000') > 0\r\nendfunction\r\n\r\nfunction Trig_Armor_Knight_Actions takes nothing returns nothing\r\n    local integer i = GetPlayerId(GetOwningPlayer(GetManipulatingUnit())) + 1\r\n    local integer cyclA = 0\r\n    local item it\r\n\r\n    call DestroyEffect( AddSpecialEffectTarget(\"Abilities\\\\Spells\\\\Human\\\\Resurrect\\\\ResurrectCaster.mdl\", GetManipulatingUnit(), \"origin\" ) )\r\n\r\n    loop\r\n        exitwhen cyclA > 3\r\n        if GetPlayerSlotState( Player( cyclA ) ) == PLAYER_SLOT_STATE_PLAYING then\r\n            call DisplayTimedTextToPlayer( Player(cyclA), 0, 0, 10., udg_Player_Color[i] + GetPlayerName(GetOwningPlayer(GetManipulatingUnit())) + \"|r assembled the Knight Armor!\")\r\n        endif\r\n        set cyclA = cyclA + 1\r\n    endloop\r\n    call RemoveItem( GetItemOfTypeFromUnitBJ(GetManipulatingUnit(), 'I002') )\r\n    call RemoveItem( GetItemOfTypeFromUnitBJ(GetManipulatingUnit(), 'I000') )\r\n    call RemoveItem( GetItemOfTypeFromUnitBJ(GetManipulatingUnit(), 'I001') )\r\n    set bj_lastCreatedItem = CreateItem('I003', GetUnitX(GetManipulatingUnit()), GetUnitY(GetManipulatingUnit()))\r\n    call UnitAddItem(GetManipulatingUnit(), bj_lastCreatedItem)\r\n    \r\n    set it = null\r\nendfunction\r\n\r\n//===========================================================================\r\nfunction InitTrig_Armor_Knight takes nothing returns nothing\r\n    set gg_trg_Armor_Knight = CreateTrigger(  )\r\n    call TriggerRegisterAnyUnitEventBJ( gg_trg_Armor_Knight, EVENT_PLAYER_UNIT_PICKUP_ITEM )\r\n    call TriggerAddCondition( gg_trg_Armor_Knight, Condition( function Trig_Armor_Knight_Conditions ) )\r\n    call TriggerAddAction( gg_trg_Armor_Knight, function Trig_Armor_Knight_Actions )\r\nendfunction\r\n\r\n",
  "Events": [],
  "LocalVariables": [],
  "Conditions": [],
  "Actions": []
}