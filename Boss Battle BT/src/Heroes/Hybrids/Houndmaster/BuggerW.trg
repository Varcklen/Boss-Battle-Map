{
  "Id": 50333193,
  "Comment": "",
  "IsScript": true,
  "RunOnMapInit": false,
  "Script": "scope HoundmasterW initializer init\r\n\r\n\tglobals\r\n\t\tprivate constant integer ABILITY_ID = 'A0MX'\r\n\t\t\r\n\t\tprivate constant string ANIMATION = \"Abilities\\\\Spells\\\\Human\\\\FlakCannons\\\\FlakTarget.mdl\"\r\n\t\t\r\n\t\tprivate constant integer EFFECT_ID = 'A0N9'\r\n\t\tprivate constant integer BUFF_ID = 'B033'\r\n\t\t\r\n\t\tprivate constant real DURATION_INITIAL = 1.5\r\n\t\tprivate constant real DURATION_PER_LEVEL = 0.5\r\n\t\t\r\n\t\tprivate constant real HEAL_TICK = 0.5\r\n\t\tprivate constant real HEAL_PERCENT = 0.02\r\n\tendglobals\r\n\r\n\tprivate function conidition takes nothing returns boolean\r\n\t    return GetSpellAbilityId() == ABILITY_ID\r\n\tendfunction\r\n\t\r\n\tprivate function BuffClear takes unit target returns nothing\r\n    \tcall UnitRemoveAbility( target, EFFECT_ID )\r\n        call UnitRemoveAbility( target, BUFF_ID )\r\n    endfunction\r\n    \r\n    private function tick takes nothing returns nothing\r\n\t    local integer id = GetHandleId( GetExpiredTimer( ) )\r\n\t    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( \"houndmaster_w_tick_caster\" ) )\r\n\t    local unit target = LoadUnitHandle( udg_hash, id, StringHash( \"houndmaster_w_tick_target\" ) )\r\n\t    local real heal = GetUnitState(target, UNIT_STATE_MAX_LIFE) * HEAL_PERCENT\r\n\t\r\n\t    if GetUnitAbilityLevel(target, EFFECT_ID) > 0 then\r\n\t        call healst(caster, target, heal)\r\n\t    else\r\n\t        call DestroyTimer( GetExpiredTimer() )\r\n\t    endif\r\n\t    \r\n\t    set caster = null\r\n\t    set target = null\r\n\tendfunction\r\n    \r\n    private function AddBuff takes unit caster, unit target, real duration returns nothing\r\n    \tlocal integer id = GetHandleId(target)\r\n    \t\r\n\t\tcall bufst( caster, target, EFFECT_ID, BUFF_ID, \"houndmaster_w\", duration + 0.01 )\r\n\t    call DestroyEffect( AddSpecialEffectTarget( ANIMATION, target, \"origin\" ) )\r\n\t    \r\n\t    if LoadTimerHandle( udg_hash, id, StringHash( \"houndmaster_w_tick\" ) ) == null then\r\n\t        call SaveTimerHandle( udg_hash, id, StringHash( \"houndmaster_w_tick\" ), CreateTimer() )\r\n\t    endif\r\n\t\tset id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( \"houndmaster_w_tick\" ) ) ) \r\n\t\tcall SaveUnitHandle( udg_hash, id, StringHash( \"houndmaster_w_tick_caster\" ), caster )\r\n\t    call SaveUnitHandle( udg_hash, id, StringHash( \"houndmaster_w_tick_target\" ), target )\r\n\t\tcall TimerStart( LoadTimerHandle( udg_hash, GetHandleId( target ), StringHash( \"houndmaster_w_tick\" ) ), HEAL_TICK, true, function tick )\r\n\t\t\r\n\t\tset caster = null\r\n\t    set target = null\r\n    endfunction\r\n\t\r\n\tprivate function action takes nothing returns nothing\r\n\t    local integer lvl\r\n\t    local unit caster\r\n\t    local unit pet\r\n\t    local real t\r\n\t    \r\n\t    if CastLogic() then\r\n\t        set caster = udg_Caster\r\n\t        set pet = null\r\n\t        set lvl = udg_Level\r\n\t        set t = udg_Time\r\n\t    elseif RandomLogic() then\r\n\t        set caster = udg_Caster\r\n\t        set lvl = udg_Level\r\n\t        set pet = null\r\n\t        call textst( udg_string[0] + GetObjectName(ABILITY_ID), caster, 64, 90, 10, 1.5 )\r\n\t        set t = DURATION_INITIAL + (DURATION_PER_LEVEL*lvl)\r\n\t    else\r\n\t        set caster = GetSpellAbilityUnit()\r\n\t        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())\r\n\t        set t = DURATION_INITIAL + (DURATION_PER_LEVEL*lvl)\r\n\t    endif\r\n\t    set t = timebonus(caster, t)\r\n\t\r\n\t    set pet = LoadUnitHandle( udg_hash, GetHandleId( caster ), StringHash( \"houndmaster_r_pet\" ) )\r\n\t    \r\n\t    call AddBuff(caster, caster, t)\r\n\t    \r\n\t    if pet != null and IsUnitAliveBJ(pet) and GetOwningPlayer(caster) == GetOwningPlayer(pet) then\r\n\t        call AddBuff(caster, pet, t)\r\n\t    endif\r\n\t    \r\n\t    set pet = null\r\n\t    set caster = null\r\n\tendfunction\r\n\t\r\n    //===========================================================================\r\n\tprivate function DeleteBuff_Conditions takes nothing returns boolean\r\n        return GetUnitAbilityLevel( Event_DeleteBuff_Unit, EFFECT_ID) > 0\r\n    endfunction\r\n    \r\n    private function DeleteBuff takes nothing returns nothing\r\n    \tcall BuffClear(Event_DeleteBuff_Unit)\r\n    endfunction\r\n\t\r\n\t//===========================================================================\r\n\tprivate function init takes nothing returns nothing\r\n\t    set gg_trg_BuggerW = CreateTrigger(  )\r\n\t    call TriggerRegisterAnyUnitEventBJ( gg_trg_BuggerW, EVENT_PLAYER_UNIT_SPELL_EFFECT )\r\n\t    call TriggerAddCondition( gg_trg_BuggerW, Condition( function conidition ) )\r\n\t    call TriggerAddAction( gg_trg_BuggerW, function action )\r\n\t    \r\n\t    call CreateEventTrigger( \"Event_DeleteBuff_Real\", function DeleteBuff, function DeleteBuff_Conditions )\r\n\tendfunction\r\n\t\r\nendscope",
  "Events": [],
  "LocalVariables": [],
  "Conditions": [],
  "Actions": []
}