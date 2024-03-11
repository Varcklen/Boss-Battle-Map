{
  "Id": 503330741,
  "Comment": "",
  "IsScript": true,
  "RunOnMapInit": false,
  "Script": "scope RunesmithQHit initializer init\r\n\r\n    globals\r\n            private constant string ID_HASH_TS = \"runesmith_ts\"\r\n            private constant string EFFECT = \"Abilities\\\\Spells\\\\Other\\\\Charm\\\\CharmTarget.mdl\"\r\n            private constant real STUN_PER_CHARGE = 1.0\r\n    endglobals\r\n    \r\n    private function Trig_RunesmithQHit_Conditions takes nothing returns boolean\r\n        return udg_IsDamageSpell == false and LoadInteger( udg_hash, GetHandleId( udg_DamageEventSource ), StringHash( ID_HASH_TS )) > 0\r\n    endfunction\r\n    \r\n    function Trig_RunesmithQHit_Actions takes nothing returns nothing\r\n        local integer charge = LoadInteger( udg_hash, GetHandleId( udg_DamageEventSource ), StringHash( ID_HASH_TS ))\r\n        local integer dmg = (1+charge) * BlzGetUnitWeaponIntegerField(udg_DamageEventSource, UNIT_WEAPON_IF_ATTACK_DAMAGE_BASE, 0) \r\n     \r\n        call DestroyEffect( AddSpecialEffectTarget(EFFECT, udg_DamageEventTarget, \"origin\" ) )\r\n        call UnitStun( udg_DamageEventSource, udg_DamageEventTarget, I2R(charge) )\r\n        call SaveInteger( udg_hash, GetHandleId( udg_DamageEventSource ), StringHash( ID_HASH_TS ), 0 )\r\n        call UnitDamageTarget(udg_DamageEventSource, udg_DamageEventTarget, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)\r\n    endfunction\r\n\r\n    //===========================================================================\r\n    private function init takes nothing returns nothing\r\n        call CreateEventTrigger(\"udg_AfterDamageEvent\", function Trig_RunesmithQHit_Actions, function Trig_RunesmithQHit_Conditions )\r\n    endfunction\r\n    \r\nendscope",
  "Events": [],
  "LocalVariables": [],
  "Conditions": [],
  "Actions": []
}