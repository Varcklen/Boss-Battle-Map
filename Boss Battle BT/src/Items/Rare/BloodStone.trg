{
  "Id": 50332561,
  "Comment": "",
  "IsScript": true,
  "RunOnMapInit": false,
  "Script": "function Trig_BloodStone_Conditions takes nothing returns boolean\r\n    return GetSpellAbilityId() == 'A14E'\r\nendfunction\r\n\r\nfunction Trig_BloodStone_Actions takes nothing returns nothing\r\n    local integer cyclA = 1\r\n    local integer cyclAEnd\r\n    local unit caster\r\n    local unit target\r\n    local real dmg = 200\r\n    \r\n    if CastLogic() then\r\n        set caster = udg_Caster\r\n        set target = udg_Target\r\n    elseif RandomLogic() then\r\n        set caster = udg_Caster\r\n        set target = randomtarget( caster, 900, \"enemy\", \"\", \"\", \"\", \"\" )\r\n        call textst( udg_string[0] + GetObjectName('A04R'), caster, 64, 90, 10, 1.5 )\r\n        if target == null then\r\n            set caster = null\r\n            return\r\n        endif\r\n    else\r\n        set caster = GetSpellAbilityUnit()\r\n        set target = GetSpellTargetUnit()\r\n    endif\r\n\r\n    if GetUnitState( caster, UNIT_STATE_LIFE) == GetUnitState( caster, UNIT_STATE_MAX_LIFE) then\r\n        set dmg = 3 * dmg\r\n    endif\r\n    set cyclAEnd = eyest( caster )\r\n    call dummyspawn( caster, 1, 0, 0, 0 )\r\n    call DestroyEffect( AddSpecialEffectTarget( \"Blood Explosion.mdx\", target, \"origin\") )\r\n    loop\r\n        exitwhen cyclA > cyclAEnd\r\n        call UnitDamageTarget( bj_lastCreatedUnit, target, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)\r\n        set cyclA = cyclA + 1\r\n    endloop\r\n    \r\n    set caster = null\r\n    set target = null\r\nendfunction\r\n\r\n//===========================================================================\r\nfunction InitTrig_BloodStone takes nothing returns nothing\r\n    set gg_trg_BloodStone = CreateTrigger(  )\r\n    call TriggerRegisterAnyUnitEventBJ( gg_trg_BloodStone, EVENT_PLAYER_UNIT_SPELL_EFFECT )\r\n    call TriggerAddCondition( gg_trg_BloodStone, Condition( function Trig_BloodStone_Conditions ) )\r\n    call TriggerAddAction( gg_trg_BloodStone, function Trig_BloodStone_Actions )\r\nendfunction\r\n\r\n",
  "Events": [],
  "LocalVariables": [],
  "Conditions": [],
  "Actions": []
}