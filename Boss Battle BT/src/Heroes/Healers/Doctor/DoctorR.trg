{
  "Id": 50333313,
  "Comment": "",
  "IsScript": true,
  "RunOnMapInit": false,
  "Script": "function Trig_DoctorR_Conditions takes nothing returns boolean\r\n    return GetSpellAbilityId() == 'A04K'\r\nendfunction\r\n\r\nfunction DoctorREnd takes nothing returns nothing\r\n    local integer id = GetHandleId( GetExpiredTimer( ) )\r\n    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( \"dctr\" ) )\r\n    \r\n    call UnitRemoveAbility( caster, 'A05X' )\r\n    call UnitRemoveAbility( caster, 'B047' )\r\n    call FlushChildHashtable( udg_hash, id )\r\n    \r\n    set caster = null\r\nendfunction\r\n\r\nfunction Trig_DoctorR_Actions takes nothing returns nothing\r\n    local integer id\r\n    local real i\r\n    local unit caster\r\n    local unit target\r\n    local integer lvl\r\n    local real t\r\n    local real sp\r\n    \r\n    if CastLogic() then\r\n        set caster = udg_Caster\r\n        set target = udg_Target\r\n        set lvl = udg_Level\r\n        set t = udg_Time\r\n    elseif RandomLogic() then\r\n        set caster = udg_Caster\r\n        set target = randomtarget( caster, 900, \"ally\", \"hero\", \"\", \"\", \"\" )\r\n        set lvl = udg_Level\r\n        call textst( udg_string[0] + GetObjectName('A04K'), caster, 64, 90, 10, 1.5 )\r\n        set t = 15\r\n        if target == null then\r\n            set caster = null\r\n            return\r\n        endif\r\n    else\r\n        set caster = GetSpellAbilityUnit()\r\n        set target = GetSpellTargetUnit()\r\n        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())\r\n        set t = 15\r\n    endif\r\n    set t = timebonus(caster, t)\r\n    set i = 0.1 + (0.05*lvl)\r\n    set sp = GetUnitSpellPower(caster)\r\n    set i = i*sp\r\n    set i = RMinBJ(1.0, i)\r\n    \r\n    call UnitAddAbility( target, 'A05X' )\r\n    call SetUnitAbilityLevel( target, 'A04M', lvl )\r\n    if LoadTimerHandle( udg_hash, GetHandleId( target ), StringHash( \"dctr\" ) ) == null  then\r\n        call SaveTimerHandle( udg_hash, GetHandleId( target ), StringHash( \"dctr\" ), CreateTimer() )\r\n    endif\r\n    set id = GetHandleId( LoadTimerHandle(udg_hash, GetHandleId( target ), StringHash( \"dctr\" ) ) )\r\n    call SaveUnitHandle( udg_hash, id, StringHash( \"dctr\" ), target )\r\n    call SaveReal( udg_hash, GetHandleId( target ), StringHash( \"dctr\" ), i )\r\n    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( target ), StringHash( \"dctr\" ) ), t, false, function DoctorREnd )\r\n    \r\n    set Event_DoctorE_Hero = caster\r\n\tset Event_DoctorE = 1\r\n\tset Event_DoctorE = 0\r\n    \r\n    set caster = null\r\n    set target = null\r\nendfunction\r\n\r\n//===========================================================================\r\nfunction InitTrig_DoctorR takes nothing returns nothing\r\n    set gg_trg_DoctorR = CreateTrigger( )\r\n    call TriggerRegisterAnyUnitEventBJ( gg_trg_DoctorR, EVENT_PLAYER_UNIT_SPELL_EFFECT )\r\n    call TriggerAddCondition( gg_trg_DoctorR, Condition( function Trig_DoctorR_Conditions ) )\r\n    call TriggerAddAction( gg_trg_DoctorR, function Trig_DoctorR_Actions )\r\nendfunction\r\n\r\n",
  "Events": [],
  "LocalVariables": [],
  "Conditions": [],
  "Actions": []
}