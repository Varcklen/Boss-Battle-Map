{
  "Id": 50332396,
  "Comment": "",
  "IsScript": true,
  "RunOnMapInit": false,
  "Script": "function Trig_Boom365_Conditions takes nothing returns boolean\r\n    return GetSpellAbilityId() == 'A0OS'\r\nendfunction\r\n\r\nfunction Trig_Boom365_Actions takes nothing returns nothing\r\n    local integer cyclA = 1\r\n    local integer cyclAEnd\r\n    local unit caster\r\n    local unit target\r\n    \r\n    if CastLogic() then\r\n        set caster = udg_Caster\r\n        set target = udg_Target\r\n    elseif RandomLogic() then\r\n        set caster = udg_Caster\r\n        set target = randomtarget( caster, 900, \"enemy\", \"\", \"\", \"\", \"\" )\r\n        call textst( udg_string[0] + GetObjectName('A0OS'), caster, 64, 90, 10, 1.5 )\r\n        if target == null then\r\n            set caster = null\r\n            return\r\n        endif\r\n    else\r\n        set caster = GetSpellAbilityUnit()\r\n        set target = GetSpellTargetUnit()\r\n    endif\r\n    \r\n    set cyclAEnd = eyest( caster )\r\n    call DestroyEffect( AddSpecialEffectTarget( \"Abilities\\\\Spells\\\\Other\\\\Incinerate\\\\FireLordDeathExplode.mdl\", caster, \"origin\") )\r\n    call DestroyEffect( AddSpecialEffectTarget( \"Abilities\\\\Spells\\\\Other\\\\Incinerate\\\\FireLordDeathExplode.mdl\", target, \"origin\" ) )\r\n    loop\r\n        exitwhen cyclA > cyclAEnd\r\n        call UnitStun(caster, target, 6 )\r\n        call UnitStun(caster, caster, 6 )\r\n        set cyclA = cyclA + 1\r\n    endloop\r\n\r\n    set caster = null\r\n    set target = null\r\nendfunction\r\n\r\n//===========================================================================\r\nfunction InitTrig_Boom365 takes nothing returns nothing\r\n    set gg_trg_Boom365 = CreateTrigger(  )\r\n    call TriggerRegisterAnyUnitEventBJ( gg_trg_Boom365, EVENT_PLAYER_UNIT_SPELL_EFFECT )\r\n    call TriggerAddCondition( gg_trg_Boom365, Condition( function Trig_Boom365_Conditions ) )\r\n    call TriggerAddAction( gg_trg_Boom365, function Trig_Boom365_Actions )\r\nendfunction\r\n\r\n",
  "Events": [],
  "LocalVariables": [],
  "Conditions": [],
  "Actions": []
}