{
  "Id": 50332915,
  "Comment": "",
  "IsScript": true,
  "RunOnMapInit": false,
  "Script": "function Trig_Dualism_Conditions takes nothing returns boolean\r\n    return GetSpellAbilityId() == 'A1BK'\r\nendfunction\r\n\r\nfunction Trig_Dualism_Actions takes nothing returns nothing\r\n    local real dmg\r\n    local unit caster\r\n    local unit target\r\n    \r\n    if CastLogic() then\r\n        set caster = udg_Caster\r\n        set target = udg_Target\r\n    elseif RandomLogic() then\r\n        set caster = udg_Caster\r\n        set target = randomtarget( caster, 900, \"all\", \"notfull\", \"\", \"\", \"\" )\r\n        call textst( udg_string[0] + GetObjectName('A1BK'), caster, 64, 90, 10, 1.5 )\r\n        if target == null then\r\n            set caster = null\r\n            return\r\n        endif\r\n    else\r\n        set caster = GetSpellAbilityUnit()\r\n        set target = GetSpellTargetUnit()\r\n    endif\r\n    \r\n    set dmg = 75\r\n     \r\n    call DestroyEffect( AddSpecialEffectTarget( \"Abilities\\\\Spells\\\\Other\\\\Transmute\\\\GoldBottleMissile.mdl\", target, \"overhead\" ) )\r\n    if IsUnitAlly( target, GetOwningPlayer( caster ) ) then\r\n        call healst( caster, target, dmg )\r\n    else\r\n        call UnitTakeDamage( caster, target, dmg, DAMAGE_TYPE_MAGIC)\r\n    endif\r\n    \r\n    set caster = null\r\n    set target = null\r\nendfunction\r\n\r\n//===========================================================================\r\nfunction InitTrig_Dualism takes nothing returns nothing\r\n    set gg_trg_Dualism = CreateTrigger(  )\r\n    call TriggerRegisterAnyUnitEventBJ( gg_trg_Dualism, EVENT_PLAYER_UNIT_SPELL_EFFECT )\r\n    call TriggerAddCondition( gg_trg_Dualism, Condition( function Trig_Dualism_Conditions ) )\r\n    call TriggerAddAction( gg_trg_Dualism, function Trig_Dualism_Actions )\r\n    \r\n    call StackAbilities_AddAbilityStack( 'A1BK', 2, 1, 3 )\r\nendfunction\r\n\r\n",
  "Events": [],
  "LocalVariables": [],
  "Conditions": [],
  "Actions": []
}