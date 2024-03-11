{
  "Id": 50333138,
  "Comment": "",
  "IsScript": true,
  "RunOnMapInit": false,
  "Script": "function Trig_MiracleBrewE_Conditions takes nothing returns boolean\r\n    return GetUnitTypeId(GetDyingUnit()) == 'u000' and ( GetUnitAbilityLevel(GetDyingUnit(), 'A087') > 0 or GetUnitAbilityLevel(GetDyingUnit(), 'A0MZ') > 0 )\r\nendfunction\r\n\r\nfunction MiracleBrewECast takes nothing returns nothing\r\n    local integer id = GetHandleId( GetExpiredTimer( ) )\r\n    call UnitRemoveAbility( LoadUnitHandle( udg_hash, id, StringHash( \"mrbr\" ) ), 'A0S0' )\r\n    call UnitRemoveAbility( LoadUnitHandle( udg_hash, id, StringHash( \"mrbr\" ) ), 'B00Y' )\r\n    call FlushChildHashtable( udg_hash, id )\r\nendfunction\r\n\r\nfunction Trig_MiracleBrewE_Actions takes nothing returns nothing\r\n    local group g = CreateGroup()\r\n    local unit u\r\n    local unit caster = LoadUnitHandle( udg_hash, GetHandleId( GetDyingUnit() ), StringHash( \"mrbr\" ) )\r\n    local real dmg = LoadReal( udg_hash, GetHandleId( GetDyingUnit() ), StringHash( \"mrbr\" ) )\r\n    local integer id\r\n    local real t = timebonus(caster, 15)\r\n\r\n    call DestroyEffect(AddSpecialEffect(\"Units\\\\NightElf\\\\Wisp\\\\WispExplode.mdl\", GetUnitX( GetDyingUnit() ), GetUnitY( GetDyingUnit() )))\r\n    call dummyspawn( caster, 1, 0, 0, 0 )\r\n    call GroupEnumUnitsInRange( g, GetUnitX( GetDyingUnit() ), GetUnitY( GetDyingUnit() ), 355, null )\r\n    loop\r\n        set u = FirstOfGroup(g)\r\n        exitwhen u == null\r\n        if unitst( u, caster, \"enemy\") then\r\n            set id = GetHandleId( u )\r\n            call UnitDamageTarget( bj_lastCreatedUnit, u, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)\r\n            if GetUnitState( u, UNIT_STATE_LIFE) > 0.405 then\r\n                call UnitAddAbility( u, 'A0S0' )\r\n                call SetUnitAbilityLevel( u, 'A0A5', GetUnitAbilityLevel( caster, 'A0RT' ) )\r\n                call SaveTimerHandle( udg_hash, id, StringHash( \"mrbr\" ), CreateTimer() )\r\n                set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( \"mrbr\" ) ) ) \r\n                call SaveUnitHandle( udg_hash, id, StringHash( \"mrbr\" ), u )\r\n                call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( u ), StringHash( \"mrbr\" ) ), t, false, function MiracleBrewECast )\r\n            endif\r\n        endif\r\n        call GroupRemoveUnit(g,u)\r\n    endloop\r\n\r\n    call RemoveSavedHandle(udg_hash, GetHandleId( GetDyingUnit() ), StringHash( \"mrbr\" ) )\r\n    call RemoveSavedReal(udg_hash, GetHandleId( GetDyingUnit() ), StringHash( \"mrbr\" ) )\r\n    call DestroyGroup( g )\r\n    set u = null\r\n    set caster = null\r\nendfunction\r\n\r\n//===========================================================================\r\nfunction InitTrig_MiracleBrewE takes nothing returns nothing\r\n    set gg_trg_MiracleBrewE = CreateTrigger(  )\r\n    call TriggerRegisterAnyUnitEventBJ( gg_trg_MiracleBrewE, EVENT_PLAYER_UNIT_DEATH )\r\n    call TriggerAddCondition( gg_trg_MiracleBrewE, Condition( function Trig_MiracleBrewE_Conditions ) )\r\n    call TriggerAddAction( gg_trg_MiracleBrewE, function Trig_MiracleBrewE_Actions )\r\nendfunction\r\n\r\n",
  "Events": [],
  "LocalVariables": [],
  "Conditions": [],
  "Actions": []
}