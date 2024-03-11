{
  "Id": 50333630,
  "Comment": "",
  "IsScript": true,
  "RunOnMapInit": false,
  "Script": "function Trig_Pyromant1_Conditions takes nothing returns boolean\r\n    return GetUnitTypeId(udg_DamageEventTarget) == 'h00Z' and GetUnitLifePercent(udg_DamageEventTarget) <= 90\r\nendfunction\r\n\r\nfunction PyroEnd takes nothing returns nothing\r\n    local integer id = GetHandleId( GetExpiredTimer() )\r\n    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( \"bspr1\" ) )\r\n    local integer cyclA = 1\r\n    local real NewX\r\n    local real NewY\r\n    local real x = LoadReal( udg_hash, id, StringHash( \"bspr1x\" ) )\r\n    local real y = LoadReal( udg_hash, id, StringHash( \"bspr1y\" ) )\r\n    \r\n    call PauseUnit( boss, false )\r\n    if GetUnitState( boss, UNIT_STATE_LIFE) > 0.405 and ( udg_fightmod[0] ) then\r\n        loop\r\n            exitwhen cyclA > 5\r\n            set NewX = x + 500 * Cos( 72 * cyclA * 0.0174 )\r\n            set NewY = y + 500 * Sin( 72 * cyclA * 0.0174 )\r\n            set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( boss ), 'u01J', NewX, NewY, 72 * cyclA )\r\n            call UnitApplyTimedLife( bj_lastCreatedUnit, 'BTLF', 1)\r\n            call IssuePointOrder( bj_lastCreatedUnit, \"carrionswarm\", x, y )\r\n            set cyclA = cyclA + 1\r\n        endloop\r\n    endif\r\n    call FlushChildHashtable( udg_hash, id )\r\n    \r\n    set boss = null\r\nendfunction\r\n\r\nfunction PyroCast takes nothing returns nothing\r\n    local integer id = GetHandleId( GetExpiredTimer() )\r\n    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( \"bspr\" ) )\r\n    local integer id1 = GetHandleId( boss )\r\n\r\n    if GetUnitLifePercent( boss ) <= 25 or not( udg_fightmod[0] ) then\r\n        call DestroyTimer( GetExpiredTimer() )\r\n        call FlushChildHashtable( udg_hash, id )\r\n    else\r\n        call PauseUnit( boss, true )\r\n        call SetUnitAnimation( boss, \"spell\" )\r\n        set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( boss ), 'u000', GetUnitX( boss ), GetUnitY( boss ), 270 )\r\n        call SetUnitScale(bj_lastCreatedUnit, 3, 3, 3 )\r\n        call UnitAddAbility( bj_lastCreatedUnit, 'A136')\r\n        call UnitApplyTimedLife(bj_lastCreatedUnit, 'BTLF', 1.5)\r\n        \r\n        if LoadTimerHandle( udg_hash, id1, StringHash( \"bspr1\" ) ) == null  then\r\n            call SaveTimerHandle( udg_hash, id1, StringHash( \"bspr1\" ), CreateTimer() )\r\n        endif\r\n        set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( \"bspr1\" ) ) ) \r\n        call SaveUnitHandle( udg_hash, id1, StringHash( \"bspr1\" ), boss )\r\n        call SaveReal( udg_hash, id1, StringHash( \"bspr1x\" ), GetUnitX( boss ) )\r\n        call SaveReal( udg_hash, id1, StringHash( \"bspr1y\" ), GetUnitY( boss ) )\r\n        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( boss ), StringHash( \"bspr1\" ) ), bosscast(1.5), false, function PyroEnd )\r\n    endif\r\n    \r\n    set boss = null\r\nendfunction\r\n\r\nfunction Trig_Pyromant1_Actions takes nothing returns nothing\r\n    local integer id = GetHandleId( udg_DamageEventTarget )\r\n\r\n    call DisableTrigger( GetTriggeringTrigger() )\r\n    \r\n    if LoadTimerHandle( udg_hash, id, StringHash( \"bspr\" ) ) == null  then\r\n        call SaveTimerHandle( udg_hash, id, StringHash( \"bspr\" ), CreateTimer() )\r\n    endif\r\n\tset id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( \"bspr\" ) ) ) \r\n    call SaveUnitHandle( udg_hash, id, StringHash( \"bspr\" ), udg_DamageEventTarget )\r\n\tcall TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( \"bspr\" ) ), bosscast(10), true, function PyroCast )\r\nendfunction\r\n\r\n//===========================================================================\r\nfunction InitTrig_Pyromant1 takes nothing returns nothing\r\n    set gg_trg_Pyromant1 = CreateTrigger(  )\r\n    call DisableTrigger( gg_trg_Pyromant1 )\r\n    call TriggerRegisterVariableEvent( gg_trg_Pyromant1, \"udg_AfterDamageEvent\", EQUAL, 1.00 )\r\n    call TriggerAddCondition( gg_trg_Pyromant1, Condition( function Trig_Pyromant1_Conditions ) )\r\n    call TriggerAddAction( gg_trg_Pyromant1, function Trig_Pyromant1_Actions )\r\nendfunction\r\n\r\n",
  "Events": [],
  "LocalVariables": [],
  "Conditions": [],
  "Actions": []
}