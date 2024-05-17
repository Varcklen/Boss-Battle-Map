{
  "Id": 50333397,
  "Comment": "",
  "IsScript": true,
  "RunOnMapInit": false,
  "Script": "globals\r\n    real Event_MainBattleWin = 0\r\nendglobals\r\n\r\nfunction SetNextBossInfoIcon takes nothing returns nothing\r\n\tlocal integer bossInfo\r\n\r\n\tif udg_Boss_LvL >= 10 then\r\n\t\tcall IconFrameDel( \"boss\" )\r\n\t\treturn\r\n\tendif\r\n\t\r\n    set bossInfo = Boss_Info[udg_Boss_LvL][udg_Boss_Random]\r\n    call IconFrame( \"boss\", BlzGetAbilityIcon(bossInfo), BlzGetAbilityTooltip(bossInfo, 0), BlzGetAbilityExtendedTooltip(bossInfo, 0) )\r\n        \r\n    //call IconFrame( \"boss\", BlzGetAbilityIcon(Boss_Info[udg_Boss_LvL][udg_Boss_Random]), BlzGetAbilityTooltip(v, 0), BlzGetAbilityExtendedTooltip(v, 0) )\r\nendfunction\r\n\r\nfunction SetNextBattleInfo takes nothing returns nothing\r\n\tlocal integer info\r\n\tif IsNextBattleInfiniteArena() then\r\n\t\tset info = 'A1EQ'\r\n\t\tcall IconFrame( \"boss\", BlzGetAbilityIcon(info), BlzGetAbilityTooltip(info, 0), BlzGetAbilityExtendedTooltip(info, 0) )\r\n\telseif IsNextBattleOverlordArena() then\r\n\t\tset info = 'A1EP'\r\n\t\tcall IconFrame( \"boss\", BlzGetAbilityIcon(info), BlzGetAbilityTooltip(info, 0), BlzGetAbilityExtendedTooltip(info, 0) )\r\n\telse\r\n\t\tcall SetNextBossInfoIcon()\r\n\tendif\r\nendfunction\r\n\r\nfunction Trig_EndFightWork_Actions takes nothing returns nothing\r\n    local integer cyclA\r\n    local integer cyclAEnd\r\n    local integer cyclB\r\n    local integer cyclBEnd\r\n    local integer cyclC\r\n    local boolean l = false\r\n    local integer rand \r\n    local integer id\r\n    local integer maxpvp = 0\r\n    local boolean k = false\r\n    local integer j = 0\r\n    local integer p = 0\r\n    local integer v = 0\r\n    local integer g\r\n    local integer array b\r\n    \r\n    set MainBoss = null\r\n    set udg_fightmod[1] = false\r\n    //call DisableTrigger( gg_trg_HeroDeath )\r\n    call DisableTrigger( gg_trg_Equality )\r\n    call DisableTrigger( gg_trg_MinionsTeleportation )\r\n    set udg_Heroes_Ressurect_Battle = 0\r\n\r\n    /*if udg_Endgame == 1 then\r\n        call MMD_LogEvent0(\"boss_kill\" )\r\n    endif*/\r\n\r\n    if udg_Boss_LvL != 10 then\r\n        call IconFrameDel( \"boss\" )\r\n        if udg_logic[78] and udg_Boss_LvL > 1 then\r\n            call IconFrameDel( \"second boss\" )\r\n        endif\r\n    endif\r\n\r\n    set udg_Boss_LvL = udg_Boss_LvL + 1\r\n    if udg_Boss_LvL > 10 then\r\n        set udg_Boss_LvL = 10\r\n        set k = true\r\n    endif\r\n    \r\n    if udg_Boss_LvL == 10 then\r\n        set udg_Boss_Random = udg_LastBoss\r\n        if udg_Boss_Random == 0 then\r\n            set udg_Boss_Random = GetRandomInt( 1, 6 )\r\n        endif\r\n    elseif udg_Boss_LvL == 5 or udg_Boss_LvL == 7 or udg_Boss_LvL == 4 or udg_Boss_LvL == 9 or udg_Boss_LvL == 8 then\r\n        set udg_Boss_Random = GetRandomInt( 1, 6 )\r\n    else\r\n        set udg_Boss_Random = GetRandomInt( 1, 5 )\r\n    endif\r\n\r\n    call MultiSetValue( udg_multi, 5, 1, I2S( udg_Boss_LvL ) + \"/10\" )\r\n    call BlzFrameSetText(lvltext, I2S( udg_Boss_LvL ) + \"/10\")\r\n    call RemoveItemFromStock( udg_UNIT_JULE, 'texp' )\r\n    if udg_worldmod[1] then\r\n        call BlzFrameSetVisible( sklbk,false)\r\n        call BlzFrameSetVisible( refbk,false)\r\n    endif\r\n\r\n    set cyclA = 1\r\n    loop \r\n        exitwhen cyclA > 4\r\n        if GetPlayerSlotState(Player( cyclA - 1) ) == PLAYER_SLOT_STATE_PLAYING then\r\n            //call MMD_UpdateValueInt (\"bosses_killed\", Player(cyclA-1), MMD_OP_SET, udg_Boss_LvL )\r\n            set udg_roll[cyclA] = udg_rollbase[cyclA]\r\n            set udg_logic[47+cyclA] = false\r\n            if udg_Heroes_Amount > 1 and udg_number[69 + cyclA] > 0 and udg_worldmod[1] and GetLocalPlayer() == Player(cyclA-1) then\r\n                call BlzFrameSetVisible( pvpbk,true)\r\n            endif\r\n            if IsUnitInGroup(udg_UnitHero[27], udg_heroinfo) and IsUnitAlly(udg_hero[cyclA], GetOwningPlayer(udg_UnitHero[27])) then\r\n                call UnitRemoveAbility( udg_hero[cyclA], 'B04Z' )\r\n                set udg_logic[3] = true\r\n            endif\r\n            call moneyst( udg_hero[cyclA], ( udg_Boss_LvL - 1 ) * 100 )\r\n            set udg_number[cyclA + 69] = udg_number[cyclA + 69] + 1\r\n            if not(udg_logic[95]) then\r\n                if udg_logic[cyclA + 43] then\r\n                    set udg_logic[cyclA + 43] = false\r\n                else\r\n                    call SetHeroLevel( udg_hero[cyclA], GetHeroLevel(udg_hero[cyclA]) + 1, true )\r\n                endif\r\n            endif\r\n            call SetUnitPositionLoc( udg_hero[cyclA], udg_point[cyclA + 21] )\r\n            call SetUnitFacing( udg_hero[cyclA], 90 )\r\n            call PanCameraToTimedLocForPlayer( Player(cyclA - 1), udg_point[cyclA + 21], 0 ) \r\n            set cyclB = 1\r\n            loop\r\n                exitwhen cyclB > 6\r\n                call UnitRemoveAbility( udg_unit[cyclA + 17], Boss_Info[udg_Boss_LvL-1][cyclB] )\r\n                call UnitRemoveAbility( udg_UNIT_INFORMANT, Boss_Info[udg_Boss_LvL-1][cyclB] )\r\n                set cyclB = cyclB + 1\r\n            endloop\r\n        endif\r\n        set cyclA = cyclA + 1\r\n    endloop\r\n  \r\n    if udg_Preset[0] and udg_Boss_LvL == 2 and udg_Endgame == 1 then\r\n        set cyclA = 1\r\n        set cyclAEnd = udg_DB_ModesFrame_RotationNum\r\n        loop\r\n            exitwhen cyclA > cyclAEnd\r\n            if udg_Preset[cyclA] then\r\n                call TriggerExecute( udg_DB_Rotation[cyclA] )\r\n                set cyclA = cyclAEnd\r\n            endif\r\n            set cyclA = cyclA + 1\r\n        endloop\r\n        \r\n        set cyclA = 1\r\n        set g = 0\r\n        loop\r\n            exitwhen cyclA > udg_DB_ModesFrame_RotationUD\r\n            set cyclB = 1\r\n            loop\r\n                exitwhen cyclB > udg_DB_ModesFrame_RotationLR\r\n                set g = g + 1\r\n                if udg_Preset[g] then\r\n                    set p = DB_ModesFrame_Rotation[cyclB][cyclA]\r\n                    call IconFrame( \"Preset\", BlzGetAbilityIcon(p), BlzGetAbilityTooltip(p, 0), BlzGetAbilityExtendedTooltip(p, 0) )\r\n                endif\r\n                set cyclB = cyclB + 1\r\n            endloop\r\n            set cyclA = cyclA + 1\r\n        endloop  \r\n        \r\n        if udg_Preset[6] then\r\n            call SetRaritySpawn( 0, 0 )\r\n        endif\r\n    endif\r\n  \r\n  \tif not(udg_logic[99]) then\r\n    \tcall JuleRef()\r\n    else\r\n        set udg_logic[99] = false\r\n        call IconFrameDel( \"Contract\" )\r\n        call BlzFrameSetVisible( julecont, true )\r\n    endif\r\n  \r\n  \tset Event_MainBattleWin = 1\r\n    set Event_MainBattleWin = 0\r\n  \r\n    call FightEnd()\r\n    \r\n    if udg_Boss_LvL == 2 then\r\n        call BlzFrameSetVisible( scrbk, true )\r\n        set cyclA = 1\r\n        loop\r\n            exitwhen cyclA > 4\r\n            if GetPlayerSlotState(Player( cyclA-1 ) ) == PLAYER_SLOT_STATE_PLAYING and udg_LvL[cyclA] >= 13 then\r\n                call SetPlayerState( Player( cyclA-1 ), PLAYER_STATE_RESOURCE_GOLD, GetPlayerState( Player( cyclA-1 ), PLAYER_STATE_RESOURCE_GOLD ) + 100 )\r\n            endif\r\n            set cyclA = cyclA + 1\r\n        endloop \r\n    \r\n        set udg_LastBoss = GetRandomInt( 1, 6 )\r\n        \r\n        set b[1] = 'A06L'\r\n        set b[2] = 'A0VH'\r\n        set b[3] = 'A09E'\r\n        set b[4] = 'A09K'\r\n        set b[5] = 'A0DF'\r\n        set b[6] = 'A0SM'\r\n        \r\n        if udg_Endgame == 1 then\r\n            call Mods_Awake()\r\n        endif\r\n        \r\n        call IconFrame( \"Last Boss\", BlzGetAbilityIcon(b[udg_LastBoss]), BlzGetAbilityTooltip(b[udg_LastBoss], 0), BlzGetAbilityExtendedTooltip(b[udg_LastBoss], 0) )\r\n        \r\n        if AnyHasLvL(5) == false then\r\n            call DisplayTimedTextToForce( bj_FORCE_ALL_PLAYERS, 10, \"Now you have access to arenas at |cffffcc00Cute Bob|r!\" )\r\n        endif\r\n    elseif udg_Boss_LvL == 3 then\r\n        if IsHardcoreEnabled then\r\n            call RemoveUnit( udg_UNIT_QUARTERMASTER )\r\n        endif\r\n    elseif udg_Boss_LvL == 4 then\r\n        call DisableTrigger( gg_trg_UnitChoose )\r\n    elseif udg_Boss_LvL == 5 then\r\n        if not(IsHardcoreEnabled) then\r\n            call RemoveUnit( udg_UNIT_QUARTERMASTER )\r\n        endif\r\n    endif\r\n    set cyclA = 1\r\n    loop\r\n        exitwhen cyclA > 4\r\n        set cyclB = 1\r\n        loop\r\n            exitwhen cyclB > 6\r\n            call UnitAddAbility(udg_unit[cyclA + 17], Boss_Info[udg_Boss_LvL][cyclB] )\r\n            call UnitAddAbility( udg_UNIT_INFORMANT, Boss_Info[udg_Boss_LvL][cyclB] )\r\n            set cyclB = cyclB + 1\r\n        endloop\r\n        set cyclA = cyclA + 1\r\n    endloop\r\n    call SetNextBattleInfo()\r\nendfunction\r\n\r\n//===========================================================================\r\nfunction InitTrig_EndFightWork takes nothing returns nothing\r\n    set gg_trg_EndFightWork = CreateTrigger(  )\r\n    call TriggerAddAction( gg_trg_EndFightWork, function Trig_EndFightWork_Actions )\r\nendfunction\r\n\r\n",
  "Events": [],
  "LocalVariables": [],
  "Conditions": [],
  "Actions": []
}