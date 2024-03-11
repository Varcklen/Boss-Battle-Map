{
  "Id": 50333149,
  "Comment": "",
  "IsScript": true,
  "RunOnMapInit": false,
  "Script": "function Trig_GamblerQ_Conditions takes nothing returns boolean\r\n    return GetSpellAbilityId() == 'A11U' or GetSpellAbilityId() == 'A0YG'\r\nendfunction\r\n\r\nfunction Trig_GamblerQ_Actions takes nothing returns nothing\r\n    local integer lvl\r\n    local unit caster\r\n    local real dmg \r\n    local group g = CreateGroup()\r\n    local unit u\r\n    \r\n    if CastLogic() then\r\n        set caster = udg_Caster\r\n        set lvl = udg_Level\r\n    elseif RandomLogic() then\r\n        set caster = udg_Caster\r\n        set lvl = udg_Level\r\n        call textst( udg_string[0] + GetObjectName('A11U'), caster, 64, 90, 10, 1.5 )\r\n    else\r\n        set caster = GetSpellAbilityUnit()\r\n        set lvl = GetUnitAbilityLevel(udg_hero[GetPlayerId(GetOwningPlayer( caster ) ) + 1], 'A11U' )\r\n    endif\r\n    \r\n    set dmg = 40 + ( 30 * lvl )\r\n    if combat( caster, false, 0 ) and not( udg_fightmod[3] ) then\r\n    \tcall moneyst( caster, 10 + ( 5 * lvl ) )\r\n    endif\r\n    call DestroyEffect( AddSpecialEffect( \"BarbarianSkinW.mdx\", GetUnitX(caster), GetUnitY(caster) ) )\r\n    call dummyspawn( caster, 1, 0, 0, 0 )\r\n    call GroupEnumUnitsInRange( g, GetUnitX( caster ), GetUnitY( caster ), 300, null )\r\n    loop\r\n        set u = FirstOfGroup(g)\r\n        exitwhen u == null\r\n        if unitst( u, caster, \"enemy\" ) then\r\n            \tcall UnitDamageTarget( bj_lastCreatedUnit, u, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )\r\n        endif\r\n        call GroupRemoveUnit(g,u)\r\n        set u = FirstOfGroup(g)\r\n    endloop\r\n    \r\n    call GroupClear( g )\r\n    call DestroyGroup( g )\r\n    set u = null\r\n    set g = null\r\n    set caster = null\r\nendfunction\r\n\r\n//===========================================================================\r\nfunction InitTrig_GamblerQ takes nothing returns nothing\r\n    set gg_trg_GamblerQ = CreateTrigger(  )\r\n    call TriggerRegisterAnyUnitEventBJ( gg_trg_GamblerQ, EVENT_PLAYER_UNIT_SPELL_EFFECT )\r\n    call TriggerAddCondition( gg_trg_GamblerQ, Condition( function Trig_GamblerQ_Conditions ) )\r\n    call TriggerAddAction( gg_trg_GamblerQ, function Trig_GamblerQ_Actions )\r\nendfunction\r\n\r\n",
  "Events": [],
  "LocalVariables": [],
  "Conditions": [],
  "Actions": []
}