function AL_RuneSpawn takes nothing returns nothing
    local integer cyclA = 1
    local integer cyclAEnd = 1
    if udg_modgood[21] then
        set cyclAEnd = cyclAEnd + 1
    endif
    loop
        exitwhen cyclA > cyclAEnd
        call CreateItem( 'I03J' + GetRandomInt( 1, 6 ), GetRandomReal(GetRectMinX(udg_Boss_Rect), GetRectMaxX(udg_Boss_Rect)), GetRandomReal(GetRectMinY(udg_Boss_Rect), GetRectMaxY(udg_Boss_Rect)) )
        set cyclA = cyclA + 1
    endloop
endfunction

function AL_BossSpawn takes integer bossId, integer timerId, timer activeTimer returns nothing
    local unit boss
    local integer rand = GetRandomInt( 1, 4 )
    local real x
    local real y
    local group g = CreateGroup()
    local unit u

    if bossId != 'o007' and bossId != 'h001' and bossId != 'n04O' then
        set x = GetLocationX( udg_point[rand + 13] )
        set y = GetLocationY( udg_point[rand + 13] )
    else
        set x = GetRectCenterX( udg_Boss_Rect )
        set y = GetRectCenterX( udg_Boss_Rect )
    endif

    set boss = CreateUnit(Player(10), bossId, x, y, 270 )
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Orc\\FeralSpirit\\feralspirittarget.mdl", boss, "origin" ) )
    call PingMinimapForForceEx( bj_FORCE_ALL_PLAYERS, GetUnitX( boss ), GetUnitY( boss ), 5, bj_MINIMAPPINGSTYLE_ATTACK, 100, 50, 50 )
    
    if GetUnitTypeId(boss) == 'n00F' then
        set udg_logic[72] = true
        call TriggerExecute( gg_trg_BossDamage )
        set bj_livingPlayerUnitsTypeId = 'h00J'
        call GroupEnumUnitsOfPlayer(g, Player( 10 ), filterLivingPlayerUnitsOfTypeId)
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            call RemoveUnit( u )
            call GroupRemoveUnit(g,u)
        endloop
        call FlushChildHashtable( udg_hash, timerId )
        call DestroyTimer( activeTimer )
    endif
    
    set boss = null
    set activeTimer = null
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
endfunction

function LA_StartSpawn takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local integer s = 0
    local integer n = 0
    local integer i = 0
    local boolean loopL

    if not( udg_fightmod[4] ) then
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    else
        set loopL = false
        set s = LoadInteger( udg_hash, id, StringHash( "LA" ) ) + 1
        set n = LoadInteger( udg_hash, id, StringHash( "LAlvl" ) )
        set i = DB_Boss_id[n][s]
        loop
            exitwhen loopL
            if CountUnitsInGroup(GetUnitsOfTypeIdAll(i)) == 0 and i != 0 then
                call AL_BossSpawn(i, id, GetExpiredTimer())
                set loopL = true
            elseif n <= 10 then 
                set s = 1
                set n = n + 1
                set i = DB_Boss_id[n][s]
            else
                set loopL = true
                call FlushChildHashtable( udg_hash, id )
                call DestroyTimer( GetExpiredTimer() )
            endif
        endloop
        call SaveInteger( udg_hash, id, StringHash( "LA" ), s )
        call SaveInteger( udg_hash, id, StringHash( "LAlvl" ), n )
        call AL_RuneSpawn()
    endif
endfunction

