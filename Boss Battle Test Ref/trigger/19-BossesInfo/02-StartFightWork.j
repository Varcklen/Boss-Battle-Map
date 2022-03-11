function AggroBoss takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local group g = CreateGroup()
    local unit u

    if not( udg_fightmod[1] ) then
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    else
        set bj_groupEnumOwningPlayer = Player(10)
        call GroupEnumUnitsInRect(g, udg_Boss_Rect, filterGetUnitsInRectOfPlayer)
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if GetUnitCurrentOrder(u) == OrderId("stand") and GetUnitDefaultMoveSpeed(u) > 0 then
                call aggro( u )
            endif
            call GroupRemoveUnit(g,u)
        endloop
    endif
    
    call GroupClear( g )
    call DestroyGroup( g )
    set g = null
    set u = null
endfunction

function StartFight takes nothing returns nothing
    local integer cyclA = 1
    local integer cyclAEnd
    local integer cyclB
    local integer id
    local integer i
    local unit boss = null
    local unit boss2 = null
    local real x
    local real y
    local integer v
    local integer n
    local location array reg
    local real bx
    local real by

	if BossArenaChoise[udg_Boss_LvL][udg_Boss_Random] == 2 and not(udg_logic[78]) then
        set udg_Boss_Rect = gg_rct_ArenaBossSmall
        set udg_Boss_BigRect = gg_rct_Vision4
		set reg[1] = udg_point[30]
		set reg[2] = udg_point[31]
		set reg[3] = udg_point[32]
		set reg[4] = udg_point[33]
		set bx = GetRectCenterX(gg_rct_BossSpawnSmall)
		set by = GetRectCenterY(gg_rct_BossSpawnSmall)
	else
        set udg_Boss_Rect = gg_rct_ArenaBoss
        set udg_Boss_BigRect = gg_rct_Vision2
		set reg[1] = udg_point[5]
		set reg[2] = udg_point[6]
		set reg[3] = udg_point[7]
		set reg[4] = udg_point[8]
		set bx = GetRectCenterX(gg_rct_BossSpawn)
		set by = GetRectCenterY(gg_rct_BossSpawn)
	endif

    set udg_fightmod[1] = true
    call FightStart()

    loop
        exitwhen cyclA > 4
        if GetPlayerSlotState( Player( cyclA - 1 ) ) == PLAYER_SLOT_STATE_PLAYING then
            call SetUnitPositionLoc( udg_hero[cyclA], reg[cyclA] )
            call SetUnitFacing( udg_hero[cyclA], 90 )
            call PanCameraToTimedLocForPlayer( Player( cyclA - 1 ), reg[cyclA], 0 )
            call DestroyEffect( AddSpecialEffect( "Void Teleport Caster.mdx", GetUnitX( udg_hero[cyclA] ), GetUnitY( udg_hero[cyclA] ) ) )
            if udg_modgood[11] and udg_Boss_LvL != 1 then
                call CreateUnit( Player( cyclA - 1 ), 'h00S', GetUnitX( udg_hero[cyclA] ) + 200, GetUnitY( udg_hero[cyclA] ), 90 )
                call SetPlayerTechResearched( Player( cyclA - 1 ), 'R002', GetPlayerTechCount( Player( cyclA - 1 ), 'R002', true) + 1 )
                call SetPlayerTechResearched( Player( cyclA - 1 ), 'R003', GetPlayerTechCount( Player( cyclA - 1 ), 'R003', true) + 1 )
            endif
            set cyclB = 1
            loop
                exitwhen cyclB > 6
                if cyclB != udg_Boss_Random then
                    call UnitRemoveAbility( udg_unit[cyclA + 17], Boss_Info[udg_Boss_LvL][cyclB] )
                endif
                set cyclB = cyclB + 1
            endloop
        endif
        set cyclA = cyclA + 1
    endloop
    if udg_Boss_LvL != 10 then
        set cyclB = 1
        loop
            exitwhen cyclB > 6
            if cyclB == udg_Boss_Random  then
                set v = Boss_Info[udg_Boss_LvL][cyclB]
                call IconFrame( "boss", BlzGetAbilityIcon(v), BlzGetAbilityTooltip(v, 0), BlzGetAbilityExtendedTooltip(v, 0) )
            endif
            set cyclB = cyclB + 1
        endloop
    endif

    call EnableTrigger( gg_trg_HeroDeath )
    call EnableTrigger( gg_trg_BossDamage )
    call EnableTrigger( gg_trg_MinionsTeleportation )
    if udg_Boss_LvL == 1 then
        set udg_UntilFirstFight = false
        set udg_LogicModes = false
        call BlzFrameSetVisible( rpkmod,false)
        call BlzFrameSetVisible( reselectionButton,false)
        set cyclA = 1
        loop
            exitwhen cyclA > 4
            if cyclA == 1 then
                call UnitRemoveAbility( udg_unit[cyclA + 31], 'A06V' )
                call UnitRemoveAbility( udg_unit[cyclA + 31], 'A0J8' )
                call UnitRemoveAbility( udg_unit[cyclA + 31], 'A0JI' )
                call UnitRemoveAbility( udg_unit[cyclA + 31], 'A0JJ' )
            else
                call RemoveUnit( udg_unit[cyclA + 31] )
            endif
            set udg_minion_repick[cyclA] = 0
            set cyclA = cyclA + 1
        endloop
        if udg_logic[2] then
            set udg_Multiboard_Time[1] = 0
            set udg_Multiboard_Time[2] = 0
            set udg_Multiboard_Time[3] = 0
        endif
    endif

    if udg_logic[78] and udg_Boss_LvL != 1 then
        set boss = CreateUnit( Player(10), DB_Boss_id[udg_Boss_LvL][udg_Boss_Random], GetRectCenterX(gg_rct_BossSpawn) - 600, GetRectCenterY(gg_rct_BossSpawn), 270 )

        set cyclA = 1
        loop
            exitwhen cyclA > 1
            set n = GetRandomInt( 1, 4 ) //ИСПРАВИТЬ НА 5 КОГДА ПРОБЛЕМА С КРАШЕМ БУДЕТ РЕШЕНА
            if DB_Boss_id[udg_Boss_LvL][n] != null and DB_Boss_id[udg_Boss_LvL][n] != GetUnitTypeId( boss ) then
                set boss2 = CreateUnit( Player(10), DB_Boss_id[udg_Boss_LvL][n], GetRectCenterX(gg_rct_BossSpawn) + 600, GetRectCenterY(gg_rct_BossSpawn), 270 )
                call IconFrame( "second boss", BlzGetAbilityIcon(Boss_Info[udg_Boss_LvL][n]), BlzGetAbilityTooltip(Boss_Info[udg_Boss_LvL][n], 0), BlzGetAbilityExtendedTooltip(Boss_Info[udg_Boss_LvL][n], 0) )
            else
                set cyclA = cyclA - 1
            endif
            set cyclA = cyclA + 1
        endloop
    else
        set boss = CreateUnit( Player(10), DB_Boss_id[udg_Boss_LvL][udg_Boss_Random], bx, by, 270 )
    endif
    
    if LoadTimerHandle( udg_hash, 1, StringHash( "aggro" ) ) == null  then
        call SaveTimerHandle( udg_hash, 1, StringHash( "aggro" ), CreateTimer() )
    endif
    call TimerStart( LoadTimerHandle( udg_hash, 1, StringHash( "aggro" ) ), 5, true, function AggroBoss )
    
    if udg_modbad[7] then
        call EnableTrigger( gg_trg_Equality )
    endif
    if udg_modgood[22] then
        call UnitStun(boss, boss, 10 )
        call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Human\\Thunderclap\\ThunderClapCaster.mdl", boss, "origin") )
    endif
    if udg_modbad[14] then
        set cyclA = 1
        set cyclAEnd = udg_Boss_LvL-1
        if cyclAEnd < 1 then
            set cyclAEnd = 1
        endif
        loop
            exitwhen cyclA > cyclAEnd
            set bj_lastCreatedUnit = CreateUnit(GetOwningPlayer(boss), udg_Database_RandomUnit[GetRandomInt(1, udg_Database_NumberItems[5])], GetUnitX(boss), GetUnitY(boss), GetUnitFacing(boss))
            call DestroyEffect(AddSpecialEffectTarget( "Abilities\\Spells\\Orc\\FeralSpirit\\feralspirittarget.mdl", bj_lastCreatedUnit, "origin"))
            call UnitApplyTimedLife(bj_lastCreatedUnit, 'BTLF', 20 )
            set cyclA = cyclA + 1
        endloop
    endif
    set cyclA = 1
    loop
        exitwhen cyclA > 4
        if GetUnitAbilityLevel( udg_hero[cyclA], 'A0LK') > 0 then
            call madness( udg_hero[cyclA], GetUnitAbilityLevel( udg_hero[cyclA], 'A0LK') )
        endif
        set cyclA = cyclA + 1
    endloop
    if boss != null then
        set bossbar = boss
    endif
    if boss2 != null then
        set bossbar1 = boss2
    endif

    call AUI_TimerGo()
    
	set cyclA = 1
    loop
        exitwhen cyclA > 4
        set reg[cyclA] = null
        set cyclA = cyclA + 1
    endloop

    set boss = null
    set boss2 = null
endfunction

//===========================================================================
function InitTrig_StartFightWork takes nothing returns nothing
    set gg_trg_StartFightWork = CreateTrigger(  )
    call TriggerAddAction( gg_trg_StartFightWork, function StartFight )
endfunction

