{
  "Id": 50333039,
  "Comment": "",
  "IsScript": true,
  "RunOnMapInit": false,
  "Script": "function Trig_VampQ_Conditions takes nothing returns boolean\r\n    return GetSpellAbilityId() == 'A065'\r\nendfunction\r\n\r\nfunction Trig_VampQ_Actions takes nothing returns nothing\r\n    local integer lvl\r\n    local unit caster\r\n    local real dmg \r\n    local group g = CreateGroup()\r\n    local unit u\r\n    \r\n    if CastLogic() then\r\n        set caster = udg_Caster\r\n        set lvl = udg_Level\r\n    elseif RandomLogic() then\r\n        set caster = udg_Caster\r\n        set lvl = udg_Level\r\n        call textst( udg_string[0] + GetObjectName('A065'), caster, 64, 90, 10, 1.5 )\r\n    else\r\n        set caster = GetSpellAbilityUnit()\r\n        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())\r\n    endif\r\n    \r\n    set dmg = 50. + ( 50. * lvl )\r\n    call DestroyEffect( AddSpecialEffect( \"Objects\\\\Spawnmodels\\\\Orc\\\\OrcSmallDeathExplode\\\\OrcSmallDeathExplode.mdl\", GetUnitX(caster), GetUnitY(caster) ) )\r\n    call dummyspawn( caster, 1, 0, 0, 0 )\r\n    call GroupEnumUnitsInRange( g, GetUnitX( caster ), GetUnitY( caster ), 300, null )\r\n    loop\r\n        set u = FirstOfGroup(g)\r\n        exitwhen u == null\r\n        if unitst( u, caster, \"enemy\" ) then\r\n\t\tcall DestroyEffect( AddSpecialEffect( \"Objects\\\\Spawnmodels\\\\Orc\\\\OrcSmallDeathExplode\\\\OrcSmallDeathExplode.mdl\", GetUnitX(u), GetUnitY(u) ) )\r\n            call UnitDamageTarget( bj_lastCreatedUnit, u, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )\r\n        endif\r\n        call GroupRemoveUnit(g,u)\r\n    endloop\r\n    \r\n    call SetUnitState( caster, UNIT_STATE_LIFE, RMaxBJ(0,GetUnitState( caster, UNIT_STATE_LIFE) - 125 ))\r\n    \r\n    call GroupClear( g )\r\n    call DestroyGroup( g )\r\n    set u = null\r\n    set g = null\r\n    set caster = null\r\nendfunction\r\n\r\n//===========================================================================\r\nfunction InitTrig_VampQ takes nothing returns nothing\r\n    set gg_trg_VampQ = CreateTrigger(  )\r\n    call TriggerRegisterAnyUnitEventBJ( gg_trg_VampQ, EVENT_PLAYER_UNIT_SPELL_EFFECT )\r\n    call TriggerAddCondition( gg_trg_VampQ, Condition( function Trig_VampQ_Conditions ) )\r\n    call TriggerAddAction( gg_trg_VampQ, function Trig_VampQ_Actions )\r\nendfunction\r\n\r\n",
  "Events": [],
  "LocalVariables": [],
  "Conditions": [],
  "Actions": []
}