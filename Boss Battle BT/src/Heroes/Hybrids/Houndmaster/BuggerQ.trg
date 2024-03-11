{
  "Id": 50333192,
  "Comment": "",
  "IsScript": true,
  "RunOnMapInit": false,
  "Script": "scope HoundmasterQ initializer init\r\n\r\n\tglobals\r\n\t\tprivate constant integer ABILITY_ID = 'A105'\r\n\t\tprivate constant integer PER_TELEPORTATION_SCATTER = 128\r\n\t\t\r\n\t\tprivate constant string ANIMATION = \"Abilities\\\\Spells\\\\Human\\\\FlakCannons\\\\FlakTarget.mdl\"\r\n\tendglobals\r\n\r\n\tprivate function condition takes nothing returns boolean\r\n\t    return GetSpellAbilityId() == ABILITY_ID //and combat( GetSpellAbilityUnit(), true, GetSpellAbilityId() )\r\n\tendfunction\r\n\t\r\n\tprivate function action takes nothing returns nothing\r\n\t    local unit caster\r\n\t    local unit target\r\n\t    local integer lvl\r\n\t    local unit pet\r\n\t    \r\n\t    if CastLogic() then\r\n\t        set caster = udg_Caster\r\n\t        set target = udg_Target\r\n\t        set lvl = udg_Level\r\n\t    elseif RandomLogic() then\r\n\t        set caster = udg_Caster\r\n\t        set target = randomtarget( caster, 900, \"enemy\", \"\", \"\", \"\", \"\" )\r\n\t        set lvl = udg_Level\r\n\t        call textst( udg_string[0] + GetObjectName(ABILITY_ID), caster, 64, 90, 10, 1.5 )\r\n\t        if target == null then\r\n\t            set caster = null\r\n\t            return\r\n\t        endif\r\n\t    else\r\n\t        set caster = GetSpellAbilityUnit()\r\n\t        set target = GetSpellTargetUnit()\r\n\t        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())\r\n\t    endif\r\n\t\r\n\t\tset pet = LoadUnitHandle( udg_hash, GetHandleId( caster ), StringHash( \"houndmaster_r_pet\" ) )\r\n\t\t\r\n\t\tif pet == null or IsUnitDeadBJ(pet) then\r\n\t\t\tset pet = null\r\n\t\t    set caster = null\r\n\t\t    set target = null\r\n\t\t    return\r\n\t\tendif\r\n\t\r\n\t\tcall DestroyEffect( AddSpecialEffect( ANIMATION, GetUnitX(pet), GetUnitY(pet) ) )\r\n\t\tcall SetUnitPosition( pet, Math_GetUnitRandomX(target, PER_TELEPORTATION_SCATTER), Math_GetUnitRandomY(target, PER_TELEPORTATION_SCATTER) )\r\n\t\tcall DestroyEffect( AddSpecialEffect( ANIMATION, GetUnitX(pet), GetUnitY(pet) ) )\r\n\t\t\r\n\t\tcall IssueImmediateOrder( pet, \"stop\" )\r\n\t\tcall IssueTargetOrder( pet, \"attack\", target )\r\n        call IssueTargetOrder( pet, \"chainlightning\", target )\r\n\t    \r\n\t    set pet = null\r\n\t    set caster = null\r\n\t    set target = null\r\n\tendfunction\r\n\t\r\n\t//===========================================================================\r\n\tprivate function init takes nothing returns nothing\r\n\t    set gg_trg_BuggerQ = CreateTrigger(  )\r\n\t    call TriggerRegisterAnyUnitEventBJ( gg_trg_BuggerQ, EVENT_PLAYER_UNIT_SPELL_EFFECT )\r\n\t    call TriggerAddCondition( gg_trg_BuggerQ, Condition( function condition ) )\r\n\t    call TriggerAddAction( gg_trg_BuggerQ, function action )\r\n\tendfunction\r\n\r\nendscope",
  "Events": [],
  "LocalVariables": [],
  "Conditions": [],
  "Actions": []
}