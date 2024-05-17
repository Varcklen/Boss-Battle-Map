{
  "Id": 50333449,
  "Comment": "",
  "IsScript": true,
  "RunOnMapInit": false,
  "Script": "function Trig_Ogre_Magi2_Conditions takes nothing returns boolean\r\n    return GetUnitTypeId(udg_DamageEventTarget) == 'h00Q' and GetUnitLifePercent(udg_DamageEventTarget) <= 75\r\nendfunction\r\n\r\nfunction Ogre_Magi2Cast takes nothing returns nothing\r\n    local integer id = GetHandleId( GetExpiredTimer( ) )\r\n    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( \"bsom\" ) )\r\n    local group g = CreateGroup()\r\n    local unit u\r\n\r\n    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then\r\n        call DestroyTimer( GetExpiredTimer() )\r\n        call FlushChildHashtable( udg_hash, id )\r\n    else\r\n        call GroupEnumUnitsInRange( g, GetUnitX(boss), GetUnitY(boss), 600, null )\r\n        loop\r\n            set u = FirstOfGroup(g) \r\n            exitwhen u == null\r\n            if unitst( u, boss, \"all\" )  then\r\n                call DestroyEffect( AddSpecialEffect( \"Abilities\\\\Spells\\\\Undead\\\\DeathCoil\\\\DeathCoilSpecialArt.mdl\", GetUnitX( u ), GetUnitY( u ) ) )\r\n                if IsUnitType( u, UNIT_TYPE_HERO) == false and IsUnitType( u, UNIT_TYPE_ANCIENT ) == false and IsMinionImmune(u) == false then\r\n                    call UnitDamageTarget( boss, u, 0.15 * GetUnitState( u, UNIT_STATE_MAX_LIFE ), true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )\r\n                else\r\n                    call UnitDamageTarget( boss, u, 0.01 * GetUnitState( u, UNIT_STATE_MAX_LIFE ), true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )\r\n                endif\r\n            endif\r\n            call GroupRemoveUnit(g,u)\r\n        endloop\r\n    endif\r\n    \r\n    call DestroyGroup( g )\r\n    set g = null\r\n    set u = null\r\n    set boss = null\r\nendfunction\r\n\r\nfunction Trig_Ogre_Magi2_Actions takes nothing returns nothing\r\n    local integer id = GetHandleId( udg_DamageEventTarget )\r\n    \r\n    call DisableTrigger( GetTriggeringTrigger() )\r\n    if LoadTimerHandle( udg_hash, id, StringHash( \"bsom\" ) ) == null  then\r\n        call SaveTimerHandle( udg_hash, id, StringHash( \"bsom\" ), CreateTimer() )\r\n    endif\r\n\tset id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( \"bsom\" ) ) ) \r\n    call SaveUnitHandle( udg_hash, id, StringHash( \"bsom\" ), udg_DamageEventTarget )\r\n\tcall TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( \"bsom\" ) ), bosscast(1), true, function Ogre_Magi2Cast )\r\nendfunction\r\n\r\n//===========================================================================\r\nfunction InitTrig_Ogre_Magi2 takes nothing returns nothing\r\n    set gg_trg_Ogre_Magi2 = CreateTrigger(  )\r\n    call DisableTrigger( gg_trg_Ogre_Magi2 )\r\n    call TriggerRegisterVariableEvent( gg_trg_Ogre_Magi2, \"udg_AfterDamageEvent\", EQUAL, 1.00 )\r\n    call TriggerAddCondition( gg_trg_Ogre_Magi2, Condition( function Trig_Ogre_Magi2_Conditions ) )\r\n    call TriggerAddAction( gg_trg_Ogre_Magi2, function Trig_Ogre_Magi2_Actions )\r\nendfunction\r\n\r\n",
  "Events": [],
  "LocalVariables": [],
  "Conditions": [],
  "Actions": []
}