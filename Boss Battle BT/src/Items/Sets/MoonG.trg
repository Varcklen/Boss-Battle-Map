{
  "Id": 50332860,
  "Comment": "",
  "IsScript": true,
  "RunOnMapInit": false,
  "Script": "function Trig_MoonG_Conditions takes nothing returns boolean\r\n    if udg_logic[36] then\r\n        return false\r\n    endif\r\n    if not( MoonLogic(GetManipulatedItem()) ) then\r\n        return false\r\n    endif\r\n    return true\r\nendfunction\r\n\r\nfunction Trig_MoonG_Actions takes nothing returns nothing\r\n    local unit n = GetManipulatingUnit()//udg_hero[GetPlayerId(GetOwningPlayer(GetManipulatingUnit())) + 1]\r\n    local integer i = CorrectPlayer(n)//GetPlayerId(GetOwningPlayer(n)) + 1\r\n    local integer cyclA = 0\r\n    local boolean l = LoadBoolean( udg_hash, GetHandleId( n ), StringHash( \"pkblt\" ) )\r\n\r\n    if l and inv(n, 'I03I') > 0 then\r\n        set udg_logic[i + 18] = true\r\n    else\r\n        set udg_Set_Moon_Number[i] = udg_Set_Moon_Number[i] + 1\r\n        if not( udg_logic[i + 18] ) and udg_Set_Moon_Number[i] >= 3 and Multiboard_Condition(i) then\r\n            set udg_logic[i + 18] = true\r\n            call UnitAddAbility( n, 'A04C' )\r\n            call DisplayTimedTextToForce( bj_FORCE_ALL_PLAYERS, 5.00, udg_Player_Color[i] + GetPlayerName(GetOwningPlayer(n)) + \"|r assembled set |cff5858faMoon|r!\" )\r\n            \r\n            call spectime( \"Abilities\\\\Spells\\\\NightElf\\\\Starfall\\\\StarfallCaster.mdl\", GetUnitX(n), GetUnitY(n), 2.5 )\r\n\r\n            call iconon( i,  \"Луна\", \"ReplaceableTextures\\\\PassiveButtons\\\\PASBTNElunesBlessing.blp\" )\r\n        endif\r\n    endif\r\n    \r\n    //call AllSetRing( n, 4, GetManipulatedItem() )\r\n    \r\n    set n = null\r\nendfunction\r\n\r\n//===========================================================================\r\nfunction InitTrig_MoonG takes nothing returns nothing\r\n    set gg_trg_MoonG = CreateTrigger(  )\r\n    call TriggerRegisterAnyUnitEventBJ( gg_trg_MoonG, EVENT_PLAYER_UNIT_PICKUP_ITEM )\r\n    call TriggerAddCondition( gg_trg_MoonG, Condition( function Trig_MoonG_Conditions ) )\r\n    call TriggerAddAction( gg_trg_MoonG, function Trig_MoonG_Actions )\r\nendfunction\r\n\r\n",
  "Events": [],
  "LocalVariables": [],
  "Conditions": [],
  "Actions": []
}