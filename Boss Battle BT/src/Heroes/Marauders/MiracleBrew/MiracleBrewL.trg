{
  "Id": 50333135,
  "Comment": "",
  "IsScript": true,
  "RunOnMapInit": false,
  "Script": "function Trig_MiracleBrewL_Conditions takes nothing returns boolean\r\n    return not(LoadBoolean( udg_hash, GetHandleId( GetManipulatedItem() ), StringHash( \"nocrt\" ))) and GetItemType(GetManipulatedItem()) == ITEM_TYPE_POWERUP and inv( GetManipulatingUnit(), GetItemTypeId( GetManipulatedItem() ) ) > 1 and SubString(BlzGetItemDescription(GetManipulatedItem()), 0, 16) == \"|cff088a08Potion\"\r\nendfunction\r\n//and not(udg_logic[74])\r\nfunction Trig_MiracleBrewL_Actions takes nothing returns nothing\r\n    local integer cyclA = 0\r\n    local item it\r\n    local unit c = GetManipulatingUnit()\r\n    local integer lim = 99\r\n    \r\n    loop\r\n        exitwhen cyclA > bj_MAX_INVENTORY\r\n        set it = UnitItemInSlot(c, cyclA)\r\n        if GetManipulatedItem() != it and GetItemTypeId(it) == GetItemTypeId( GetManipulatedItem() ) and BlzGetItemIntegerField(it, ITEM_IF_NUMBER_OF_CHARGES) < lim then\r\n            set cyclA = bj_MAX_INVENTORY\r\n        else\r\n            set it = null\r\n        endif\r\n        set cyclA = cyclA + 1\r\n    endloop\r\n        \r\n    if it != null and not(LoadBoolean( udg_hash, GetHandleId( it ), StringHash( \"nocrt\" ))) then\r\n        call BlzSetItemIntegerFieldBJ( it, ITEM_IF_NUMBER_OF_CHARGES, BlzGetItemIntegerField(it, ITEM_IF_NUMBER_OF_CHARGES) + BlzGetItemIntegerField(GetManipulatedItem(), ITEM_IF_NUMBER_OF_CHARGES) )\r\n        call RemoveItem( GetManipulatedItem() )\r\n    endif\r\n\r\n    set it = null\r\n    set c = null\r\nendfunction\r\n\r\n//===========================================================================\r\nfunction InitTrig_MiracleBrewL takes nothing returns nothing\r\n    set gg_trg_MiracleBrewL = CreateTrigger(  )\r\n    call TriggerRegisterAnyUnitEventBJ( gg_trg_MiracleBrewL, EVENT_PLAYER_UNIT_PICKUP_ITEM )\r\n    call TriggerAddCondition( gg_trg_MiracleBrewL, Condition( function Trig_MiracleBrewL_Conditions ) )\r\n    call TriggerAddAction( gg_trg_MiracleBrewL, function Trig_MiracleBrewL_Actions )\r\nendfunction\r\n\r\n",
  "Events": [],
  "LocalVariables": [],
  "Conditions": [],
  "Actions": []
}