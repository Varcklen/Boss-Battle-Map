{
  "Id": 50333266,
  "Comment": "",
  "IsScript": true,
  "RunOnMapInit": false,
  "Script": "function Trig_Metal_MageW_Conditions takes nothing returns boolean\r\n    return GetSpellAbilityId() == 'A0KS'\r\nendfunction\r\n\r\nfunction Metal_MageWCast takes nothing returns nothing\r\n    local integer id = GetHandleId( GetExpiredTimer( ) )\r\n    local real dmg = LoadReal( udg_hash, id, StringHash( \"mtmw\" ) )\r\n    local unit target = LoadUnitHandle( udg_hash, id, StringHash( \"mtmw\" ) )\r\n    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( \"mtmw1\" ) )\r\n    \r\n    if GetUnitState(target, UNIT_STATE_LIFE) <= 0.405 or GetUnitAbilityLevel( target, 'Beng') == 0 then\r\n        call RemoveUnit( dummy )\r\n        call DestroyTimer( GetExpiredTimer() )\r\n        call FlushChildHashtable( udg_hash, id )\r\n    elseif GetUnitState( target, UNIT_STATE_LIFE) > 0.405 then\r\n        call UnitDamageTarget( dummy, target, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )\r\n    endif\r\n    \r\n    set target = null\r\n    set dummy = null\r\nendfunction\r\n\r\nfunction Trig_Metal_MageW_Actions takes nothing returns nothing\r\n    local unit dummy\r\n    local integer id\r\n    local real dmg\r\n    local unit caster\r\n    local unit target\r\n    local integer lvl\r\n    local real t\r\n    \r\n    if CastLogic() then\r\n        set caster = udg_Caster\r\n        set target = udg_Target\r\n        set lvl = udg_Level\r\n        set t = udg_Time\r\n    elseif RandomLogic() then\r\n        set caster = udg_Caster\r\n        set target = randomtarget( caster, 300, \"enemy\", \"\", \"\", \"\", \"\" )\r\n        set lvl = udg_Level\r\n        call textst( udg_string[0] + GetObjectName('A0KS'), caster, 64, 90, 10, 1.5 )\r\n        set t = lvl + 2\r\n        if target == null then\r\n            set caster = null\r\n            return\r\n        endif\r\n    else\r\n        set caster = GetSpellAbilityUnit()\r\n        set target = GetSpellTargetUnit()\r\n        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())\r\n        set t = lvl + 2\r\n    endif\r\n    set t = timebonus(caster, t)\r\n    \r\n    set dmg = 50 * GetUnitSpellPower(caster)\r\n\r\n    set id = GetHandleId( target )\r\n    set dummy = CreateUnit( GetOwningPlayer( caster ), 'u000', GetUnitX( caster ), GetUnitY( caster ), bj_UNIT_FACING )\r\n    call DestroyEffect( AddSpecialEffect( \"Dark Execution.mdx\", GetUnitX(target), GetUnitY(target) ) )\r\n\r\n    call UnitAddAbility( dummy, 'A0KZ' )\r\n    call SetUnitAbilityLevel(dummy, 'A0KZ', lvl )\r\n    call IssueTargetOrder( dummy, \"ensnare\", target )\r\n    \r\n     if LoadTimerHandle( udg_hash, id, StringHash( \"mtmw\" ) ) == null then\r\n        call SaveTimerHandle( udg_hash, id, StringHash( \"mtmw\" ), CreateTimer() )\r\n    endif\r\n\tset id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( \"mtmw\" ) ) ) \r\n\tcall SaveUnitHandle( udg_hash, id, StringHash( \"mtmw\" ), target )\r\n    call SaveUnitHandle( udg_hash, id, StringHash( \"mtmw1\" ), dummy )\r\n    call SaveReal( udg_hash, id, StringHash( \"mtmw2\" ), t )\r\n    call SaveReal( udg_hash, id, StringHash( \"mtmw\" ), dmg)\r\n\tcall TimerStart( LoadTimerHandle( udg_hash, GetHandleId( target ), StringHash( \"mtmw\" ) ), 1, true, function Metal_MageWCast )\r\n    \r\n    set dummy = null\r\n    set caster = null\r\n    set target = null\r\nendfunction\r\n\r\n//===========================================================================\r\nfunction InitTrig_Metal_MageW takes nothing returns nothing\r\n    set gg_trg_Metal_MageW = CreateTrigger(  )\r\n    call TriggerRegisterAnyUnitEventBJ( gg_trg_Metal_MageW, EVENT_PLAYER_UNIT_SPELL_EFFECT )\r\n    call TriggerAddCondition( gg_trg_Metal_MageW, Condition( function Trig_Metal_MageW_Conditions ) )\r\n    call TriggerAddAction( gg_trg_Metal_MageW, function Trig_Metal_MageW_Actions )\r\nendfunction\r\n\r\n",
  "Events": [],
  "LocalVariables": [],
  "Conditions": [],
  "Actions": []
}