{
  "Id": 50333011,
  "Comment": "",
  "IsScript": true,
  "RunOnMapInit": false,
  "Script": "function Trig_BlackKnightR_Conditions takes nothing returns boolean\r\n    return GetSpellAbilityId() == 'A100'\r\nendfunction\r\n\r\nfunction BlackKnightRCast takes nothing returns nothing\r\n    local integer id = GetHandleId( GetExpiredTimer( ) )\r\n    local unit u = LoadUnitHandle( udg_hash, id, StringHash( \"blkr\" ) )\r\n    \r\n    if GetUnitAbilityLevel( u, 'A107' ) > 0 then\r\n        call pausest( u, -1 )\r\n        call UnitRemoveAbility( u, 'A107' )\r\n        call UnitRemoveAbility( u, 'B04A' )\r\n    endif\r\n    call FlushChildHashtable( udg_hash, id )\r\n\r\n\tset u = null\r\nendfunction\r\n\r\nfunction Trig_BlackKnightR_Actions takes nothing returns nothing \r\n    local unit caster\r\n    local unit target\r\n    local integer lvl\r\n    local integer id\r\n    local real t\r\n    \r\n    if CastLogic() then\r\n        set caster = udg_Caster\r\n        set target = udg_Target\r\n        set lvl = udg_Level\r\n        set t = udg_Time\r\n    elseif RandomLogic() then\r\n        set caster = udg_Caster\r\n        set target = randomtarget( caster, 300, \"all\", \"notcaster\", \"\", \"\", \"\" )\r\n        set lvl = udg_Level\r\n        call textst( udg_string[0] + GetObjectName('A100'), caster, 64, 90, 10, 1.5 )\r\n        set t = 4 + ( 2 * lvl )\r\n        if target == null then\r\n            set caster = null\r\n            return\r\n        endif\r\n    else\r\n        set caster = GetSpellAbilityUnit()\r\n        set target = GetSpellTargetUnit()\r\n        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())\r\n        set t = 4 + ( 2 * lvl )\r\n    endif\r\n    set t = timebonus(caster, t)\r\n    \r\n    set id = GetHandleId( target )\r\n    \r\n    if GetUnitAbilityLevel( target, 'A107' ) == 0 then\r\n        call pausest( target, 1 )\r\n    endif\r\n    call UnitAddAbility( target, 'A107' )\r\n    call DestroyEffect( AddSpecialEffectTarget( \"Objects\\\\Spawnmodels\\\\Undead\\\\UCancelDeath\\\\UCancelDeath.mdl\", target, \"chest\" ) )\r\n    \r\n    if LoadTimerHandle( udg_hash, id, StringHash( \"blkr\" ) ) == null then\r\n        call SaveTimerHandle( udg_hash, id, StringHash( \"blkr\" ), CreateTimer() )\r\n    endif\r\n\tset id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( \"blkr\" ) ) ) \r\n\tcall SaveUnitHandle( udg_hash, id, StringHash( \"blkr\" ), target )\r\n\tcall TimerStart( LoadTimerHandle( udg_hash, GetHandleId( target ), StringHash( \"blkr\" ) ), t, false, function BlackKnightRCast )\r\n    \r\n    set caster = null\r\n    set target = null\r\nendfunction\r\n\r\n//===========================================================================\r\nfunction InitTrig_BlackKnightR takes nothing returns nothing\r\n    set gg_trg_BlackKnightR = CreateTrigger(  )\r\n    call TriggerRegisterAnyUnitEventBJ( gg_trg_BlackKnightR, EVENT_PLAYER_UNIT_SPELL_EFFECT )\r\n    call TriggerAddCondition( gg_trg_BlackKnightR, Condition( function Trig_BlackKnightR_Conditions ) )\r\n    call TriggerAddAction( gg_trg_BlackKnightR, function Trig_BlackKnightR_Actions )\r\nendfunction\r\n\r\n",
  "Events": [],
  "LocalVariables": [],
  "Conditions": [],
  "Actions": []
}