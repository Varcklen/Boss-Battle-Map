{
  "Id": 50333268,
  "Comment": "",
  "IsScript": true,
  "RunOnMapInit": false,
  "Script": "function Trig_Metal_MageR_Conditions takes nothing returns boolean\r\n    return GetSpellAbilityId() == 'A0LY'\r\nendfunction\r\n\r\nfunction Trig_Metal_MageR_Actions takes nothing returns nothing\r\n    local integer lvl\r\n    local unit caster\r\n    local unit oldpet\r\n    local real sp\r\n    local real size\r\n    \r\n    if CastLogic() then\r\n        set caster = udg_Caster\r\n        set lvl = udg_Level\r\n    elseif RandomLogic() then\r\n        set caster = udg_Caster\r\n        set lvl = udg_Level\r\n        call textst( udg_string[0] + GetObjectName('A0LY'), caster, 64, 90, 10, 1.5 )\r\n    else\r\n        set caster = GetSpellAbilityUnit()\r\n        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId() )\r\n    endif\r\n\r\n    set oldpet = LoadUnitHandle( udg_hash, GetHandleId( caster ), StringHash( \"mtmr\" ) )\r\n    if GetUnitState( oldpet, UNIT_STATE_LIFE) > 0.405 then\r\n        call DestroyEffect( AddSpecialEffect( \"Abilities\\\\Spells\\\\Orc\\\\FeralSpirit\\\\feralspirittarget.mdl\", GetUnitX( oldpet ), GetUnitY( oldpet ) ) )\r\n        call RemoveUnit( oldpet )\r\n    endif\r\n\r\n    set sp = GetUnitSpellPower(caster)\r\n    if sp >= 2 then\r\n        set size = 1.4\r\n    else\r\n        set size = sp*0.7\r\n    endif\r\n    set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( caster ), 'n047', GetUnitX( caster ) + GetRandomReal( -250, 250 ), GetUnitY( caster ) + GetRandomReal( -250, 250 ), GetRandomReal( 0, 360 ) )\r\n\r\n    call SaveUnitHandle( udg_hash, GetHandleId( caster ), StringHash( \"mtmr\" ), bj_lastCreatedUnit )\r\n    call BlzSetUnitMaxHP( bj_lastCreatedUnit, R2I(BlzGetUnitMaxHP(bj_lastCreatedUnit)+((lvl-1)*150)) )\r\n    call BlzSetUnitBaseDamage( bj_lastCreatedUnit, R2I(BlzGetUnitBaseDamage(bj_lastCreatedUnit, 0)+((lvl-1)*5)), 0 )\r\n\r\n    call BlzSetUnitMaxHP( bj_lastCreatedUnit, R2I(BlzGetUnitMaxHP(bj_lastCreatedUnit)*sp) )\r\n    call BlzSetUnitBaseDamage( bj_lastCreatedUnit, R2I(GetUnitDamage(bj_lastCreatedUnit)*sp-GetUnitAvgDiceDamage(bj_lastCreatedUnit)), 0 )\r\n    call SetUnitState( bj_lastCreatedUnit, UNIT_STATE_LIFE, GetUnitState( bj_lastCreatedUnit, UNIT_STATE_MAX_LIFE) )\r\n    call BlzSetUnitArmor( bj_lastCreatedUnit, BlzGetUnitArmor(bj_lastCreatedUnit)*sp )\r\n    call SetUnitMoveSpeed( bj_lastCreatedUnit, GetUnitDefaultMoveSpeed(bj_lastCreatedUnit)*sp )\r\n    call SetUnitScale( bj_lastCreatedUnit, size, size, size )\r\n    call DestroyEffect( AddSpecialEffectTarget( \"Abilities\\\\Spells\\\\Orc\\\\FeralSpirit\\\\feralspirittarget.mdl\", bj_lastCreatedUnit, \"origin\" ) )\r\n\r\n    set caster = null\r\n    set oldpet = null\r\nendfunction\r\n\r\n//===========================================================================\r\nfunction InitTrig_Metal_MageR takes nothing returns nothing\r\n    set gg_trg_Metal_MageR = CreateTrigger(  )\r\n    call TriggerRegisterAnyUnitEventBJ( gg_trg_Metal_MageR, EVENT_PLAYER_UNIT_SPELL_EFFECT )\r\n    call TriggerAddCondition( gg_trg_Metal_MageR, Condition( function Trig_Metal_MageR_Conditions ) )\r\n    call TriggerAddAction( gg_trg_Metal_MageR, function Trig_Metal_MageR_Actions )\r\nendfunction\r\n\r\n",
  "Events": [],
  "LocalVariables": [],
  "Conditions": [],
  "Actions": []
}