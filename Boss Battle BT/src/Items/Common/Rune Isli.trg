{
  "Id": 50332507,
  "Comment": "",
  "IsScript": true,
  "RunOnMapInit": false,
  "Script": "function Trig_Rune_Isli_Conditions takes nothing returns boolean\r\n    return inv( GetSpellAbilityUnit(), 'I053') > 0\r\nendfunction\r\n\r\nfunction Trig_Rune_Isli_Actions takes nothing returns nothing\r\n    local integer i = GetPlayerId(GetOwningPlayer(GetSpellAbilityUnit())) + 1\r\n    local integer array a\r\n    local boolean array l\r\n    local integer cyclA\r\n    local integer rand\r\n\r\n\tset a[1] = IMaxBJ( 5, Database_Hero_Abilities[1][udg_HeroNum[i]])\r\n\tset a[2] = IMaxBJ( 5, Database_Hero_Abilities[2][udg_HeroNum[i]])\r\n\tset a[3] = IMaxBJ( 5, Database_Hero_Abilities[3][udg_HeroNum[i]])\r\n\tset a[4] = IMaxBJ( 5, Database_Hero_Abilities[4][udg_HeroNum[i]])\r\n\r\n\tset cyclA = 1\r\n\tloop\r\n\t\texitwhen cyclA > 4\r\n\t\tif BlzGetUnitAbilityCooldownRemaining(GetSpellAbilityUnit(),a[cyclA]) > 5 then\r\n\t\t\tset l[cyclA] = true\r\n\t\telse\r\n\t\t\tset l[cyclA] = false\r\n\t\tendif\r\n\t\tset cyclA = cyclA + 1\r\n\tendloop\r\n\r\nif l[1] or l[2] or l[3] or l[4] then\r\n\tset cyclA = 1\r\n\tloop\r\n\t\texitwhen cyclA > 1\r\n\t\tset rand = GetRandomInt( 1, 4 )\r\n\t\tif l[rand] then\r\n    \t\t\tcall BlzStartUnitAbilityCooldown( GetSpellAbilityUnit(), a[rand], RMaxBJ( 5.1,BlzGetUnitAbilityCooldownRemaining(GetSpellAbilityUnit(), a[rand])) - 5 )\r\n\t\telse\r\n\t\t\tset cyclA = cyclA - 1\r\n\t\tendif\r\n\t\tset cyclA = cyclA + 1\r\n\tendloop\r\n\r\n\tif not(udg_logic[i + 26]) then\r\n    \t\tcall SetUnitState( GetSpellAbilityUnit(), UNIT_STATE_MANA, RMaxBJ(0,GetUnitState( GetSpellAbilityUnit(), UNIT_STATE_MANA) - (GetUnitState( GetSpellAbilityUnit(), UNIT_STATE_MAX_MANA)*0.03) ))\r\n\tendif\r\nendif\r\nendfunction\r\n\r\n//===========================================================================\r\nfunction InitTrig_Rune_Isli takes nothing returns nothing\r\n    set gg_trg_Rune_Isli = CreateTrigger(  )\r\n    call TriggerRegisterAnyUnitEventBJ( gg_trg_Rune_Isli, EVENT_PLAYER_UNIT_SPELL_FINISH )\r\n    call TriggerAddCondition( gg_trg_Rune_Isli, Condition( function Trig_Rune_Isli_Conditions ) )\r\n    call TriggerAddAction( gg_trg_Rune_Isli, function Trig_Rune_Isli_Actions )\r\nendfunction\r\n\r\n",
  "Events": [],
  "LocalVariables": [],
  "Conditions": [],
  "Actions": []
}