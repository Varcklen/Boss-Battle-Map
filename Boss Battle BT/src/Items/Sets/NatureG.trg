{
  "Id": 50332864,
  "Comment": "",
  "IsScript": true,
  "RunOnMapInit": false,
  "Script": "globals\r\n    real Event_AddNature_Real\r\n    unit Event_AddNature_Hero\r\nendglobals\r\n\r\nfunction Trig_NatureG_Conditions takes nothing returns boolean\r\n    if udg_logic[36] then\r\n        return false\r\n    endif\r\n    if not( NatureLogic(GetManipulatedItem()) ) then\r\n        return false\r\n    endif\r\n    return true\r\nendfunction\r\n\r\nfunction Trig_NatureG_Actions takes nothing returns nothing\r\n    local unit n = GetManipulatingUnit()//udg_hero[GetPlayerId(GetOwningPlayer(GetManipulatingUnit())) + 1]\r\n    local integer i = CorrectPlayer(n)//GetPlayerId(GetOwningPlayer(n)) + 1\r\n    local boolean l = LoadBoolean( udg_hash, GetHandleId( n ), StringHash( \"pkblt\" ) )\r\n    local boolean b = false\r\n    \r\n    if l and inv(n, 'I03I') > 0 then\r\n        set udg_logic[i + 22] = true\r\n        set b = true\r\n    else\r\n        set udg_Set_Nature_Number[i] = udg_Set_Nature_Number[i] + 1\r\n        if not( udg_logic[i + 22] ) and udg_Set_Nature_Number[i] >= 3 and Multiboard_Condition(i) then\r\n            set udg_logic[i + 22] = true\r\n            set b = true\r\n            call DisplayTimedTextToForce( bj_FORCE_ALL_PLAYERS, 5., udg_Player_Color[i] + GetPlayerName(GetOwningPlayer(n)) + \"|r assembled set |cff7cfc00Nature|r!\" )\r\n            call spectime( \"Abilities\\\\Spells\\\\NightElf\\\\Tranquility\\\\Tranquility.mdl\", GetUnitX(n), GetUnitY(n), 2.5 )\r\n            call iconon( i,  \"Природа\", \"war3mapImported\\\\PASSpell_Nature_ResistNature.blp\" )\r\n        endif\r\n    endif\r\n    if b then\r\n        call RessurectionPoints( 2, true )\r\n    endif\r\n    \r\n    set Event_AddNature_Hero = n\r\n    set Event_AddNature_Real = 0.00\r\n    set Event_AddNature_Real = 1.00\r\n    set Event_AddNature_Real = 0.00\r\n    \r\n    //call AllSetRing( n, 5, GetManipulatedItem() )\r\n    \r\n    set n = null\r\nendfunction\r\n\r\n//===========================================================================\r\nfunction InitTrig_NatureG takes nothing returns nothing\r\n    set gg_trg_NatureG = CreateTrigger(  )\r\n    call TriggerRegisterAnyUnitEventBJ( gg_trg_NatureG, EVENT_PLAYER_UNIT_PICKUP_ITEM )\r\n    call TriggerAddCondition( gg_trg_NatureG, Condition( function Trig_NatureG_Conditions ) )\r\n    call TriggerAddAction( gg_trg_NatureG, function Trig_NatureG_Actions )\r\nendfunction\r\n\r\n",
  "Events": [],
  "LocalVariables": [],
  "Conditions": [],
  "Actions": []
}