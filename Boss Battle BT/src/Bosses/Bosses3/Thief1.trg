{
  "Id": 50333466,
  "Comment": "",
  "IsScript": true,
  "RunOnMapInit": false,
  "Script": "function Trig_Thief1_Conditions takes nothing returns boolean\r\n    return GetUnitTypeId(udg_DamageEventTarget) == 'h015' and GetUnitLifePercent(udg_DamageEventTarget) <= 75\r\nendfunction\r\n\r\nfunction ThiefAoE takes nothing returns nothing\r\n    local integer id = GetHandleId( GetExpiredTimer() )\r\n    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( \"bsth1\" ) )\r\n    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( \"bsth1d\" ) )\r\n    local group g = CreateGroup()\r\n    local unit u\r\n    \r\n    call DestroyEffect( AddSpecialEffect( \"Abilities\\\\Spells\\\\Other\\\\HowlOfTerror\\\\HowlCaster.mdl\", GetUnitX( dummy ), GetUnitY( dummy ) ) )\r\n    \r\n    call GroupEnumUnitsInRange( g, GetUnitX( dummy ), GetUnitY( dummy ), 125, null )\r\n    loop\r\n        set u = FirstOfGroup(g)\r\n        exitwhen u == null\r\n        if unitst( u, boss, \"enemy\" ) then\r\n            call UnitDamageTarget( dummy, u, 200, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)\r\n        endif\r\n        call GroupRemoveUnit(g,u)\r\n    endloop\r\n    \r\n    call RemoveUnit( dummy )\r\n    \r\n    call FlushChildHashtable( udg_hash, id )\r\n    call GroupClear( g )\r\n    call DestroyGroup( g )\r\n    set u = null\r\n    set g = null\r\n    set boss = null\r\n    set dummy = null\r\nendfunction \r\n\r\nfunction ThiefCast takes nothing returns nothing\r\n    local integer cyclA = 1\r\n    local integer id = GetHandleId( GetExpiredTimer() )\r\n    local integer id1\r\n    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( \"bsth\" ) )\r\n    \r\n    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then\r\n        call DestroyTimer( GetExpiredTimer() )\r\n        call FlushChildHashtable( udg_hash, id )\r\n    else\r\n        loop\r\n            exitwhen cyclA > 4\r\n            if GetUnitState( udg_hero[cyclA], UNIT_STATE_LIFE) > 0.405 then\r\n                set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( boss ), 'u000', GetUnitX( udg_hero[cyclA] ), GetUnitY( udg_hero[cyclA] ), 270 )\r\n                if GetOwningPlayer(boss) == Player(10) then\r\n                    call UnitAddAbility( bj_lastCreatedUnit, 'A136')\r\n                endif\r\n                \r\n                set id1 = GetHandleId( udg_hero[cyclA] )\r\n                if LoadTimerHandle( udg_hash, id1, StringHash( \"bsth1\" ) ) == null  then\r\n                    call SaveTimerHandle( udg_hash, id1, StringHash( \"bsth1\" ), CreateTimer() )\r\n                endif\r\n                call SaveTimerHandle( udg_hash, id1, StringHash( \"bsth1\" ), CreateTimer() )\r\n                set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( \"bsth1\" ) ) ) \r\n                call SaveUnitHandle( udg_hash, id1, StringHash( \"bsth1\" ), boss )\r\n                call SaveUnitHandle( udg_hash, id1, StringHash( \"bsth1d\" ), bj_lastCreatedUnit )\r\n                call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_hero[cyclA] ), StringHash( \"bsth1\" ) ), bosscast(3), false, function ThiefAoE )\r\n            endif\r\n            set cyclA = cyclA + 1\r\n        endloop\r\n    endif\r\n    \r\n    set boss = null\r\n endfunction   \r\n\r\nfunction Trig_Thief1_Actions takes nothing returns nothing\r\n    local integer id = GetHandleId( udg_DamageEventTarget )\r\n\r\n    call DisableTrigger( GetTriggeringTrigger() )\r\n    \r\n    if LoadTimerHandle( udg_hash, id, StringHash( \"bsth\" ) ) == null  then\r\n        call SaveTimerHandle( udg_hash, id, StringHash( \"bsth\" ), CreateTimer() )\r\n    endif\r\n\tset id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( \"bsth\" ) ) ) \r\n    call SaveUnitHandle( udg_hash, id, StringHash( \"bsth\" ), udg_DamageEventTarget )\r\n\tcall TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( \"bsth\" ) ), bosscast(7), true, function ThiefCast )\r\nendfunction\r\n\r\n//===========================================================================\r\nfunction InitTrig_Thief1 takes nothing returns nothing\r\n    set gg_trg_Thief1 = CreateTrigger()\r\n    call DisableTrigger( gg_trg_Thief1 )\r\n    call TriggerRegisterVariableEvent( gg_trg_Thief1, \"udg_AfterDamageEvent\", EQUAL, 1.00 )\r\n    call TriggerAddCondition( gg_trg_Thief1, Condition( function Trig_Thief1_Conditions ) )\r\n    call TriggerAddAction( gg_trg_Thief1, function Trig_Thief1_Actions )\r\nendfunction\r\n\r\n",
  "Events": [],
  "LocalVariables": [],
  "Conditions": [],
  "Actions": []
}