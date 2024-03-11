{
  "Id": 50333566,
  "Comment": "",
  "IsScript": true,
  "RunOnMapInit": false,
  "Script": "function Trig_Succubus1_Conditions takes nothing returns boolean\r\n    return GetUnitTypeId(udg_DamageEventTarget) == 'n01S'\r\nendfunction\r\n\r\nfunction SucRun takes nothing returns nothing\r\n    local integer id = GetHandleId( GetExpiredTimer( ) )\r\n    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( \"bssc1\" ) )\r\n    local unit target = LoadUnitHandle( udg_hash, id, StringHash( \"bssc1t\" ) )\r\n    local integer counter = LoadInteger( udg_hash, id, StringHash( \"bssc1\" ) ) + 1\r\n    local real x = GetUnitX( target )\r\n    local real y = GetUnitY( target )\r\n    local real angle = Atan2( y - GetUnitY( boss ), x - GetUnitX( boss ) )\r\n    local real NewX = GetUnitX( boss ) + 30 * Cos( angle )\r\n    local real NewY = GetUnitY( boss ) + 30 * Sin( angle )\r\n    local group g = CreateGroup()\r\n    local unit u\r\n    local integer i = 0\r\n    \r\n    set bj_livingPlayerUnitsTypeId = 'n036'\r\n    call GroupEnumUnitsOfPlayer(g, GetOwningPlayer( boss ), filterLivingPlayerUnitsOfTypeId)\r\n    loop\r\n        set u = FirstOfGroup(g)\r\n        exitwhen u == null\r\n        set i = i + 1\r\n        call GroupRemoveUnit(g,u)\r\n        set u = FirstOfGroup(g)\r\n    endloop\r\n    \r\n    if counter == 10 then\r\n        call SetUnitFlyHeight( boss, -100, 300 )\r\n    endif\r\n\r\n    if counter == 20 or GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then\r\n        call SetUnitPathing( boss, true )\r\n        call UnitRemoveAbility( boss, 'Amrf' )\r\n        call pausest( boss, -1 )\r\n        if GetUnitState( target, UNIT_STATE_LIFE) > 0.405 and GetOwningPlayer( boss ) == Player(10) then\r\n            call SetUnitState( boss, UNIT_STATE_LIFE, GetUnitState( boss, UNIT_STATE_LIFE) + ( 75 * SpellPower_GetBossSpellPower() ) )\r\n            call dummyspawn( boss, 1, 0, 0, 0 )\r\n            call DestroyEffect( AddSpecialEffect( \"Objects\\\\Spawnmodels\\\\Human\\\\HumanLargeDeathExplode\\\\HumanLargeDeathExplode.mdl\", GetUnitX( target ), GetUnitY( target ) ) )\r\n            call UnitDamageTarget( bj_lastCreatedUnit, target, 75, true, false, ATTACK_TYPE_HERO, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS)\r\n            if i <= 15 then\r\n                set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( boss ), 'n036', GetUnitX( target ) + GetRandomReal(-400, 400), GetUnitY( target ) + GetRandomReal(-400, 400), GetRandomReal( 0, 360 ) )\r\n                call DestroyEffect( AddSpecialEffectTarget( \"Abilities\\\\Spells\\\\Other\\\\Doom\\\\DoomDeath.mdl\", bj_lastCreatedUnit, \"origin\") )\r\n                set udg_DamageEventTarget = bj_lastCreatedUnit\r\n                call TriggerExecute( gg_trg_Succubus1 )\r\n            endif\r\n        endif\r\n        call DestroyTimer( GetExpiredTimer() )\r\n        call FlushChildHashtable( udg_hash, id ) \r\n    else \r\n        call SaveInteger( udg_hash, id, StringHash( \"bssc1\" ), counter )\r\n        call SetUnitPosition( boss, NewX, NewY )\r\n    endif\r\n    \r\n\tcall GroupClear( g )\r\n    call DestroyGroup( g )\r\n    set u = null\r\n    set g = null\r\n    set boss = null\r\n    set target = null\r\nendfunction\r\n\r\nfunction SucCast takes nothing returns nothing\r\n    local integer id = GetHandleId( GetExpiredTimer( ) )\r\n    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( \"bssc\" ))\r\n    local integer id1 = GetHandleId( boss )\r\n    local unit target\r\n    local real x\r\n    local real y\r\n\r\n    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then\r\n        call DestroyTimer( GetExpiredTimer() )\r\n        call FlushChildHashtable( udg_hash, id )\r\n    else\r\n        set target = randomtarget( boss, 600, \"enemy\", \"\", \"\", \"\", \"\" )\r\n        if target != null then\r\n            set x = GetUnitX( target )\r\n            set y = GetUnitY( target )\r\n            call SetUnitFacing( boss, bj_RADTODEG * Atan2(GetUnitY(target) - GetUnitY(boss), GetUnitX(target) - GetUnitX(boss) ) )\r\n            call pausest( boss, 1 )\r\n            call UnitAddAbility( boss, 'Amrf' )\r\n            call SetUnitFlyHeight( boss, 100, 300 )\r\n            call SetUnitPathing( boss, true )\r\n\r\n            if LoadTimerHandle( udg_hash, id1, StringHash( \"bssc1\" ) ) == null  then\r\n                call SaveTimerHandle( udg_hash, id1, StringHash( \"bssc1\" ), CreateTimer() )\r\n            endif\r\n            set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( \"bssc1\" ) ) )\r\n            call SaveUnitHandle( udg_hash, id1, StringHash( \"bssc1\" ), boss )\r\n            call SaveUnitHandle( udg_hash, id1, StringHash( \"bssc1t\" ), target )\r\n            call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( boss ), StringHash( \"bssc1\" ) ), 0.02, true, function SucRun ) \r\n        endif\r\n    endif\r\n    \r\n    set boss = null\r\n    set target = null\r\nendfunction\r\n\r\nfunction Trig_Succubus1_Actions takes nothing returns nothing\r\n    local integer id = GetHandleId( udg_DamageEventTarget )\r\n\r\n    call DisableTrigger( GetTriggeringTrigger() )\r\n    \r\n    if LoadTimerHandle( udg_hash, id, StringHash( \"bssc\" ) ) == null  then\r\n        call SaveTimerHandle( udg_hash, id, StringHash( \"bssc\" ), CreateTimer() )\r\n    endif\r\n\tset id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( \"bssc\" ) ) ) \r\n    call SaveUnitHandle( udg_hash, id, StringHash( \"bssc\" ), udg_DamageEventTarget )\r\n\tcall TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( \"bssc\" ) ), bosscast(8), true, function SucCast )\r\nendfunction\r\n\r\n//===========================================================================\r\nfunction InitTrig_Succubus1 takes nothing returns nothing\r\n    set gg_trg_Succubus1 = CreateTrigger(  )\r\n    call DisableTrigger( gg_trg_Succubus1 )\r\n    call TriggerRegisterVariableEvent( gg_trg_Succubus1, \"udg_AfterDamageEvent\", EQUAL, 1.00 )\r\n    call TriggerAddCondition( gg_trg_Succubus1, Condition( function Trig_Succubus1_Conditions ) )\r\n    call TriggerAddAction( gg_trg_Succubus1, function Trig_Succubus1_Actions )\r\nendfunction\r\n\r\n",
  "Events": [],
  "LocalVariables": [],
  "Conditions": [],
  "Actions": []
}