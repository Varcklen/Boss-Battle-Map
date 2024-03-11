{
  "Id": 50332895,
  "Comment": "",
  "IsScript": true,
  "RunOnMapInit": false,
  "Script": "function Trig_Venom_Conditions takes nothing returns boolean\r\n    return not( udg_IsDamageSpell ) and GetUnitTypeId(udg_DamageEventSource) != 'u000' and (GetUnitAbilityLevel( udg_DamageEventSource, 'A0FS') > 0 or GetUnitAbilityLevel( udg_DamageEventSource, 'A0J5') > 0 )\r\nendfunction\r\n\r\nfunction VenomCast takes nothing returns nothing\r\n    local integer id = GetHandleId( GetExpiredTimer( ) )\r\n    local real dmg = LoadReal( udg_hash, id, StringHash( \"vnm\" ) )\r\n    local unit target = LoadUnitHandle( udg_hash, id, StringHash( \"vnm\" ) )\r\n    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( \"vnmc\" ) )\r\n    \r\n    if GetUnitAbilityLevel( target, 'A0K8') > 0 then\r\n        set dmg = dmg + (dmg * LoadReal( udg_hash, GetHandleId( target ), StringHash( \"eleqv\" ) ) )\r\n    endif\r\n    if GetUnitState( target, UNIT_STATE_LIFE) > 0.405 and GetUnitAbilityLevel( target, 'A0FU') > 0 then\r\n        if GetUnitAbilityLevel(target, 'B07R') > 0 and Aspects_IsHeroAspectActive( caster, ASPECT_03 ) == false then\r\n            call healst(caster, target, dmg)\r\n        else\r\n            call UnitTakeDamage( caster, target, dmg, DAMAGE_TYPE_MAGIC )\r\n        endif\r\n    else\r\n        call FlushChildHashtable( udg_hash, id )\r\n        call DestroyTimer( GetExpiredTimer() )\r\n    endif\r\n    \r\n    set caster = null\r\n    set target = null\r\nendfunction\r\n\r\nfunction Trig_Venom_Actions takes nothing returns nothing\r\n    local integer id \r\n    local unit target\r\n    local unit caster\r\n    local real t\r\n    local real dmg\r\n    \r\n    if CastLogic() then\r\n        set caster = udg_Caster\r\n        set target = udg_Target\r\n    else\r\n        set caster = udg_DamageEventSource\r\n        set target = udg_DamageEventTarget\r\n    endif\r\n    set t = timebonus( caster, 5 )\r\n    set id = GetHandleId( target )\r\n\r\n    set dmg = udg_DamageEventAmount*0.15*GetUnitSpellPower(caster) //делим на время (5 сек), по этому 0.1 а не 0.75\r\n    if IsUniqueUpgraded(caster) then\r\n        set dmg = dmg * 2\r\n    endif\r\n    set dmg = dmg * udg_SpellDamageSpec[GetPlayerId(GetOwningPlayer(caster)) + 1]\r\n\r\n    if GetUnitAbilityLevel( target, 'A0FU') == 0 then \r\n        if LoadTimerHandle( udg_hash, id, StringHash( \"vnm\" ) ) == null then\r\n            call SaveTimerHandle( udg_hash, id, StringHash( \"vnm\" ), CreateTimer() )\r\n        endif\r\n        set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( \"vnm\" ) ) ) \r\n        call SaveUnitHandle( udg_hash, id, StringHash( \"vnm\" ), target )\r\n        call SaveUnitHandle( udg_hash, id, StringHash( \"vnmc\" ), caster )\r\n        call SaveReal( udg_hash, id, StringHash( \"vnm\" ), dmg )\r\n        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( target ), StringHash( \"vnm\" ) ), 1, true, function VenomCast )\r\n    endif\r\n\r\n    call bufst( caster, target, 'A0FU', 'B07P', \"vnm1\", t ) \r\n    \r\n    set caster = null\r\n    set target = null\r\nendfunction\r\n\r\n//===========================================================================\r\nfunction InitTrig_Venom takes nothing returns nothing\r\n    set gg_trg_Venom = CreateTrigger(  )\r\n    call TriggerRegisterVariableEvent( gg_trg_Venom, \"udg_AfterDamageEvent\", EQUAL, 1.00 )\r\n    call TriggerAddCondition( gg_trg_Venom, Condition( function Trig_Venom_Conditions ) )\r\n    call TriggerAddAction( gg_trg_Venom, function Trig_Venom_Actions )\r\nendfunction",
  "Events": [],
  "LocalVariables": [],
  "Conditions": [],
  "Actions": []
}