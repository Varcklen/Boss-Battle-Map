{
  "Id": 50332834,
  "Comment": "",
  "IsScript": true,
  "RunOnMapInit": false,
  "Script": "function Trig_RandomBonus_Conditions takes nothing returns boolean\r\n    return BlzGetItemAbility( GetManipulatedItem(), 'A0NN' ) != null\r\nendfunction\r\n\r\nfunction RandomWords takes string s returns string\r\n\tlocal integer cyclA = 0\r\n\tlocal integer cyclAEnd = StringLength(s)\r\n\tlocal integer i = cyclAEnd\r\n    local boolean l = false\r\n    local string str = s\r\n\r\n\tloop\r\n\t\texitwhen cyclA > cyclAEnd\r\n\t\tif SubString(s, cyclAEnd-cyclA, cyclAEnd-cyclA+1) == \"[\" then\r\n\t\t\tset i = cyclAEnd-cyclA\r\n            set l = true\r\n\t\t\tset cyclA = cyclAEnd\r\n\t\tendif\r\n\t\tset cyclA = cyclA + 1\r\n\tendloop\r\n    if l then\r\n        set str = SubString(s, 0, i-10)\r\n    endif\r\n\treturn str\r\nendfunction\r\n\r\nfunction Trig_RandomBonus_Actions takes nothing returns nothing\r\n\tlocal integer cyclA = 1\r\n\tlocal integer cyclB\r\n\tlocal integer cyclBEnd\r\n\tlocal integer array i\r\n\tlocal boolean array l\r\n\tlocal string str = BlzGetItemExtendedTooltip(GetManipulatedItem())\r\n    local integer id = GetHandleId(GetManipulatedItem())\r\n    local integer limit = 5\r\n    local integer current = 1\r\n\r\n    call BlzItemRemoveAbilityBJ( GetManipulatedItem(), 'A0NN' )\r\n    if BlzGetItemAbility( GetManipulatedItem(), 'A0NW' ) != null then\r\n        call BlzItemRemoveAbilityBJ( GetManipulatedItem(), 'A0NW' )\r\n        set current = current + 1\r\n    endif\r\n    if BlzGetItemAbility( GetManipulatedItem(), 'A0OX' ) != null then\r\n        call BlzItemRemoveAbilityBJ( GetManipulatedItem(), 'A0OX' )\r\n        set current = current + 1\r\n    endif\r\n    if inv(GetManipulatingUnit(), 'I01F') > 0 and GetItemTypeId(GetManipulatedItem()) != 'I01F' then\r\n        set current = current + 2\r\n    endif\r\n    \r\n    if current > limit then\r\n        set limit = current\r\n        if limit > udg_Database_NumberItems[25] then\r\n            set limit = udg_Database_NumberItems[25]\r\n        endif\r\n    endif\r\n\r\n    set cyclA = 1\r\n    loop\r\n        exitwhen cyclA > limit\r\n        set i[cyclA] = 0\r\n        set l[cyclA] = false\r\n        set cyclA = cyclA + 1\r\n    endloop\r\n\r\n    set cyclA = 1\r\n    set i[1] = GetRandomInt(1, udg_Database_NumberItems[25])\r\n    loop\r\n        exitwhen cyclA > limit\r\n        set i[cyclA] = GetRandomInt(1, udg_Database_NumberItems[25])\r\n        set cyclB = 1\r\n        set cyclBEnd = cyclA - 1\r\n        loop\r\n            exitwhen cyclB > cyclBEnd\r\n            if i[cyclA] == i[cyclB] then\r\n                set cyclA = cyclA - 1\r\n                set cyclB = cyclBEnd\r\n            endif\r\n            set cyclB = cyclB + 1\r\n        endloop\r\n        set cyclA = cyclA + 1\r\n    endloop\r\n\r\n    set cyclA = 1\r\n    loop\r\n        exitwhen cyclA > limit\r\n        if current >= cyclA then\r\n            call BlzItemAddAbilityBJ( GetManipulatedItem(), udg_RandomBonus[i[cyclA]] )\r\n            set str = RandomWords(str)\r\n            //call BlzSetItemIconPath( GetManipulatedItem(), str )\r\n            call SaveInteger( udg_hash, id, StringHash( \"extra\" + I2S(cyclA) ), i[cyclA] )\r\n            set l[cyclA] = true\r\n        else\r\n            set cyclA = limit\r\n        endif\r\n        set cyclA = cyclA + 1\r\n    endloop\r\n\r\n    set cyclA = 1\r\n    loop\r\n       exitwhen cyclA > limit\r\n        if l[cyclA] then\r\n            set str = str + \"|cff81f260\" + udg_RandomString[i[cyclA]] + \"|r\"\r\n            if cyclA != current then\r\n                set str = str + \"|n\"\r\n            endif\r\n        else\r\n            set cyclA = limit\r\n        endif\r\n        set cyclA = cyclA + 1\r\n    endloop\r\n    call BlzSetItemExtendedTooltip( GetManipulatedItem(), str )  // sadtwig\r\n    //call BlzSetItemIconPath( GetManipulatedItem(), str ) \r\nendfunction\r\n\r\n//===========================================================================\r\nfunction InitTrig_RandomBonus takes nothing returns nothing\r\n\tcall BJDebugMsg(\"InitTrig_RandomBonus\")\r\n    set gg_trg_RandomBonus = CreateTrigger(  )\r\n    call TriggerRegisterAnyUnitEventBJ( gg_trg_RandomBonus, EVENT_PLAYER_UNIT_PICKUP_ITEM )\r\n    call TriggerAddCondition( gg_trg_RandomBonus, Condition( function Trig_RandomBonus_Conditions ) )\r\n    call TriggerAddAction( gg_trg_RandomBonus, function Trig_RandomBonus_Actions )\r\nendfunction",
  "Events": [],
  "LocalVariables": [],
  "Conditions": [],
  "Actions": []
}