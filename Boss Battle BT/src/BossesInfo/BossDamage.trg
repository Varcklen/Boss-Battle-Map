{
  "Id": 50333404,
  "Comment": "",
  "IsScript": true,
  "RunOnMapInit": false,
  "Script": "function Trig_BossDamage_Conditions takes nothing returns boolean\r\n    return IsUnitInGroup(udg_DamageEventTarget, udg_Bosses)\r\nendfunction\r\n\r\nglobals\r\n    real array dps[5][11]//герой/позиция\r\nendglobals\r\n\r\nfunction BossDamageCast takes nothing returns nothing\r\n    local integer id = GetHandleId( GetExpiredTimer( ) )\r\n    local integer i = LoadInteger( udg_hash, id, StringHash( \"bssd\" ) ) + 1\r\n    local integer n = LoadInteger( udg_hash, id, StringHash( \"bssdn\" ) ) + 1\r\n    local integer dmg = LoadInteger( udg_hash, id, StringHash( \"bssdd\" ) ) + 1\r\n    local integer cyclA\r\n    local integer cyclB\r\n    local real m\r\n    \r\n    set udg_Info_Time = udg_Info_Time + 1\r\n    if udg_fightmod[0] and not(udg_fightmod[3]) then\r\n        call SaveInteger( udg_hash, id, StringHash( \"bssd\" ), i )\r\n        if not(udg_fightmod[4]) and udg_logic[73] then\r\n            call SaveInteger( udg_hash, id, StringHash( \"bssdn\" ), n )\r\n            if n >= 3 then\r\n                call SaveInteger( udg_hash, id, StringHash( \"bssdn\" ), 0 )\r\n                call SaveInteger( udg_hash, id, StringHash( \"bssdd\" ), dmg )\r\n                if udg_real[0] > 0 then\r\n                    set udg_real[0] = udg_real[0] - 0.01\r\n                    if udg_real[0] <= 0 then\r\n                        set udg_real[0] = 0\r\n                    endif\r\n                endif\r\n                set cyclA = 1\r\n                loop\r\n                    exitwhen cyclA > 4\r\n                    if GetUnitState( udg_hero[cyclA], UNIT_STATE_LIFE) > 0.405 then\r\n                        call SetUnitState( udg_hero[cyclA], UNIT_STATE_LIFE, GetUnitState( udg_hero[cyclA], UNIT_STATE_MAX_LIFE) * RMaxBJ(0,GetUnitStatePercent( udg_hero[cyclA], UNIT_STATE_LIFE, UNIT_STATE_MAX_LIFE) - dmg ) * 0.01)\r\n                        call DestroyEffect( AddSpecialEffect( \"Abilities\\\\Spells\\\\Undead\\\\AnimateDead\\\\AnimateDeadTarget.mdl\", GetUnitX( udg_hero[cyclA] ), GetUnitY( udg_hero[cyclA] ) ) )\r\n                    endif\r\n                    set cyclA = cyclA + 1\r\n                endloop\r\n            endif\r\n        endif\r\n        set cyclA = 1\r\n        loop\r\n            exitwhen cyclA > 4\r\n            if IsUnitAlive( udg_hero[cyclA]) then\r\n                if not( udg_logic[43] ) then\r\n                    set udg_dpsnum[cyclA] = udg_dpsnum[cyclA] + 1\r\n                    if udg_dpsnum[cyclA] > 10 then\r\n                        set udg_dpsnum[cyclA] = 1\r\n                    endif\r\n                    set dps[cyclA][udg_dpsnum[cyclA]] = udg_DamageFight[cyclA] - udg_dpslast[cyclA]\r\n                    set udg_dpslast[cyclA] = udg_DamageFight[cyclA]\r\n                \r\n                    set udg_DPS[cyclA] = 0\r\n                    set cyclB = 1\r\n                    loop\r\n                        exitwhen cyclB > 10\r\n                        set udg_DPS[cyclA] = udg_DPS[cyclA] + dps[cyclA][cyclB]\r\n                        set cyclB = cyclB + 1\r\n                    endloop\r\n                    set udg_DPS[cyclA] = udg_DPS[cyclA] / 10\r\n                    if udg_DPS[cyclA] > udg_DPSMax[cyclA] then\r\n                        set udg_DPSMax[cyclA] = udg_DPS[cyclA]\r\n                    endif\r\n                    call MultiSetValue( udg_multi, ( udg_Multiboard_Position[cyclA] * 3 ) - 1, 8, I2S(R2I(udg_DPS[cyclA])) )\r\n                endif\r\n            endif\r\n            set cyclA = cyclA + 1\r\n        endloop\r\n    else\r\n        call FlushChildHashtable( udg_hash, id )\r\n        call DestroyTimer( GetExpiredTimer() )\r\n    endif\r\nendfunction\r\n\r\nfunction BossDamageTimer takes nothing returns nothing\r\n    local integer cyclA = 0\r\n    \r\n    set udg_logic[73] = true\r\n    loop\r\n        exitwhen cyclA > 3\r\n        if GetPlayerSlotState(Player(cyclA)) == PLAYER_SLOT_STATE_PLAYING then\r\n            call DisplayTimedTextToPlayer(Player(cyclA), 0, 0, 10., \"|cffffcc00Warning!|r Battle limit exceeded! The health of the heroes begins to gradually decline.\")\r\n        endif\r\n        set cyclA = cyclA + 1\r\n    endloop\r\n    call StartSound(gg_snd_Warning)\r\n    call TimerDialogDisplay( udg_timerdialog[0], false )\r\n    call FlushChildHashtable( udg_hash, GetHandleId( GetExpiredTimer( ) ) )\r\nendfunction\r\n\r\nfunction Trig_BossDamage_Actions takes nothing returns nothing\r\n    local integer id = GetHandleId( udg_UNIT_DUMMY_BUFF )\r\n    \r\n    call DisableTrigger( GetTriggeringTrigger() )\r\n        \r\n    if LoadTimerHandle( udg_hash, id, StringHash( \"bssd\" ) ) == null  then\r\n        call SaveTimerHandle( udg_hash, id, StringHash( \"bssd\" ), CreateTimer() )\r\n    endif\r\n    set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( \"bssd\" ) ) ) \r\n    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_UNIT_DUMMY_BUFF ), StringHash( \"bssd\" ) ), 1, true, function BossDamageCast )\r\n    \r\n    if not( udg_fightmod[4] ) or udg_logic[72] then\r\n        set udg_logic[72] = false\r\n        set id = GetHandleId( udg_UNIT_DUMMY_BUFF )\r\n        if LoadTimerHandle( udg_hash, id, StringHash( \"bssdtimer\" ) ) == null  then\r\n            call SaveTimerHandle( udg_hash, id, StringHash( \"bssdtimer\" ), CreateTimer() )\r\n        endif\r\n        set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( \"bssdtimer\" ) ) ) \r\n        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_UNIT_DUMMY_BUFF ), StringHash( \"bssdtimer\" ) ), udg_timelimit, false, function BossDamageTimer )\r\n        set udg_timerdialog[0] = CreateTimerDialog( LoadTimerHandle( udg_hash, GetHandleId( udg_UNIT_DUMMY_BUFF ), StringHash( \"bssdtimer\" ) ) )\r\n        call TimerDialogSetTitle(udg_timerdialog[0], \"Battle limit:\" )\r\n        call TimerDialogDisplay(udg_timerdialog[0], true)\r\n    endif\r\nendfunction\r\n\r\n//===========================================================================\r\nfunction InitTrig_BossDamage takes nothing returns nothing\r\n    set gg_trg_BossDamage = CreateTrigger(  )\r\n    call TriggerRegisterVariableEvent( gg_trg_BossDamage, \"udg_DamageModifierEvent\", EQUAL, 1.00 )\r\n    call TriggerAddCondition( gg_trg_BossDamage, Condition( function Trig_BossDamage_Conditions ) )\r\n    call TriggerAddAction( gg_trg_BossDamage, function Trig_BossDamage_Actions )\r\nendfunction\r\n\r\n",
  "Events": [],
  "LocalVariables": [],
  "Conditions": [],
  "Actions": []
}