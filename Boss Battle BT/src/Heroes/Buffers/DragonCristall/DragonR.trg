{
  "Id": 50332959,
  "Comment": "",
  "IsScript": true,
  "RunOnMapInit": false,
  "Script": "function Trig_DragonR_Conditions takes nothing returns boolean\r\n    return GetSpellAbilityId() == 'A00M'\r\nendfunction\r\n\r\nfunction Trig_DragonR_Actions takes nothing returns nothing\r\n    local integer cyclA = 1\r\n    local integer lvl\r\n    local unit caster\r\n    local integer i\r\n    local real r\r\n    \r\n    if CastLogic() then\r\n        set caster = udg_Caster\r\n        set lvl = udg_Level\r\n    elseif RandomLogic() then\r\n        set caster = udg_Caster\r\n        set lvl = udg_Level\r\n        call textst( udg_string[0] + GetObjectName('A00M'), caster, 64, 90, 10, 1.5 )\r\n    else\r\n        set caster = GetSpellAbilityUnit()\r\n        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())\r\n    endif\r\n    set r = udg_cristal * 5 * lvl\r\n\r\n    if r != 0 and GetUnitTypeId(caster) == udg_Database_Hero[1] then\r\n        loop\r\n            exitwhen cyclA > 4\r\n            if GetUnitState(udg_hero[cyclA], UNIT_STATE_LIFE) > 0.405 and IsUnitAlly(udg_hero[cyclA], GetOwningPlayer(caster)) and IsUnitType( udg_hero[cyclA], UNIT_TYPE_HERO) then\r\n                call shield( caster, udg_hero[cyclA], r )\r\n            endif\r\n            set cyclA = cyclA + 1\r\n        endloop\r\n    endif\r\n    \r\n    set caster = null\r\nendfunction\r\n\r\n//===========================================================================\r\nfunction InitTrig_DragonR takes nothing returns nothing\r\n    set gg_trg_DragonR = CreateTrigger(  )\r\n    call TriggerRegisterAnyUnitEventBJ( gg_trg_DragonR, EVENT_PLAYER_UNIT_SPELL_EFFECT )\r\n    call TriggerAddCondition( gg_trg_DragonR, Condition( function Trig_DragonR_Conditions ) )\r\n    call TriggerAddAction( gg_trg_DragonR, function Trig_DragonR_Actions )\r\nendfunction\r\n\r\n",
  "Events": [],
  "LocalVariables": [],
  "Conditions": [],
  "Actions": []
}