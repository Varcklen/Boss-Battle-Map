{
  "Id": 50333152,
  "Comment": "",
  "IsScript": true,
  "RunOnMapInit": false,
  "Script": "scope GamblerR initializer init\r\n\r\n    globals\r\n        private constant integer ID_ABILITY = 'A11J'\r\n        \r\n        private constant integer LUCK_BONUS = 100\r\n        private constant integer DURATION_FIRST_LEVEL = 8\r\n        private constant integer DURATION_LEVEL_BONUS = 2\r\n        \r\n        private constant integer EFFECT = 'A11Q'\r\n        private constant integer BUFF = 'B06S'\r\n        \r\n        private constant string ANIMATION = \"Abilities\\\\Spells\\\\Human\\\\Slow\\\\SlowCaster.mdl\"\r\n    endglobals\r\n\r\n    function Trig_GamblerR_Conditions takes nothing returns boolean\r\n        return GetSpellAbilityId() == ID_ABILITY and combat( GetSpellAbilityUnit(), true, GetSpellAbilityId() ) and not( udg_fightmod[3] )\r\n    endfunction\r\n\r\n    function GamblerRCast takes nothing returns nothing\r\n        local integer id = GetHandleId( GetExpiredTimer( ) )\r\n        local unit u = LoadUnitHandle( udg_hash, id, StringHash( \"gmbr\" ) )\r\n        local integer luckBonus = LoadInteger( udg_hash, GetHandleId( u ), StringHash( \"gmbr\" ) )\r\n        \r\n        call luckyst( u, -luckBonus )\r\n        call UnitRemoveAbility( u, EFFECT )\r\n        call UnitRemoveAbility( u, BUFF )\r\n        \r\n        call RemoveSavedInteger( udg_hash, GetHandleId( u ), StringHash( \"gmbr\" ) )\r\n        call FlushChildHashtable( udg_hash, id )\r\n\r\n        set u = null\r\n    endfunction\r\n\r\n    function Trig_GamblerR_Actions takes nothing returns nothing\r\n        local integer isum\r\n        local unit caster\r\n        local real t\r\n        local integer lvl\r\n        \r\n        if CastLogic() then\r\n            set caster = udg_Caster\r\n            set lvl = udg_Level\r\n            set t = udg_Time\r\n        elseif RandomLogic() then\r\n            set caster = udg_Caster\r\n            set lvl = udg_Level\r\n            call textst( udg_string[0] + GetObjectName(ID_ABILITY), caster, 64, 90, 10, 1.5 )\r\n            set t = DURATION_FIRST_LEVEL + (DURATION_LEVEL_BONUS*lvl)\r\n        else\r\n            set caster = GetSpellAbilityUnit()\r\n            set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId() )\r\n            set t = DURATION_FIRST_LEVEL + (DURATION_LEVEL_BONUS*lvl)\r\n        endif\r\n        set t = timebonus(caster, t)\r\n\r\n        if IsUnitType( caster, UNIT_TYPE_HERO) then\r\n            call luckyst( caster, LUCK_BONUS )\r\n            set isum = LoadInteger( udg_hash, GetHandleId( caster ), StringHash( \"gmbr\" ) ) + LUCK_BONUS\r\n            \r\n            call UnitAddAbility( caster, EFFECT)\r\n            call DestroyEffect( AddSpecialEffectTarget( ANIMATION, caster, \"overhead\") )\r\n            \r\n            call InvokeTimerWithUnit(caster, \"gmbr\", t, false, function GamblerRCast)\r\n            call SaveInteger( udg_hash, GetHandleId( caster ), StringHash( \"gmbr\" ), isum )\r\n        endif\r\n        \r\n        set caster = null\r\n    endfunction\r\n    \r\n    private function DeleteBuff_Conditions takes nothing returns boolean\r\n        return GetUnitAbilityLevel( Event_DeleteBuff_Unit, EFFECT) > 0\r\n    endfunction\r\n    \r\n    private function DeleteBuff takes nothing returns nothing\r\n        local unit hero = Event_DeleteBuff_Unit\r\n        local integer luckBonus = LoadInteger( udg_hash, GetHandleId( hero ), StringHash( \"gmbr\" ) )\r\n\r\n        call luckyst( hero, -luckBonus )\r\n        call UnitRemoveAbility( hero, EFFECT )\r\n        call UnitRemoveAbility( hero, BUFF )\r\n        call RemoveSavedInteger( udg_hash, GetHandleId( hero ), StringHash( \"gmbr\" ) )\r\n        \r\n        set hero = null\r\n    endfunction\r\n\r\n    //===========================================================================\r\n    private function init takes nothing returns nothing\r\n        set gg_trg_GamblerR = CreateTrigger(  )\r\n        call TriggerRegisterAnyUnitEventBJ( gg_trg_GamblerR, EVENT_PLAYER_UNIT_SPELL_EFFECT )\r\n        call TriggerAddCondition( gg_trg_GamblerR, Condition( function Trig_GamblerR_Conditions ) )\r\n        call TriggerAddAction( gg_trg_GamblerR, function Trig_GamblerR_Actions )\r\n        \r\n        call CreateEventTrigger( \"Event_DeleteBuff_Real\", function DeleteBuff, function DeleteBuff_Conditions )\r\n    endfunction\r\n\r\nendscope\r\n\r\n",
  "Events": [],
  "LocalVariables": [],
  "Conditions": [],
  "Actions": []
}