{
  "Id": 503330721,
  "Comment": "",
  "IsScript": true,
  "RunOnMapInit": false,
  "Script": "scope RunesmithQ initializer init\r\n\r\n    globals\r\n            private constant integer ID_ABILITY = 'A1E4'\r\n            private constant string ID_HASH_TS = \"runesmith_ts\"\r\n            private constant string EFFECT = \"Abilities\\\\Spells\\\\Human\\\\Thunderclap\\\\ThunderClapCaster.mdl\"\r\n    endglobals\r\n    \r\n    private function Trig_RunesmithQ_Conditions takes nothing returns boolean\r\n        return GetSpellAbilityId() == ID_ABILITY and combat( GetSpellAbilityUnit(), true, GetSpellAbilityId() )\r\n    endfunction\r\n    \r\n    function Trig_RunesmithQ_Actions takes nothing returns nothing\r\n        local unit caster\r\n        local integer charge\r\n        local integer lvl\r\n        \r\n        if CastLogic() then\r\n            set caster = udg_Caster\r\n            set lvl = udg_Level\r\n        elseif RandomLogic() then\r\n            set caster = udg_Caster\r\n            set lvl = udg_Level\r\n            call textst( udg_string[0] + GetObjectName(ID_ABILITY), caster, 64, 90, 10, 1.5 )\r\n        else\r\n            set caster = GetSpellAbilityUnit()\r\n            set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())\r\n        endif\r\n        \r\n        set charge =  LoadInteger( udg_hash, GetHandleId( caster ), StringHash( ID_HASH_TS ))\r\n        \r\n        if charge < lvl then\r\n            set charge = charge + 1\r\n            call SaveInteger( udg_hash, GetHandleId( caster ), StringHash( ID_HASH_TS ), charge )\r\n            call textst(\"|c00fEBA0E\" + I2S(charge), caster, 64 , 90 , 10 , 1)\r\n            call DestroyEffect( AddSpecialEffectTarget(EFFECT, caster, \"origin\" ) )\r\n        else\r\n            call textst(\"|c00fEBA0EMAX\", caster, 64 , 90 , 10 , 1)\r\n        endif\r\n        \r\n        set caster = null\r\n    endfunction\r\n\r\n    //===========================================================================\r\n    private function init takes nothing returns nothing\r\n        set gg_trg_RunesmithQ = CreateTrigger( )\r\n        call TriggerRegisterAnyUnitEventBJ( gg_trg_RunesmithQ, EVENT_PLAYER_UNIT_SPELL_EFFECT )\r\n        call TriggerAddCondition( gg_trg_RunesmithQ, Condition( function Trig_RunesmithQ_Conditions ) )\r\n        call TriggerAddAction( gg_trg_RunesmithQ, function Trig_RunesmithQ_Actions )\r\n    endfunction\r\n    \r\nendscope",
  "Events": [],
  "LocalVariables": [],
  "Conditions": [],
  "Actions": []
}