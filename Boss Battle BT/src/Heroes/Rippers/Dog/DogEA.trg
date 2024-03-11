{
  "Id": 503330631,
  "Comment": "",
  "IsScript": true,
  "RunOnMapInit": false,
  "Script": "function Trig_DogEA_Conditions takes nothing returns boolean\r\n    return not(udg_IsDamageSpell) and GetUnitAbilityLevel(udg_DamageEventSource, 'A158') > 0 and luckylogic( udg_DamageEventSource, 10, 1, 100 ) and IsUnitEnemy(udg_DamageEventSource, GetOwningPlayer(udg_DamageEventTarget))\r\nendfunction\r\n\r\nfunction Trig_DogEA_Actions takes nothing returns nothing\r\n    local integer id \r\n    local unit target\r\n    local unit caster\r\n    local real t\r\n    \r\n    set caster = udg_DamageEventSource\r\n    set target = udg_DamageEventTarget\r\n    \r\n    set t = timebonus( caster, 10 )\r\n\r\n    set id = GetHandleId( target )\r\n    call UnitAddAbility( target, 'A15A' )\r\n    call dummyspawn( caster, 0, 'A0N5', 0, 0 )\r\n    \r\n    if LoadTimerHandle( udg_hash, id, StringHash( \"doge\" ) ) == null then\r\n        call SaveTimerHandle( udg_hash, id, StringHash( \"doge\" ), CreateTimer() )\r\n    endif\r\n\tset id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( \"doge\" ) ) ) \r\n\tcall SaveUnitHandle( udg_hash, id, StringHash( \"doge\" ), target )\r\n    call SaveUnitHandle( udg_hash, id, StringHash( \"doged\" ), bj_lastCreatedUnit )\r\n    call SaveReal( udg_hash, id, StringHash( \"doget\" ), t )\r\n    call SaveReal( udg_hash, id, StringHash( \"doge\" ), (10+(5*GetUnitAbilityLevel(caster, 'A158'))) * GetUnitSpellPower(caster) )\r\n\tcall TimerStart( LoadTimerHandle( udg_hash, GetHandleId( target ), StringHash( \"doge\" ) ), 0.99, true, function DogECast ) \r\n    \r\n    set caster = null\r\n    set target = null\r\nendfunction\r\n\r\n//===========================================================================\r\nfunction InitTrig_DogEA takes nothing returns nothing\r\n    set gg_trg_DogEA = CreateTrigger(  )\r\n    call TriggerRegisterVariableEvent( gg_trg_DogEA, \"udg_AfterDamageEvent\", EQUAL, 1.00 )\r\n    call TriggerAddCondition( gg_trg_DogEA, Condition( function Trig_DogEA_Conditions ) )\r\n    call TriggerAddAction( gg_trg_DogEA, function Trig_DogEA_Actions )\r\nendfunction\r\n\r\n",
  "Events": [],
  "LocalVariables": [],
  "Conditions": [],
  "Actions": []
}