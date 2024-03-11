{
  "Id": 50333705,
  "Comment": "",
  "IsScript": true,
  "RunOnMapInit": false,
  "Script": "scope OverloadArena initializer init\r\n\r\n    globals\r\n        public constant integer GOLD_INITIAL_FIRST = 60\r\n        public constant integer GOLD_INITIAL_SECOND = 120\r\n        public constant integer GOLD_EXTRA_PER_KILL = 5\r\n        public constant integer GOLD_CAP = 130\r\n    endglobals\r\n\r\n    function AL_RuneSpawn takes nothing returns nothing\r\n        local integer cyclA = 1\r\n        local integer cyclAEnd = 1\r\n        if udg_modgood[21] then\r\n            set cyclAEnd = cyclAEnd + 1\r\n        endif\r\n        loop\r\n            exitwhen cyclA > cyclAEnd\r\n            call CreateItem( 'I03J' + GetRandomInt( 1, 6 ), GetRandomReal(GetRectMinX(udg_Boss_Rect), GetRectMaxX(udg_Boss_Rect)), GetRandomReal(GetRectMinY(udg_Boss_Rect), GetRectMaxY(udg_Boss_Rect)) )\r\n            set cyclA = cyclA + 1\r\n        endloop\r\n    endfunction\r\n\r\n    function AL_BossSpawn takes integer bossId, integer timerId, timer activeTimer returns nothing\r\n        local unit boss\r\n        local integer rand = GetRandomInt( 1, 4 )\r\n        local real x\r\n        local real y\r\n        local group g = CreateGroup()\r\n        local unit u\r\n\r\n        if bossId != 'o007' and bossId != 'h001' and bossId != 'n04O' then\r\n            set x = GetLocationX( udg_point[rand + 13] )\r\n            set y = GetLocationY( udg_point[rand + 13] )\r\n        else\r\n            set x = GetRectCenterX( udg_Boss_Rect )\r\n            set y = GetRectCenterX( udg_Boss_Rect )\r\n        endif\r\n\r\n        set boss = CreateUnit(Player(10), bossId, x, y, 270 )\r\n        call DestroyEffect( AddSpecialEffectTarget( \"Abilities\\\\Spells\\\\Orc\\\\FeralSpirit\\\\feralspirittarget.mdl\", boss, \"origin\" ) )\r\n        call PingMinimapForForceEx( bj_FORCE_ALL_PLAYERS, GetUnitX( boss ), GetUnitY( boss ), 5, bj_MINIMAPPINGSTYLE_ATTACK, 100, 50, 50 )\r\n        \r\n        if GetUnitTypeId(boss) == 'n00F' then\r\n            set udg_logic[72] = true\r\n            call TriggerExecute( gg_trg_BossDamage )\r\n            set bj_livingPlayerUnitsTypeId = 'h00J'\r\n            call GroupEnumUnitsOfPlayer(g, Player( 10 ), filterLivingPlayerUnitsOfTypeId)\r\n            loop\r\n                set u = FirstOfGroup(g)\r\n                exitwhen u == null\r\n                call RemoveUnit( u )\r\n                call GroupRemoveUnit(g,u)\r\n            endloop\r\n            call FlushChildHashtable( udg_hash, timerId )\r\n            call DestroyTimer( activeTimer )\r\n        endif\r\n        \r\n        set boss = null\r\n        set activeTimer = null\r\n        call GroupClear( g )\r\n        call DestroyGroup( g )\r\n        set u = null\r\n        set g = null\r\n    endfunction\r\n\r\n    function LA_StartSpawn takes nothing returns nothing\r\n        local integer id = GetHandleId( GetExpiredTimer( ) )\r\n        local integer s = 0\r\n        local integer n = 0\r\n        local integer i = 0\r\n        local boolean loopL\r\n\r\n        if not( udg_fightmod[4] ) then\r\n            call FlushChildHashtable( udg_hash, id )\r\n            call DestroyTimer( GetExpiredTimer() )\r\n        else\r\n            set loopL = false\r\n            set s = LoadInteger( udg_hash, id, StringHash( \"LA\" ) ) + 1\r\n            set n = LoadInteger( udg_hash, id, StringHash( \"LAlvl\" ) )\r\n            set i = DB_Boss_id[n][s]\r\n            loop\r\n                exitwhen loopL\r\n                if CountUnitsInGroup(GetUnitsOfTypeIdAll(i)) == 0 and i != 0 then\r\n                    call AL_BossSpawn(i, id, GetExpiredTimer())\r\n                    set loopL = true\r\n                elseif n <= 10 then \r\n                    set s = 1\r\n                    set n = n + 1\r\n                    set i = DB_Boss_id[n][s]\r\n                else\r\n                    set loopL = true\r\n                    call FlushChildHashtable( udg_hash, id )\r\n                    call DestroyTimer( GetExpiredTimer() )\r\n                endif\r\n            endloop\r\n            call SaveInteger( udg_hash, id, StringHash( \"LA\" ), s )\r\n            call SaveInteger( udg_hash, id, StringHash( \"LAlvl\" ), n )\r\n            call AL_RuneSpawn()\r\n        endif\r\n    endfunction\r\n\r\n    function Trig_AL_StartWork_Actions takes nothing returns nothing\r\n        local integer cyclA = 1\r\n        local integer id\r\n        local integer bid\r\n\r\n        set udg_Boss_Rect = gg_rct_RandomItem\r\n        set udg_Boss_BigRect = gg_rct_Vision3\r\n        set udg_fightmod[4] = true\r\n        set udg_ArenaLim[1] = udg_ArenaLim[1] + 1\r\n        set udg_logic[31] = true\r\n        call FightStart()\r\n        call MultiSetColor( udg_multi, 5, 2, 0.00, 0.00, 0.00, 100.00 )\r\n        \r\n        call EnableTrigger( gg_trg_IA_TPBattle )\r\n        call EnableTrigger( gg_trg_BossDamage )\r\n        call EnableTrigger( gg_trg_AL_End )\r\n        call EnableTrigger( ArenaLordsEnd_LastBossKilled )\r\n        \r\n        loop\r\n            exitwhen cyclA > 4\r\n            call CreateUnitAtLoc(Player(10), 'h00J', udg_point[cyclA + 43], ( 90. * cyclA ) - 45. )\r\n            if GetPlayerSlotState(Player(cyclA - 1)) == PLAYER_SLOT_STATE_PLAYING then\r\n                call SetUnitPositionLoc( udg_hero[cyclA], udg_point[cyclA + 17] )\r\n                call PanCameraToTimedLocForPlayer( Player(cyclA - 1), udg_point[( cyclA + 17 )], 0.00 )\r\n                call DestroyEffect( AddSpecialEffect( \"Void Teleport Caster.mdx\" , GetUnitX( udg_hero[cyclA] ), GetUnitY( udg_hero[cyclA] ) ) )\r\n            endif\r\n            set cyclA = cyclA + 1\r\n        endloop\r\n        if udg_Arena_LvL[1] == 0 then\r\n            set udg_number[9] = GOLD_INITIAL_FIRST\r\n            set cyclA = 0\r\n            loop\r\n                exitwhen cyclA > 3\r\n                if GetPlayerSlotState(Player(cyclA)) == PLAYER_SLOT_STATE_PLAYING and udg_LvL[cyclA+1] <= 5 then\r\n                    call DisplayTimedTextToPlayer( Player( cyclA ), 0, 0, 15, \"|cffffcc00'Overlord Arena'|r - an arena in which bosses constantly appear. For each defeated boss you will receive gold.\" )\r\n                    call DisplayTimedTextToPlayer( Player( cyclA ), 0, 0, 15, \"|cffffcc00Death in this arena will not bring defeat.|r\" )\r\n                endif\r\n                set cyclA = cyclA + 1\r\n            endloop\r\n        else\r\n            set udg_number[9] = GOLD_INITIAL_SECOND\r\n        endif\r\n        \r\n        set id = GetHandleId( udg_UNIT_CUTE_BOB )\r\n        if LoadTimerHandle( udg_hash, id, StringHash( \"ALsp\" ) ) == null  then\r\n            call SaveTimerHandle( udg_hash, id, StringHash( \"ALsp\" ), CreateTimer() )\r\n        endif\r\n        set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( \"ALsp\" ) ) ) \r\n        call SaveInteger( udg_hash, id, StringHash( \"LA\" ), 1 )\r\n        if udg_Arena_LvL[1] == 1 then\r\n            set bid = 'e004'\r\n            call SaveInteger( udg_hash, id, StringHash( \"LAlvl\" ), 4 )\r\n        else\r\n            set bid = 'n005'\r\n            call SaveInteger( udg_hash, id, StringHash( \"LAlvl\" ), 1 )\r\n        endif\r\n        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_UNIT_CUTE_BOB ), StringHash( \"ALsp\" ) ), 15, true, function LA_StartSpawn )\r\n        \r\n        set bj_lastCreatedUnit = CreateUnitAtLoc(Player(10), bid, udg_point[13 + GetRandomInt( 1, 4 )],  GetRandomReal( 0, 360 ) )\r\n        call DestroyEffect( AddSpecialEffectTarget( \"Abilities\\\\Spells\\\\Orc\\\\FeralSpirit\\\\feralspirittarget.mdl\", bj_lastCreatedUnit, \"origin\" ) )\r\n        call PingMinimapLocForForceEx( bj_FORCE_ALL_PLAYERS, GetUnitLoc( bj_lastCreatedUnit ), 5, bj_MINIMAPPINGSTYLE_ATTACK, 100, 50, 50 )\r\n        \r\n        //Aggro\r\n        set id = GetHandleId( udg_UNIT_CUTE_BOB )\r\n        if LoadTimerHandle( udg_hash, id, StringHash( \"aggro\" ) ) == null  then\r\n            call SaveTimerHandle( udg_hash, id, StringHash( \"aggro\" ), CreateTimer() )\r\n        endif\r\n        set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( \"aggro\" ) ) ) \r\n        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_UNIT_CUTE_BOB ), StringHash( \"aggro\" ) ), 1, true, function InfiniteArena_Aggro )\r\n        //==================\r\n        \r\n        //Lord of Chaos: Madness\r\n        set cyclA = 1\r\n        loop\r\n            exitwhen cyclA > 4\r\n            if GetUnitAbilityLevel( udg_hero[cyclA], 'A0LK') > 0 and GetPlayerSlotState(Player(cyclA - 1)) == PLAYER_SLOT_STATE_PLAYING then\r\n                call madness( udg_hero[cyclA], GetUnitAbilityLevel( udg_hero[cyclA], 'A0LK') )\r\n            endif\r\n            set cyclA = cyclA + 1\r\n        endloop\r\n        //==================\r\n        \r\n    endfunction\r\n\r\n    //===========================================================================\r\n    private function init takes nothing returns nothing\r\n        set gg_trg_AL_StartWork = CreateTrigger(  )\r\n        call TriggerAddAction( gg_trg_AL_StartWork, function Trig_AL_StartWork_Actions )\r\n    endfunction\r\n\r\nendscope",
  "Events": [],
  "LocalVariables": [],
  "Conditions": [],
  "Actions": []
}