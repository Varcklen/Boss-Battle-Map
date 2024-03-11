{
  "Id": 50332896,
  "Comment": "",
  "IsScript": true,
  "RunOnMapInit": false,
  "Script": "function Trig_SkLordSpec_Conditions takes nothing returns boolean\r\n    return GetSpellAbilityId() == 'A0IP' or GetSpellAbilityId() == 'A0IQ'\r\nendfunction\r\n\r\nfunction Trig_SkLordSpec_Actions takes nothing returns nothing\r\n    local integer id\r\n    local unit caster\r\n    local integer cyclA = 1\r\n    local integer cyclAEnd = 1\r\n\r\n    if CastLogic() then\r\n        set caster = udg_Caster\r\n    elseif RandomLogic() then\r\n        set caster = udg_Caster\r\n        call textst( udg_string[0] + GetObjectName('A0IP'), caster, 64, 90, 10, 1.5 )\r\n    else\r\n        set caster = GetSpellAbilityUnit()\r\n    endif\r\n\r\n    if IsUniqueUpgraded(caster) then\r\n        set cyclAEnd = 2\r\n    endif\r\n    \r\n    loop\r\n        exitwhen cyclA > cyclAEnd\r\n        call skeletsp( caster, caster )\r\n        set cyclA = cyclA + 1\r\n    endloop\r\n    \r\n    set caster = null\r\nendfunction\r\n\r\n//===========================================================================\r\nfunction InitTrig_SkLordSpec takes nothing returns nothing\r\n    set gg_trg_SkLordSpec = CreateTrigger(  )\r\n    call TriggerRegisterAnyUnitEventBJ( gg_trg_SkLordSpec, EVENT_PLAYER_UNIT_SPELL_EFFECT )\r\n    call TriggerAddCondition( gg_trg_SkLordSpec, Condition( function Trig_SkLordSpec_Conditions ) )\r\n    call TriggerAddAction( gg_trg_SkLordSpec, function Trig_SkLordSpec_Actions )\r\nendfunction\r\n\r\n",
  "Events": [],
  "LocalVariables": [],
  "Conditions": [],
  "Actions": []
}