{
  "Id": 50333161,
  "Comment": "",
  "IsScript": true,
  "RunOnMapInit": false,
  "Script": "globals\r\n    constant real BERRY_DEALER_R_BANANA_LIFE_TIME = 60\r\nendglobals\r\n\r\nfunction Trig_DealerR_Conditions takes nothing returns boolean\r\n    return GetSpellAbilityId() == 'A189'\r\nendfunction\r\n\r\nfunction Trig_DealerR_Actions takes nothing returns nothing\r\n    local unit caster\r\n    local integer lvl\r\n    local real x\r\n    local real y\r\n    local integer id\r\n\tlocal integer cyclA = 1\r\n\tlocal integer cyclAEnd\r\n    \r\n    if CastLogic() then\r\n        set caster = udg_Caster\r\n        set lvl = udg_Level\r\n        set x = GetLocationX( GetSpellTargetLoc() )\r\n        set y = GetLocationY( GetSpellTargetLoc() )\r\n    elseif RandomLogic() then\r\n        set caster = udg_Caster\r\n        set lvl = udg_Level\r\n        set x = GetUnitX( caster ) + GetRandomReal( -650, 650 )\r\n        set y = GetUnitY( caster ) + GetRandomReal( -650, 650 )\r\n        call textst( udg_string[0] + GetObjectName('A189'), caster, 64, 90, 10, 1.5 )\r\n    else\r\n        set caster = GetSpellAbilityUnit()\r\n        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())\r\n        set x = GetLocationX( GetSpellTargetLoc() )\r\n        set y = GetLocationY( GetSpellTargetLoc() )\r\n    endif\r\n    \r\n\tset cyclAEnd = lvl+1\r\n\tloop\r\n\t\texitwhen cyclA > cyclAEnd\r\n        call SpawnBanana( caster, Math_GetRandomX(x, 300), Math_GetRandomY(y, 300) )\r\n\t\tset cyclA = cyclA + 1\r\n\tendloop\r\n\t\r\n    set caster = null\r\nendfunction\r\n\r\n//===========================================================================\r\nfunction InitTrig_DealerR takes nothing returns nothing\r\n    set gg_trg_DealerR = CreateTrigger(  )\r\n    call TriggerRegisterAnyUnitEventBJ( gg_trg_DealerR, EVENT_PLAYER_UNIT_SPELL_EFFECT )\r\n    call TriggerAddCondition( gg_trg_DealerR, Condition( function Trig_DealerR_Conditions ) )\r\n    call TriggerAddAction( gg_trg_DealerR, function Trig_DealerR_Actions )\r\nendfunction\r\n\r\n",
  "Events": [],
  "LocalVariables": [],
  "Conditions": [],
  "Actions": []
}