function Trig_AL_StartWork_Actions takes nothing returns nothing
    local integer cyclA = 1
    local integer id
    local integer bid

    set udg_Boss_Rect = gg_rct_RandomItem
    set udg_Boss_BigRect = gg_rct_Vision3
    set udg_fightmod[4] = true
    set udg_ArenaLim[1] = udg_ArenaLim[1] + 1
    set udg_logic[31] = true
    call FightStart()
    call MultiSetColor( udg_multi, 5, 2, 0.00, 0.00, 0.00, 100.00 )
    
    call EnableTrigger( gg_trg_IA_TPBattle )
    call EnableTrigger( gg_trg_BossDamage )
    call EnableTrigger( gg_trg_AL_End )
    call EnableTrigger( ArenaLordsEnd_LastBossKilled )
    
    loop
        exitwhen cyclA > 4
        call CreateUnitAtLoc(Player(10), 'h00J', udg_point[cyclA + 43], ( 90. * cyclA ) - 45. )
        if GetPlayerSlotState(Player(cyclA - 1)) == PLAYER_SLOT_STATE_PLAYING then
            call SetUnitPositionLoc( udg_hero[cyclA], udg_point[cyclA + 17] )
            call PanCameraToTimedLocForPlayer( Player(cyclA - 1), udg_point[( cyclA + 17 )], 0.00 )
            call DestroyEffect( AddSpecialEffect( "Void Teleport Caster.mdx" , GetUnitX( udg_hero[cyclA] ), GetUnitY( udg_hero[cyclA] ) ) )
        endif
        set cyclA = cyclA + 1
    endloop
    if udg_Arena_LvL[1] == 0 then
        set udg_number[9] = 40
        set cyclA = 0
        loop
            exitwhen cyclA > 3
            if GetPlayerSlotState(Player(cyclA)) == PLAYER_SLOT_STATE_PLAYING and udg_LvL[cyclA+1] <= 5 then
                call DisplayTimedTextToPlayer( Player( cyclA ), 0, 0, 15, "|cffffcc00'Overlord Arena'|r - an arena in which bosses constantly appear. For each defeated boss you will receive gold." )
                call DisplayTimedTextToPlayer( Player( cyclA ), 0, 0, 15, "|cffffcc00Death in this arena will not bring defeat.|r" )
            endif
            set cyclA = cyclA + 1
        endloop
    else
        set udg_number[9] = 80
    endif
    
    set id = GetHandleId( gg_unit_h00A_0034 )
    if LoadTimerHandle( udg_hash, id, StringHash( "ALsp" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "ALsp" ), CreateTimer() )
    endif
    set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "ALsp" ) ) ) 
    call SaveInteger( udg_hash, id, StringHash( "LA" ), 1 )
    if udg_Arena_LvL[1] == 1 then
        set bid = 'e004'
        call SaveInteger( udg_hash, id, StringHash( "LAlvl" ), 4 )
    else
        set bid = 'n005'
        call SaveInteger( udg_hash, id, StringHash( "LAlvl" ), 1 )
    endif
    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( gg_unit_h00A_0034 ), StringHash( "ALsp" ) ), 15, true, function LA_StartSpawn )
    
    set bj_lastCreatedUnit = CreateUnitAtLoc(Player(10), bid, udg_point[13 + GetRandomInt( 1, 4 )],  GetRandomReal( 0, 360 ) )
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Orc\\FeralSpirit\\feralspirittarget.mdl", bj_lastCreatedUnit, "origin" ) )
    call PingMinimapLocForForceEx( bj_FORCE_ALL_PLAYERS, GetUnitLoc( bj_lastCreatedUnit ), 5, bj_MINIMAPPINGSTYLE_ATTACK, 100, 50, 50 )
    
    set id = GetHandleId( gg_unit_h00A_0034 )
    if LoadTimerHandle( udg_hash, id, StringHash( "aggro" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "aggro" ), CreateTimer() )
    endif
    set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "aggro" ) ) ) 
    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( gg_unit_h00A_0034 ), StringHash( "aggro" ) ), 1, true, function AggroIA )
    
    set cyclA = 1
    loop
        exitwhen cyclA > 4
        if GetUnitAbilityLevel( udg_hero[cyclA], 'A0LK') > 0 and GetPlayerSlotState(Player(cyclA - 1)) == PLAYER_SLOT_STATE_PLAYING then
            call madness( udg_hero[cyclA], GetUnitAbilityLevel( udg_hero[cyclA], 'A0LK') )
        endif
        set cyclA = cyclA + 1
    endloop
endfunction

//===========================================================================
function InitTrig_AL_StartWork takes nothing returns nothing
    set gg_trg_AL_StartWork = CreateTrigger(  )
    call TriggerAddAction( gg_trg_AL_StartWork, function Trig_AL_StartWork_Actions )
endfunction

