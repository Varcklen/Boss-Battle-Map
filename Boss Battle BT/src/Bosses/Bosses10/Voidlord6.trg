{
  "Id": 50333673,
  "Comment": "",
  "IsScript": true,
  "RunOnMapInit": false,
  "Script": "function Trig_Voidlord6_Conditions takes nothing returns boolean\r\n    return GetUnitTypeId( udg_DamageEventTarget ) == 'n00C' and GetUnitLifePercent(udg_DamageEventTarget) <= 10\r\nendfunction\r\n\r\nfunction Trig_Voidlord6_Actions takes nothing returns nothing\r\n    local integer cyclA = 1\r\n    local integer id\r\n\r\n    call DisableTrigger( GetTriggeringTrigger() )\r\n    call TransmissionFromUnitWithNameBJ( bj_FORCE_ALL_PLAYERS, udg_DamageEventTarget, GetUnitName(udg_DamageEventTarget), null, \"For the void!\", bj_TIMETYPE_SET, 3, false )\r\n\tloop\r\n\t\texitwhen cyclA > 4\r\n\t\tif GetUnitState( udg_hero[cyclA], UNIT_STATE_LIFE) > 0.405 then\r\n\t\t\tset bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( udg_DamageEventTarget ), 'u000', GetUnitX( udg_hero[cyclA] ), GetUnitY( udg_hero[cyclA] ), 270 )\r\n        \t\tcall SetUnitScale(bj_lastCreatedUnit, 3, 3, 3 )\r\n        \t\tcall UnitAddAbility( bj_lastCreatedUnit, 'A136')\r\n        \r\n        \t\tset id = GetHandleId( bj_lastCreatedUnit )\r\n        \t\tif LoadTimerHandle( udg_hash, id, StringHash( \"bbvd2\" ) ) == null  then\r\n            \t\t\tcall SaveTimerHandle( udg_hash, id, StringHash( \"bbvd2\" ), CreateTimer() )\r\n        \t\tendif\r\n        \t\tset id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( \"bbvd2\" ) ) ) \r\n        \t\tcall SaveUnitHandle( udg_hash, id, StringHash( \"bbvd2\" ), bj_lastCreatedUnit )\r\n        \t\tcall SaveUnitHandle( udg_hash, id, StringHash( \"bbvd2u\" ), udg_DamageEventTarget )\r\n        \t\tcall TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( \"bbvd2\" ) ), bosscast(5), false, function Voidlord4End )\r\n\t\tendif\r\n\t\tset cyclA = cyclA + 1\r\n\tendloop\r\nendfunction\r\n\r\n//===========================================================================\r\nfunction InitTrig_Voidlord6 takes nothing returns nothing\r\n    set gg_trg_Voidlord6 = CreateTrigger(  )\r\n    call DisableTrigger( gg_trg_Voidlord6 )\r\n    call TriggerRegisterVariableEvent( gg_trg_Voidlord6, \"udg_AfterDamageEvent\", EQUAL, 1.00 )\r\n    call TriggerAddCondition( gg_trg_Voidlord6, Condition( function Trig_Voidlord6_Conditions ) )\r\n    call TriggerAddAction( gg_trg_Voidlord6, function Trig_Voidlord6_Actions )\r\nendfunction\r\n\r\n",
  "Events": [],
  "LocalVariables": [],
  "Conditions": [],
  "Actions": []
}