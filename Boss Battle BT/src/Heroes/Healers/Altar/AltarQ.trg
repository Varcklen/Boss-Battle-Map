{
  "Id": 50333317,
  "Comment": "",
  "IsScript": true,
  "RunOnMapInit": false,
  "Script": "function Trig_AltarQ_Conditions takes nothing returns boolean\r\n    return GetSpellAbilityId() == 'A122'\r\nendfunction\r\n\r\nfunction Trig_AltarQ_Actions takes nothing returns nothing\r\n    local unit caster\r\n    local unit target\r\n    local integer lvl\r\n    local real dmg\r\n    \r\n    if CastLogic() then\r\n        set caster = udg_Caster\r\n        set target = udg_Target\r\n        set lvl = udg_Level\r\n    elseif RandomLogic() then\r\n        set caster = udg_Caster\r\n        set target = randomtarget( caster, 900, \"all\", \"notcaster\", \"notfull\", \"\", \"\" )\r\n        set lvl = udg_Level\r\n        call textst( udg_string[0] + GetObjectName('A122'), caster, 64, 90, 10, 1.5 )\r\n        if target == null then\r\n            set caster = null\r\n            return\r\n        endif\r\n    else\r\n        set caster = GetSpellAbilityUnit()\r\n        set target = GetSpellTargetUnit()\r\n        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())\r\n    endif\r\n    set dmg = 160 + ( 40 * lvl )\r\n\r\n    if GetUnitAbilityLevel( caster, 'A12W') > 0 then\r\n        call DestroyEffect( AddSpecialEffect( \"Blood Whirl.mdx\", GetUnitX( target ), GetUnitY( target ) ) )\r\n        call dummyspawn( caster, 1, 0, 0, 0 )\r\n        call UnitDamageTarget( bj_lastCreatedUnit, target, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)\r\n        call healst( caster, null, dmg*1.5)\r\n    else\r\n        call DestroyEffect( AddSpecialEffect( \"Blood Whirl.mdx\", GetUnitX( target ), GetUnitY( target ) ) )\r\n        call healst( caster, target, dmg)\r\n        call SetUnitState( caster, UNIT_STATE_LIFE, RMaxBJ(0,GetUnitState( caster, UNIT_STATE_LIFE) - (95+(5*lvl)) ))\r\n    endif\r\n    \r\n    set caster = null\r\n    set target = null\r\nendfunction\r\n\r\n//===========================================================================\r\nfunction InitTrig_AltarQ takes nothing returns nothing\r\n    set gg_trg_AltarQ = CreateTrigger(  )\r\n    call TriggerRegisterAnyUnitEventBJ( gg_trg_AltarQ, EVENT_PLAYER_UNIT_SPELL_EFFECT )\r\n    call TriggerAddCondition( gg_trg_AltarQ, Condition( function Trig_AltarQ_Conditions ) )\r\n    call TriggerAddAction( gg_trg_AltarQ, function Trig_AltarQ_Actions )\r\nendfunction\r\n\r\n",
  "Events": [],
  "LocalVariables": [],
  "Conditions": [],
  "Actions": []
}