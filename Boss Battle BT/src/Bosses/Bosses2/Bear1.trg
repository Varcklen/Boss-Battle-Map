{
  "Id": 50333429,
  "Comment": "",
  "IsScript": true,
  "RunOnMapInit": false,
  "Script": "function Trig_Bear1_Conditions takes nothing returns boolean\r\n    return GetUnitTypeId(udg_DamageEventTarget) == 'n010'\r\nendfunction\r\n\r\nfunction BearDealDamage takes unit boss returns nothing\r\n    local group g = CreateGroup()\r\n    local unit u\r\n\r\n    call GroupEnumUnitsInRange( g, GetUnitX( boss ), GetUnitY( boss ), 300, null )\r\n    loop\r\n        set u = FirstOfGroup(g)\r\n        exitwhen u == null\r\n        if unitst( u, boss, \"enemy\" ) then\r\n            call dummyspawn( boss, 1, 'A0AJ', 0, 0 )\r\n            call IssueTargetOrder( bj_lastCreatedUnit, \"thunderbolt\", u )\r\n        endif\r\n        call GroupRemoveUnit(g,u)\r\n    endloop\r\n\r\n    call GroupClear( g )\r\n    call DestroyGroup( g )\r\n    set u = null\r\n    set g = null\r\n    set boss = null\r\nendfunction\r\n\r\nfunction BearRun takes nothing returns nothing\r\n    local integer id = GetHandleId( GetExpiredTimer( ) )\r\n    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( \"bsbr1\" ) )\r\n    local unit target = LoadUnitHandle( udg_hash, id, StringHash( \"bsbr1trg\" ) )\r\n    local integer counter = LoadInteger( udg_hash, id, StringHash( \"bsbr1\" ) ) + 1\r\n    local real x = GetUnitX( target )\r\n    local real y = GetUnitY( target )\r\n    local real angle = Atan2( y - GetUnitY( boss ), x - GetUnitX( boss ) )\r\n    local real NewX = GetUnitX( boss ) + 30 * Cos( angle )\r\n    local real NewY = GetUnitY( boss ) + 30 * Sin( angle )\r\n    \r\n    if counter == 10 then\r\n        call SetUnitFlyHeight( boss, -600, 1500 )\r\n    endif\r\n\r\n    if counter == 20 or GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then\r\n        if GetUnitState( boss, UNIT_STATE_LIFE) > 0.405 then\r\n            call SetUnitPathing( boss, true )\r\n            call UnitRemoveAbility( boss, 'Amrf' )\r\n    \t\tcall pausest( boss, -1 )\r\n            call DestroyEffect( AddSpecialEffect( \"Abilities\\\\Spells\\\\Human\\\\ThunderClap\\\\ThunderClapCaster.mdl\", NewX, NewY ) )\r\n            call BearDealDamage(boss)\r\n        endif\r\n        call DestroyTimer( GetExpiredTimer() )\r\n        call FlushChildHashtable( udg_hash, id ) \r\n    else \r\n        call SaveInteger( udg_hash, id, StringHash( \"bsbr1\" ), counter )\r\n        call SetUnitPosition( boss, NewX, NewY )\r\n    endif\r\n    \r\n    \r\n    set boss = null\r\n    set target = null\r\nendfunction\r\n\r\nfunction BearCast takes nothing returns nothing\r\n    local integer id = GetHandleId( GetExpiredTimer( ) )\r\n    local real x\r\n    local real y\r\n    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( \"bsbr\" ))\r\n    local integer id1 = GetHandleId( boss )\r\n    local unit target\r\n    \r\n    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then\r\n        call DestroyTimer( GetExpiredTimer() )\r\n        call FlushChildHashtable( udg_hash, id )\r\n    else\r\n        set target = randomtarget( boss, 600, \"enemy\", \"\", \"\", \"\", \"\" )\r\n        if target != null then\r\n            set x = GetUnitX( target ) + GetRandomReal(-150, 150)\r\n            set y = GetUnitY( target ) + GetRandomReal(-150, 150)\r\n            call SetUnitFacing( boss, Atan2( y - GetUnitY( target ), x - GetUnitX( target ) ) )\r\n    \t\tcall pausest( boss, 1 )\r\n            call UnitAddAbility( boss, 'Amrf' )\r\n            call SetUnitFlyHeight( boss, 600, 1500 )\r\n            call SetUnitPathing( boss, true )\r\n            \r\n            if LoadTimerHandle( udg_hash, id1, StringHash( \"bsbr1\" ) ) == null  then\r\n                call SaveTimerHandle( udg_hash, id1, StringHash( \"bsbr1\" ), CreateTimer() )\r\n            endif\r\n            set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( \"bsbr1\" ) ) )\r\n            call SaveUnitHandle( udg_hash, id1, StringHash( \"bsbr1\" ), boss )\r\n            call SaveUnitHandle( udg_hash, id1, StringHash( \"bsbr1trg\" ), target )\r\n            call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( boss ), StringHash( \"bsbr1\" ) ), 0.02, true, function BearRun ) \r\n        endif\r\n    endif\r\n    \r\n    set boss = null\r\n    set target = null\r\nendfunction\r\n\r\nfunction Trig_Bear1_Actions takes nothing returns nothing\r\n    local integer id = GetHandleId( udg_DamageEventTarget )\r\n\r\n    call DisableTrigger( GetTriggeringTrigger() )    \r\n    \r\n    if LoadTimerHandle( udg_hash, id, StringHash( \"bsbr\" ) ) == null  then\r\n        call SaveTimerHandle( udg_hash, id, StringHash( \"bsbr\" ), CreateTimer() )\r\n    endif\r\n\tset id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( \"bsbr\" ) ) ) \r\n    call SaveUnitHandle( udg_hash, id, StringHash( \"bsbr\" ), udg_DamageEventTarget )\r\n\tcall TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( \"bsbr\" ) ), bosscast(14), true, function BearCast )\r\nendfunction\r\n\r\n//===========================================================================\r\nfunction InitTrig_Bear1 takes nothing returns nothing\r\n    set gg_trg_Bear1 = CreateTrigger(  )\r\n    call DisableTrigger( gg_trg_Bear1 )\r\n    call TriggerRegisterVariableEvent( gg_trg_Bear1, \"udg_AfterDamageEvent\", EQUAL, 1.00 )\r\n    call TriggerAddCondition( gg_trg_Bear1, Condition( function Trig_Bear1_Conditions ) )\r\n    call TriggerAddAction( gg_trg_Bear1, function Trig_Bear1_Actions )\r\nendfunction\r\n\r\n",
  "Events": [],
  "LocalVariables": [],
  "Conditions": [],
  "Actions": []
}