{
  "Id": 50333433,
  "Comment": "",
  "IsScript": true,
  "RunOnMapInit": false,
  "Script": "scope Totem2 initializer init\r\n\r\n    globals\r\n        private constant integer ID_SHADOW = 'n035'\r\n    \r\n        private constant integer ACTIVATE_DISTANCE = 300\r\n        private constant integer DISTANCE = 1200\r\n        private constant integer HEALTH_CHECK = 75\r\n        private constant integer DAMAGE = 45\r\n        \r\n        private constant real TICK_CHECK = 0.5\r\n    endglobals\r\n\r\n    private function Trig_Totem2_Conditions takes nothing returns boolean\r\n        return GetUnitTypeId( udg_DamageEventTarget ) == Totem1_ID_BOSS and GetUnitLifePercent( udg_DamageEventTarget ) <= HEALTH_CHECK\r\n    endfunction\r\n\r\n    private function Totem2Cast takes nothing returns nothing\r\n        local integer id = GetHandleId( GetExpiredTimer() )\r\n        local integer i = 1\r\n        local unit boss = LoadUnitHandle( udg_hash, id, StringHash( \"bstm3t\" ) )\r\n        local unit shadow = LoadUnitHandle( udg_hash, id, StringHash( \"bstm3\" ) )\r\n        \r\n        if IsUnitDead( boss ) or IsUnitDead( shadow ) or udg_fightmod[0] == false then\r\n            call FlushChildHashtable( udg_hash, id )\r\n            call DestroyTimer( GetExpiredTimer() )\r\n        elseif DistanceBetweenUnits(boss, shadow) <= ACTIVATE_DISTANCE then\r\n            call KillUnit( shadow )\r\n            loop\r\n                exitwhen i > PLAYERS_LIMIT\r\n                if IsUnitAlive( udg_hero[i] ) then\r\n                    call Totem1_SpawnFireArea(boss, GetUnitX( udg_hero[i] ), GetUnitY( udg_hero[i] ), DAMAGE )\r\n                endif\r\n                set i = i + 1\r\n            endloop\r\n            call FlushChildHashtable( udg_hash, id )\r\n            call DestroyTimer( GetExpiredTimer() )\r\n        endif\r\n        \r\n        set boss = null\r\n        set shadow = null\r\n    endfunction\r\n\r\n    public function SpawnShadows takes unit boss returns nothing\r\n        local integer id\r\n        local integer i = 1\r\n        local real x\r\n        local real y\r\n    \r\n        loop\r\n            exitwhen i > PLAYERS_LIMIT\r\n            if IsUnitAlive( udg_hero[i] ) then\r\n                set x = GetUnitX(boss) + DISTANCE * Cos((45 + ( 90 * i )) * bj_DEGTORAD)\r\n                set y = GetUnitY(boss) + DISTANCE * Sin((45 + ( 90 * i )) * bj_DEGTORAD)\r\n                set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( boss ), ID_SHADOW, x, y, 270)\r\n                call PingMinimapLocForForceEx( bj_FORCE_ALL_PLAYERS, GetUnitLoc(bj_lastCreatedUnit), 5, bj_MINIMAPPINGSTYLE_ATTACK, 100, 50, 50 )\r\n                call IssuePointOrder( bj_lastCreatedUnit, \"move\", GetUnitX( boss ), GetUnitY( boss ) )\r\n\r\n                set id = InvokeTimerWithUnit(bj_lastCreatedUnit, \"bstm3\", TICK_CHECK, true, function Totem2Cast )\r\n                call SaveUnitHandle( udg_hash, id, StringHash( \"bstm3t\" ), boss )\r\n            endif\r\n            set i = i + 1\r\n        endloop\r\n        \r\n        set boss = null\r\n    endfunction\r\n    \r\n    private function Trig_Totem2_Actions takes nothing returns nothing\r\n        call DisableTrigger( GetTriggeringTrigger() )\r\n        call SpawnShadows(udg_DamageEventTarget)\r\n    endfunction\r\n\r\n    //===========================================================================\r\n    private function init takes nothing returns nothing\r\n        set gg_trg_Totem2 = CreateEventTrigger( \"udg_AfterDamageEvent\", function Trig_Totem2_Actions, function Trig_Totem2_Conditions )\r\n        call DisableTrigger( gg_trg_Totem2 )\r\n    endfunction\r\n\r\nendscope",
  "Events": [],
  "LocalVariables": [],
  "Conditions": [],
  "Actions": []
}