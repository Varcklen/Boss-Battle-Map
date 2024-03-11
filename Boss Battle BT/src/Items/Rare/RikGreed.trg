{
  "Id": 50332661,
  "Comment": "",
  "IsScript": true,
  "RunOnMapInit": false,
  "Script": "function Trig_RikGreed_Conditions takes nothing returns boolean\r\n    return inv(GetSpellAbilityUnit(), 'I03W') > 0 and Uniques_Logic(GetSpellAbilityId())\r\nendfunction\r\n\r\nfunction Trig_RikGreed_Actions takes nothing returns nothing\r\n    local unit target = randomtarget( GetSpellAbilityUnit(), 600, \"ally\", \"notfull\", \"\", \"\", \"\" ) \r\n    \r\n    if target != null then\r\n        call healst( GetSpellAbilityUnit(), target, 100 )\r\n        call DestroyEffect( AddSpecialEffectTarget(\"Abilities\\\\Spells\\\\Other\\\\Incinerate\\\\FireLordDeathExplode.mdl\", target, \"origin\") )\r\n    endif\r\n    \r\n    set target = randomtarget( GetSpellAbilityUnit(), 600, \"enemy\", \"\", \"\", \"\", \"\" )\r\n    if target != null then\r\n        call dummyspawn( GetSpellAbilityUnit(), 1, 0, 0, 0 )\r\n        call DestroyEffect( AddSpecialEffect(\"Abilities\\\\Spells\\\\Other\\\\Incinerate\\\\FireLordDeathExplode.mdl\", GetUnitX( target ), GetUnitY( target ) ) )\r\n        call UnitDamageTarget( bj_lastCreatedUnit, target, 100, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )\r\n    endif\r\n    \r\n    set target = null\r\nendfunction\r\n\r\n//===========================================================================\r\nfunction InitTrig_RikGreed takes nothing returns nothing\r\n    set gg_trg_RikGreed = CreateTrigger(  )\r\n    call TriggerRegisterAnyUnitEventBJ( gg_trg_RikGreed, EVENT_PLAYER_UNIT_SPELL_EFFECT )\r\n    call TriggerAddCondition( gg_trg_RikGreed, Condition( function Trig_RikGreed_Conditions ) )\r\n    call TriggerAddAction( gg_trg_RikGreed, function Trig_RikGreed_Actions )\r\nendfunction\r\n\r\n",
  "Events": [],
  "LocalVariables": [],
  "Conditions": [],
  "Actions": []
}