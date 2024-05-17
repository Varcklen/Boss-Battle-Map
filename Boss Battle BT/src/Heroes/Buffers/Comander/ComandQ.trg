{
  "Id": 50332961,
  "Comment": "",
  "IsScript": true,
  "RunOnMapInit": false,
  "Script": "function Trig_ComandQ_Conditions takes nothing returns boolean\r\n    return GetSpellAbilityId() == 'A0UK'\r\nendfunction\r\n\r\nfunction Trig_ComandQ_Actions takes nothing returns nothing\r\n    local real x \r\n    local real y\r\n    local real dmg \r\n    local group g = CreateGroup()\r\n    local unit u\r\n    local integer lvl\r\n    local unit caster\r\n    \r\n    if CastLogic() then\r\n        set caster = udg_Caster\r\n        set lvl = udg_Level\r\n    elseif RandomLogic() then\r\n        set caster = udg_Caster\r\n        set lvl = udg_Level\r\n        call textst( udg_string[0] + GetObjectName('A0UK'), caster, 64, 90, 10, 1.5 )\r\n    else\r\n        set caster = GetSpellAbilityUnit()\r\n        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId() )\r\n    endif\r\n    \r\n    set x = GetUnitX( caster ) + 200 * Cos( 0.017 * GetUnitFacing( caster ) )\r\n    set y = GetUnitY( caster ) + 200 * Sin( 0.017 * GetUnitFacing( caster ) )\r\n    set dmg = 200 + ( 100 * lvl ) \r\n    \r\n\tcall DestroyEffect( AddSpecialEffect( \"Objects\\\\Spawnmodels\\\\Naga\\\\NagaDeath\\\\NagaDeath.mdl\", x, y ) )\r\n    \r\n    call GroupEnumUnitsInRange( g, x, y, 250, null )\r\n    loop\r\n        set u = FirstOfGroup(g)\r\n        exitwhen u == null\r\n        if unitst( u, caster, \"enemy\" ) then\r\n            call UnitDamageTarget( caster, u, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )\r\n            call UnitStun(caster, u, 1.5 )\r\n        endif\r\n        call GroupRemoveUnit(g,u)\r\n    endloop\r\n\r\n    call DestroyGroup( g )\r\n    set u = null\r\n    set g = null\r\n    set caster = null\r\nendfunction\r\n\r\n//===========================================================================\r\nfunction InitTrig_ComandQ takes nothing returns nothing\r\n    set gg_trg_ComandQ = CreateTrigger(  )\r\n    call TriggerRegisterAnyUnitEventBJ( gg_trg_ComandQ, EVENT_PLAYER_UNIT_SPELL_EFFECT )\r\n    call TriggerAddCondition( gg_trg_ComandQ, Condition( function Trig_ComandQ_Conditions ) )\r\n    call TriggerAddAction( gg_trg_ComandQ, function Trig_ComandQ_Actions )\r\nendfunction\r\n\r\n",
  "Events": [],
  "LocalVariables": [],
  "Conditions": [],
  "Actions": []
}