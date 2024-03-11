{
  "Id": 50333111,
  "Comment": "",
  "IsScript": true,
  "RunOnMapInit": false,
  "Script": "function Trig_NinjaQ_Conditions takes nothing returns boolean\r\n    return GetSpellAbilityId() == 'A0KC' and combat( GetSpellAbilityUnit(), true, GetSpellAbilityId() )\r\nendfunction\r\n\r\nfunction NinjaQCast takes nothing returns nothing\r\n    local integer id = GetHandleId( GetExpiredTimer( ) )\r\n    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( \"ninq\" ) )\r\n    local unit target = LoadUnitHandle( udg_hash, id, StringHash( \"ninqt\" ) )\r\n    local integer sp = LoadInteger( udg_hash, id, StringHash( \"ninq\" ) )\r\n    local real dmg = LoadReal( udg_hash, id, StringHash( \"ninq\" ) )\r\n    local real x = LoadReal( udg_hash, id, StringHash( \"ninqx\" ) )\r\n    local real y = LoadReal( udg_hash, id, StringHash( \"ninqy\" ) )\r\n    local real mana = LoadReal( udg_hash, id, StringHash( \"ninqmana\" ) )\r\n    \r\n    if RectContainsCoords(udg_Boss_Rect, x, y) then\r\n        call SetUnitPosition( caster, x, y )\r\n    endif\r\n    call SetUnitFacing( caster, bj_RADTODEG * Atan2(GetUnitY(target) - GetUnitY(caster), GetUnitX(target) - GetUnitX(caster) ) )\r\n    call DestroyEffect( AddSpecialEffect(\"Objects\\\\Spawnmodels\\\\Human\\\\HumanLargeDeathExplode\\\\HumanLargeDeathExplode.mdl\", GetUnitX(target), GetUnitY(target) ) )\r\n    call DestroyEffect( AddSpecialEffect(\"Abilities\\\\Spells\\\\Human\\\\FlakCannons\\\\FlakTarget.mdl\", GetUnitX(caster), GetUnitY(caster) ) )\r\n\r\n    call dummyspawn( caster, 1, 'A0N5', 0, 0 )\r\n    call UnitDamageTarget( bj_lastCreatedUnit, target, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )\r\n\r\n    if sp == 'A0KC' and ( GetUnitState( target, UNIT_STATE_LIFE) <= 0.405 or udg_DamageEventType == udg_DamageTypeCriticalStrike ) then\r\n        call BlzEndUnitAbilityCooldown( caster, sp )\r\n        call SetUnitState( caster, UNIT_STATE_MANA, GetUnitState( caster, UNIT_STATE_MANA ) + mana )\r\n    endif\r\n\r\n    call FlushChildHashtable( udg_hash, id )\r\n    \r\n    set caster = null\r\n    set target = null\r\nendfunction\r\n\r\nfunction Trig_NinjaQ_Actions takes nothing returns nothing\r\n    local integer id\r\n    local real dmg\r\n    local unit caster\r\n    local unit target\r\n    local integer lvl\r\n    local real x\r\n    local real y\r\n    local real mana = 0\r\n\r\n    if CastLogic() then\r\n        set caster = udg_Caster\r\n        set target = udg_Target\r\n\tset lvl = udg_Level\r\n    elseif RandomLogic() then\r\n        set caster = udg_Caster\r\n        set target = randomtarget( caster, 900, \"enemy\", \"\", \"\", \"\", \"\" )\r\n        call textst( udg_string[0] + GetObjectName('A0KC'), caster, 64, 90, 10, 1.5 )\r\n\tset lvl = udg_Level\r\n        if target == null then\r\n            set caster = null\r\n            return\r\n        endif\r\n    else\r\n        set caster = GetSpellAbilityUnit()\r\n        set target = GetSpellTargetUnit()\r\n        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())\r\n    endif\r\n    \r\n    set x = GetUnitX( target ) - 200 * Cos( 0.017 * GetUnitFacing( target ) )\r\n    set y = GetUnitY( target ) - 200 * Sin( 0.017 * GetUnitFacing( target ) )\r\n    if GetSpellAbilityId() == 'A0KC' then\r\n        set mana = BlzGetAbilityManaCost( GetSpellAbilityId(), lvl-1 )\r\n    endif\r\n\r\n    call DestroyEffect( AddSpecialEffect(\"Abilities\\\\Spells\\\\Human\\\\FlakCannons\\\\FlakTarget.mdl\", GetUnitX(caster), GetUnitY(caster) ) )\r\n\r\n    set id = GetHandleId( caster )\r\n    set dmg = (60 + ( 40 * lvl ) ) * GetUnitSpellPower(caster)\r\n\r\n    call SaveTimerHandle( udg_hash, id, StringHash( \"ninq\" ), CreateTimer() )\r\n\tset id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( \"ninq\" ) ) ) \r\n\tcall SaveUnitHandle( udg_hash, id, StringHash( \"ninq\" ), caster )\r\n\tcall SaveUnitHandle( udg_hash, id, StringHash( \"ninqt\" ), target )\r\n\tcall SaveInteger( udg_hash, id, StringHash( \"ninq\" ), GetSpellAbilityId() )\r\n\tcall SaveReal( udg_hash, id, StringHash( \"ninq\" ), dmg )\r\n\tcall SaveReal( udg_hash, id, StringHash( \"ninqx\" ), x )\r\n    call SaveReal( udg_hash, id, StringHash( \"ninqy\" ), y )\r\n    call SaveReal( udg_hash, id, StringHash( \"ninqmana\" ), mana )\r\n\tcall TimerStart( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( \"ninq\" ) ), 0.01, false, function NinjaQCast )\r\n\r\n    set caster = null\r\n    set target = null\r\nendfunction\r\n\r\n//===========================================================================\r\nfunction InitTrig_NinjaQ takes nothing returns nothing\r\n    set gg_trg_NinjaQ = CreateTrigger(  )\r\n    call TriggerRegisterAnyUnitEventBJ( gg_trg_NinjaQ, EVENT_PLAYER_UNIT_SPELL_EFFECT )\r\n    call TriggerAddCondition( gg_trg_NinjaQ, Condition( function Trig_NinjaQ_Conditions ) )\r\n    call TriggerAddAction( gg_trg_NinjaQ, function Trig_NinjaQ_Actions )\r\nendfunction\r\n\r\n",
  "Events": [],
  "LocalVariables": [],
  "Conditions": [],
  "Actions": []
}