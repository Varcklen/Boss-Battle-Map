{
  "Id": 50333205,
  "Comment": "",
  "IsScript": true,
  "RunOnMapInit": false,
  "Script": "function Trig_ChaosLordR_Conditions takes nothing returns boolean\r\n    return GetSpellAbilityId() == 'A0IZ' and combat( GetSpellAbilityUnit(), true, GetSpellAbilityId() )\r\nendfunction\r\n\r\nfunction Trig_ChaosLordR_Actions takes nothing returns nothing\r\n    local integer lvl\r\n    local unit caster\r\n    \r\n    if CastLogic() then\r\n        set caster = udg_Caster\r\n        set lvl = udg_Level\r\n    elseif RandomLogic() then\r\n        set caster = udg_Caster\r\n        set lvl = udg_Level\r\n        set udg_logic[32] = true\r\n        call textst( udg_string[0] + GetObjectName('A0IZ'), caster, 64, 90, 10, 1.5 )\r\n    else\r\n        set caster = GetSpellAbilityUnit()\r\n        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())\r\n    endif\r\n    \r\n    /*set udg_RandomLogic = true\r\n    set udg_Caster = caster\r\n    set udg_Level = lvl\r\n    set RandomMode = true\r\n    call TriggerExecute( udg_DB_Trigger_Three[GetRandomInt( 1, udg_Database_NumberItems[16])] )\r\n    set RandomMode = false*/\r\n    \r\n    call CastRandomAbility(caster, lvl, udg_DB_Trigger_Three[GetRandomInt( 1, udg_Database_NumberItems[16])] )\r\n    \r\n    set caster = null\r\nendfunction\r\n\r\n//===========================================================================\r\nfunction InitTrig_ChaosLordR takes nothing returns nothing\r\n    set gg_trg_ChaosLordR = CreateTrigger(  )\r\n    call TriggerRegisterAnyUnitEventBJ( gg_trg_ChaosLordR, EVENT_PLAYER_UNIT_SPELL_EFFECT )\r\n    call TriggerAddCondition( gg_trg_ChaosLordR, Condition( function Trig_ChaosLordR_Conditions ) )\r\n    call TriggerAddAction( gg_trg_ChaosLordR, function Trig_ChaosLordR_Actions )\r\nendfunction\r\n\r\n",
  "Events": [],
  "LocalVariables": [],
  "Conditions": [],
  "Actions": []
}