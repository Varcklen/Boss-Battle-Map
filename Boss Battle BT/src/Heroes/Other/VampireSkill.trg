{
  "Id": 50332946,
  "Comment": "",
  "IsScript": true,
  "RunOnMapInit": false,
  "Script": "function Trig_VampireSkill_Conditions takes nothing returns boolean\r\n    return GetSpellAbilityId() == 'A00U'\r\nendfunction\r\n\r\nfunction Trig_VampireSkill_Actions takes nothing returns nothing\r\n    local unit caster\r\n    local unit target\r\n    \r\n    if CastLogic() then\r\n        set caster = udg_Caster\r\n        set target = udg_Target\r\n    elseif RandomLogic() then\r\n        set caster = udg_Caster\r\n        set target = randomtarget( caster, 600, \"enemy\", \"\", \"\", \"\", \"\" )\r\n        call textst( udg_string[0] + GetObjectName('A00U'), caster, 64, 90, 10, 1.5 )\r\n        if target == null then\r\n            set caster = null\r\n            return\r\n        endif\r\n    else\r\n        set caster = GetSpellAbilityUnit()\r\n        set target = GetSpellTargetUnit()\r\n    endif\r\n    \r\n    call DestroyEffect( AddSpecialEffectTarget(\"Abilities\\\\Spells\\\\Other\\\\Stampede\\\\StampedeMissileDeath.mdl\" , target, \"origin\" ) )\r\n    call DestroyEffect( AddSpecialEffectTarget(\"Abilities\\\\Spells\\\\Undead\\\\VampiricAura\\\\VampiricAuraTarget.mdl\" , caster, \"origin\" ) )\r\n    call dummyspawn( caster, 1, 0, 0, 0 )\r\n    call UnitDamageTarget( bj_lastCreatedUnit, target, 200, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)\r\n    call healst( GetSpellAbilityUnit(), null, 200 )\r\n    \r\n    set caster = null\r\n    set target = null\r\nendfunction\r\n\r\n//===========================================================================\r\nfunction InitTrig_VampireSkill takes nothing returns nothing\r\n    set gg_trg_VampireSkill = CreateTrigger(  )\r\n    call TriggerRegisterAnyUnitEventBJ( gg_trg_VampireSkill, EVENT_PLAYER_UNIT_SPELL_EFFECT )\r\n    call TriggerAddCondition( gg_trg_VampireSkill, Condition( function Trig_VampireSkill_Conditions ) )\r\n    call TriggerAddAction( gg_trg_VampireSkill, function Trig_VampireSkill_Actions )\r\nendfunction\r\n\r\n",
  "Events": [],
  "LocalVariables": [],
  "Conditions": [],
  "Actions": []
}