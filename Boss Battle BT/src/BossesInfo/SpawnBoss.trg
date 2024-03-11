{
  "Id": 50333406,
  "Comment": "",
  "IsScript": true,
  "RunOnMapInit": false,
  "Script": "function Trig_SpawnBoss_Conditions takes nothing returns boolean\r\n    return IsUnitType(GetEnteringUnit(), UNIT_TYPE_ANCIENT) and GetUnitTypeId(GetEnteringUnit()) != 'n059' and GetUnitTypeId(GetEnteringUnit()) != 'n01Z' and GetUnitTypeId(GetEnteringUnit()) != 'h005' and GetUnitTypeId(GetEnteringUnit()) != 'h013' and GetUnitTypeId(GetEnteringUnit()) != 'h01H' and GetUnitTypeId(GetEnteringUnit()) != 'h00C' and GetUnitTypeId(GetEnteringUnit()) != 'h009'\r\nendfunction\r\n\r\nfunction OgreAwake takes nothing returns nothing\r\n    local integer id = GetHandleId( GetExpiredTimer() )\r\n    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( \"bsog\" ) )\r\n\r\n    if GetUnitState( boss, UNIT_STATE_LIFE) > 0.405 and udg_fightmod[0] and GetUnitTypeId( boss ) == 'h001' then\r\n        set udg_DamageEventTarget = boss\r\n        call TriggerExecute( gg_trg_Ogre1 )\r\n    endif\r\n    \r\n    call FlushChildHashtable( udg_hash, id )\r\n    set boss = null\r\nendfunction\r\n\r\nfunction StartFightCall takes nothing returns nothing\r\n    local integer id = GetHandleId( GetExpiredTimer() )\r\n    local integer s = LoadInteger( udg_hash, id, StringHash( \"bcalls\" ) )\r\n    local integer n = LoadInteger( udg_hash, id, StringHash( \"bcalln\" ) )\r\n    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( \"bcall\" ) )\r\n    \r\n    if GetUnitState( boss, UNIT_STATE_LIFE) > 0.405 and not(IsUnitHiddenBJ(boss)) then\r\n        call TransmissionFromUnitWithNameBJ( bj_FORCE_ALL_PLAYERS, boss, null, Boss_Talk[n][s], null, bj_TIMETYPE_SET, 1, false )\r\n    endif\r\n    call FlushChildHashtable( udg_hash, id )\r\n    set boss = null\r\nendfunction\r\n\r\nfunction ModBad1 takes nothing returns nothing\r\n    local integer id = GetHandleId( GetExpiredTimer() )\r\n    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( \"modb1\" ) )\r\n    local unit target = GroupPickRandomUnit(udg_otryad)\r\n\r\n    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not(udg_fightmod[0]) then\r\n        call FlushChildHashtable( udg_hash, id )\r\n        call DestroyTimer( GetExpiredTimer() )\r\n    elseif target != null and not(IsUnitHiddenBJ(boss)) then\r\n        call DestroyEffect( AddSpecialEffect(\"Void Teleport Caster.mdx\", GetUnitX(boss), GetUnitY(boss) ) )\r\n        call SetUnitPosition( boss, GetUnitX(target)+GetRandomReal(-200,200), GetUnitY(target)+GetRandomReal(-200,200) )\r\n        if not( RectContainsUnit( udg_Boss_Rect, boss) ) then\r\n            call SetUnitPositionLoc( boss, GetRectCenter( udg_Boss_Rect ) )\r\n        endif\r\n        call DestroyEffect( AddSpecialEffectTarget(\"Void Teleport Caster.mdx\", boss, \"origin\" ) )\r\n        call taunt( target, boss, 4 )\r\n    endif\r\n\r\n    set boss = null\r\nendfunction\r\n\r\nfunction Trig_SpawnBoss_Actions takes nothing returns nothing\r\n    local integer cyclA = 1\r\n    local integer cyclB\r\n    local integer id \r\n    local boolean l = false\r\n    local integer s = 1\r\n    local integer n = 1\r\n    local integer k = 1\r\n    local integer h\r\n    local integer i\r\n    local integer rand\r\n    \r\n    local unit u = GetEnteringUnit()\r\n    \r\n    if GetUnitTypeId(u) == 'n009' and udg_HardNum > 5 then\r\n        call BlzSetUnitName( u, \"Rapist\" )\r\n    endif\r\n    \r\n    if udg_Boss_LvL > 1 or udg_Endgame > 1 then\r\n        call BlzSetUnitAttackCooldown(u,BlzGetUnitAttackCooldown(u,0) / HardModAspd[udg_HardNum],0)\r\n    endif\r\n    \r\n\tif udg_Endgame > 1 then\r\n        call BlzSetUnitBaseDamage( u, R2I(GetUnitDamage(u) * udg_Endgame - GetUnitAvgDiceDamage(u)), 0 )\r\n        call BlzSetUnitMaxHP( u, R2I(BlzGetUnitMaxHP(u) * udg_Endgame) )\r\n\tendif\r\n\r\n\tif GetOwningPlayer(u) == Player(10) and udg_BossHP != 1 then\r\n        call BlzSetUnitBaseDamage( u, R2I(GetUnitDamage(u) * udg_BossAT - GetUnitAvgDiceDamage(u)), 0 )\r\n        call BlzSetUnitMaxHP( u, R2I(BlzGetUnitMaxHP(u) * udg_BossHP)+1 )\r\n        //call SetUnitState( u, UNIT_STATE_LIFE, GetUnitState( u, UNIT_STATE_MAX_LIFE ) )\r\n\tendif\r\n    \r\n    if not( RectContainsUnit( udg_Boss_Rect, u) ) then\r\n        call SetUnitPositionLoc( u, GetRectCenter( udg_Boss_Rect ) )\r\n    endif\r\n\r\n\tif GetUnitTypeId(u) != 'h002' and GetUnitTypeId(u) != 'o006' /*and GetUnitTypeId(u) != 'n00F'*/ then\r\n\t\tcall SetUnitLifeBJ( u, GetUnitStateSwap(UNIT_STATE_MAX_LIFE, u) )\r\n\tendif\r\n    \r\n    if udg_modbad[21] then\r\n        call UnitAddAbility( u, 'A0SV' )\r\n    endif\r\n    \r\n    if udg_modbad[1] and GetOwningPlayer(u) == Player(10) and GetUnitDefaultMoveSpeed(u) != 0 then\r\n        set id = GetHandleId( u )\r\n        if LoadTimerHandle( udg_hash, id, StringHash( \"modb1\" ) ) == null  then\r\n            call SaveTimerHandle( udg_hash, id, StringHash( \"modb1\" ), CreateTimer() )\r\n        endif\r\n        set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( \"modb1\" ) ) ) \r\n        call SaveUnitHandle( udg_hash, id, StringHash( \"modb1\" ), u )\r\n        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( u ), StringHash( \"modb1\" ) ), 20, false, function ModBad1 )\r\n    endif\r\n\r\n    if udg_modbad[19] and BlzGetUnitBaseDamage(u, 0) > 5 and GetUnitDefaultMoveSpeed(u) != 0 and GetUnitTypeId(u) != 'h00Z' then\r\n        call UnitAddAbility( u, 'A0NC' )\r\n    endif\r\n\r\n    call RemoveGuardPosition(u)\r\n    if ( CountLivingPlayerUnitsOfTypeId('o006', GetOwningPlayer(u)) == 0 and GetUnitTypeId(u) == 'n00F' ) or GetUnitTypeId(u) != 'n00F' then\r\n        set cyclA = 1\r\n        set i = DB_Boss_id[1][1]\r\n        set s = 1\r\n        set n = 1\r\n        set k = 1\r\n        loop\r\n            exitwhen cyclA > 1\r\n            if i == GetUnitTypeId( u ) then\r\n                set cyclB = 1\r\n                set l = false\r\n                loop\r\n                    exitwhen l\r\n                    set h = cyclB + ( ( s - 1 ) * 10 )\r\n                    if DB_Trigger_Boss[n][h] != null and cyclB <= 9 then\r\n                        call EnableTrigger( DB_Trigger_Boss[n][h] )\r\n                        call SetUnitUserData(u,5)\r\n                        set cyclB = cyclB + 1\r\n                    else\r\n                        set l = true\r\n                    endif\r\n                endloop\r\n            elseif k < 500 then\r\n                set cyclA = cyclA - 1 \r\n                set s = s + 1\r\n                set i = DB_Boss_id[n][s]\r\n                if i == 0 then\r\n                    set s = 1\r\n                    set n = n + 1\r\n                    set i = DB_Boss_id[n][s]\r\n                endif\r\n            endif\r\n            set k = k + 1\r\n            set cyclA = cyclA + 1\r\n        endloop\r\n    else\r\n        call GroupAddUnit( udg_Bosses, u )\r\n        return\r\n    endif\r\n    \r\n    if udg_modbad[10] then\r\n        call UnitAddAbility( u, 'A10Y' )\r\n    endif\r\n\r\n    if udg_fightmod[4] and GetUnitTypeId(u) != 'e000' then\r\n        call dummyspawn( u, 1, 0, 0, 0 ) \r\n        call UnitDamageTarget( bj_lastCreatedUnit, u, 1, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)\r\n    endif\r\n    \r\n    if Boss_Talk[n][s] != null then\r\n        set id = GetHandleId( u )\r\n        if LoadTimerHandle( udg_hash, id, StringHash( \"bcall\" ) ) == null  then\r\n            call SaveTimerHandle( udg_hash, id, StringHash( \"bcall\" ), CreateTimer() )\r\n        endif\r\n        set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( \"bcall\" ) ) ) \r\n        call SaveUnitHandle( udg_hash, id, StringHash( \"bcall\" ), u )\r\n        call SaveInteger( udg_hash, id, StringHash( \"bcalls\" ), s )\r\n        call SaveInteger( udg_hash, id, StringHash( \"bcalln\" ), n )\r\n        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( u ), StringHash( \"bcall\" ) ), 7, false, function StartFightCall )\r\n    endif\r\n    \r\n    if GetUnitTypeId(u) == 'h001' then \r\n    \tcall SetUnitAnimation( u, \"sleep\" )\r\n        set id = GetHandleId( u )\r\n        if LoadTimerHandle( udg_hash, id, StringHash( \"bsog\" ) ) == null  then\r\n            call SaveTimerHandle( udg_hash, id, StringHash( \"bsog\" ), CreateTimer() )\r\n        endif\r\n        set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( \"bsog\" ) ) ) \r\n        call SaveUnitHandle( udg_hash, id, StringHash( \"bsog\" ), u )\r\n        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( u ), StringHash( \"bsog\" ) ), 40, false, function OgreAwake )\r\n    endif\r\n    if GetUnitTypeId(u) == 'n00A' then \r\n        call ShowUnitHide( udg_UNIT_CUTE_BOB )\r\n    endif\r\n\r\n    if GetOwningPlayer(u) == Player(10) then\r\n        call GroupAddUnit( udg_Bosses, u )\r\n    endif\r\n    set u = null\r\nendfunction\r\n\r\n//===========================================================================\r\nfunction InitTrig_SpawnBoss takes nothing returns nothing\r\n    set gg_trg_SpawnBoss = CreateTrigger(  )\r\n    call TriggerRegisterEnterRectSimple( gg_trg_SpawnBoss, GetWorldBounds() )\r\n    call TriggerAddCondition( gg_trg_SpawnBoss, Condition( function Trig_SpawnBoss_Conditions ) )\r\n    call TriggerAddAction( gg_trg_SpawnBoss, function Trig_SpawnBoss_Actions )\r\nendfunction\r\n\r\n",
  "Events": [],
  "LocalVariables": [],
  "Conditions": [],
  "Actions": []
}