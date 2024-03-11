{
  "Id": 503330561,
  "Comment": "",
  "IsScript": true,
  "RunOnMapInit": false,
  "Script": "function Trig_OgreQ_Conditions takes nothing returns boolean\r\n    return GetSpellAbilityId() == 'A0ET' \r\nendfunction\r\n\r\nfunction Trig_OgreQ_Actions takes nothing returns nothing\r\n\tlocal integer id\r\n    local unit caster\r\n    local unit target\r\n    local integer lvl\r\n    local integer money\r\n    local real t\r\n    \r\n    if CastLogic() then\r\n        set caster = udg_Caster\r\n        set target = udg_Target\r\n        set lvl = udg_Level\r\n        set t = udg_Time\r\n    elseif RandomLogic() then\r\n        set caster = udg_Caster\r\n        set target = randomtarget( caster, 300, \"enemy\", \"\", \"\", \"\", \"\" )\r\n        set lvl = udg_Level\r\n        set t = 3\r\n        call textst( udg_string[0] + GetObjectName('A0ET'), caster, 64, 90, 10, 1.5 )\r\n        if target == null then\r\n            set caster = null\r\n            return\r\n        endif\r\n    else\r\n        set caster = GetSpellAbilityUnit()\r\n        set target = GetSpellTargetUnit()\r\n        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())\r\n        set t = 3\r\n    endif\r\n    set t = timebonus(caster, t)\r\n    \r\n    call DestroyEffect( AddSpecialEffect( \"Abilities\\\\Spells\\\\Human\\\\Thunderclap\\\\ThunderClapCaster.mdl\", GetUnitX( target ), GetUnitY( target )) )\r\n    call UnitAddAbility( target, 'A0DP' )\r\n    call SetUnitAbilityLevel( target, 'A0DM', lvl )\r\n    set id = GetHandleId( target )\r\n    if LoadTimerHandle( udg_hash, id, StringHash( \"ogrq\" ) ) == null then\r\n        call SaveTimerHandle( udg_hash, id, StringHash( \"ogrq\" ), CreateTimer() )\r\n    endif\r\n    call SaveUnitHandle( udg_hash, id, StringHash( \"ogrqt\" ), target )\r\n    call SaveUnitHandle( udg_hash, id, StringHash( \"ogrqc\" ), caster )\r\n    call SaveReal( udg_hash, id, StringHash( \"ogrq\" ), 20*lvl )\r\n    set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( \"ogrq\" ) ) ) \r\n\tcall SaveUnitHandle( udg_hash, id, StringHash( \"ogrqd\" ), target )\r\n    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( target ), StringHash( \"ogrq\" ) ), t, false, function OgreQEnd )\r\n    \r\n    set caster = null\r\n    set target = null\r\nendfunction\r\n\r\n//===========================================================================\r\nfunction InitTrig_OgreQ takes nothing returns nothing\r\n    set gg_trg_OgreQ = CreateTrigger(  )\r\n    call TriggerRegisterAnyUnitEventBJ( gg_trg_OgreQ, EVENT_PLAYER_UNIT_SPELL_EFFECT )\r\n    call TriggerAddCondition( gg_trg_OgreQ, Condition( function Trig_OgreQ_Conditions ) )\r\n    call TriggerAddAction( gg_trg_OgreQ, function Trig_OgreQ_Actions )\r\nendfunction\r\n",
  "Events": [],
  "LocalVariables": [],
  "Conditions": [],
  "Actions": []
}