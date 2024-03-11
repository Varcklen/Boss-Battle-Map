{
  "Id": 50333005,
  "Comment": "",
  "IsScript": true,
  "RunOnMapInit": false,
  "Script": "scope MinotaurE initializer init\r\n\r\n\tglobals\r\n\t\tprivate constant integer ABILITY_ID = 'A083'\r\n\t\t\r\n\t\tprivate constant integer STR_INCREASE_INITIAL = 2\r\n\t\tprivate constant integer STR_INCREASE_PER_LEVEL = 4\r\n\t\t\r\n\t\tprivate constant integer AGI_INCREASE_INITIAL = 1\r\n\t\tprivate constant integer AGI_INCREASE_PER_LEVEL = 2\r\n\t\t\t\r\n\t\tprivate constant integer INT_INCREASE_INITIAL = 1\r\n\t\tprivate constant integer INT_INCREASE_PER_LEVEL = 2\r\n\tendglobals\r\n\r\n\tprivate function condition takes nothing returns boolean\r\n\t    return GetLearnedSkill() == ABILITY_ID\r\n\tendfunction\r\n\t\r\n\tprivate function action takes nothing returns nothing\r\n\t\tlocal unit caster = GetLearningUnit()\r\n\t\t\r\n\t\tif GetUnitAbilityLevel( caster, ABILITY_ID) == 1 then\r\n\t        call statst( caster, STR_INCREASE_INITIAL, AGI_INCREASE_INITIAL, INT_INCREASE_INITIAL, 0, false )\r\n\t\tendif\r\n\t    call statst( caster, STR_INCREASE_PER_LEVEL, AGI_INCREASE_PER_LEVEL, INT_INCREASE_PER_LEVEL, 0, false )\r\n\t    \r\n\t    set caster = null\r\n\tendfunction\r\n\t\r\n\tprivate function condition_null takes nothing returns boolean\r\n\t    return GetUnitAbilityLevel( udg_Event_NullingAbility_Unit, ABILITY_ID) > 0\r\n\tendfunction\r\n\t\r\n\tprivate function action_null takes nothing returns nothing\r\n\t\tlocal unit caster = udg_Event_NullingAbility_Unit\r\n\t\tlocal integer level = GetUnitAbilityLevel( caster, ABILITY_ID)\r\n\t\tlocal integer strToLose = STR_INCREASE_INITIAL + (STR_INCREASE_PER_LEVEL*level)\r\n\t\tlocal integer agiToLose = AGI_INCREASE_INITIAL + (AGI_INCREASE_PER_LEVEL*level)\r\n\t\tlocal integer intToLose = INT_INCREASE_INITIAL + (INT_INCREASE_PER_LEVEL*level)\r\n\t\t\r\n        call statst( caster, -strToLose, -agiToLose, -intToLose, 0, false )\r\n        \r\n        set caster = null\r\n\tendfunction\r\n\t\r\n\t//===========================================================================\r\n\tprivate function init takes nothing returns nothing\r\n\t    set gg_trg_MinP = CreateTrigger(  )\r\n\t    call TriggerRegisterAnyUnitEventBJ( gg_trg_MinP, EVENT_PLAYER_HERO_SKILL )\r\n\t    call TriggerAddCondition( gg_trg_MinP, Condition( function condition ) )\r\n\t    call TriggerAddAction( gg_trg_MinP, function action )\r\n\t    \r\n\t    call CreateEventTrigger( \"udg_Event_NullingAbility_Real\", function action_null, function condition_null )\r\n\tendfunction\r\n\r\nendscope",
  "Events": [],
  "LocalVariables": [],
  "Conditions": [],
  "Actions": []
}