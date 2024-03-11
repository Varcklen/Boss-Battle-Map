{
  "Id": 50332832,
  "Comment": "",
  "IsScript": true,
  "RunOnMapInit": false,
  "Script": "globals\r\n    constant integer WATERFALL_POTION_HEAL = 1000\r\n    constant integer WATERFALL_POTION_MANA = 800\r\n    \r\n    constant string WATERFALL_POTION_ANIMATION = \"war3mapImported\\\\HolyAwakening.mdx\"\r\nendglobals\r\n\r\nfunction Trig_Waterfall_Potion_Conditions takes nothing returns boolean\r\n    return GetSpellAbilityId() == 'A167'\r\nendfunction\r\n\r\nfunction Trig_Waterfall_Potion_Actions takes nothing returns nothing\r\n    local unit caster\r\n    local real hp\r\n    local real mp\r\n    \r\n    if CastLogic() then\r\n        set caster = udg_Caster\r\n    elseif RandomLogic() then\r\n        set caster = udg_Caster\r\n        call textst( \"|cf0006400 Waterfall\", caster, 64, 90, 10, 1.5 )\r\n    else\r\n        set caster = GetSpellAbilityUnit()\r\n    endif\r\n\r\n    set hp = WATERFALL_POTION_HEAL * udg_SpellDamagePotion[GetPlayerId( GetOwningPlayer( caster ) ) + 1]\r\n    set mp = WATERFALL_POTION_MANA * udg_SpellDamagePotion[GetPlayerId( GetOwningPlayer( caster ) ) + 1]\r\n    \r\n    set IsHealFromPotion = true\r\n    call healst( caster, null, hp )\r\n    call manast( caster, null, mp )\r\n    call potionst( caster )\r\n    call DestroyEffect( AddSpecialEffectTarget( WATERFALL_POTION_ANIMATION, caster, \"origin\" ) )\r\n    \r\n    set caster = null\r\nendfunction\r\n\r\n//===========================================================================\r\nfunction InitTrig_Waterfall_Potion takes nothing returns nothing\r\n    set gg_trg_Waterfall_Potion = CreateTrigger(  )\r\n    call TriggerRegisterAnyUnitEventBJ( gg_trg_Waterfall_Potion, EVENT_PLAYER_UNIT_SPELL_EFFECT )\r\n    call TriggerAddCondition( gg_trg_Waterfall_Potion, Condition( function Trig_Waterfall_Potion_Conditions ) )\r\n    call TriggerAddAction( gg_trg_Waterfall_Potion, function Trig_Waterfall_Potion_Actions )\r\nendfunction\r\n\r\n",
  "Events": [],
  "LocalVariables": [],
  "Conditions": [],
  "Actions": []
}