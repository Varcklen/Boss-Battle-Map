function AggroIA takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local group g = CreateGroup()
    local unit u

    if not( udg_fightmod[0] ) then
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    else
        set bj_groupEnumOwningPlayer = Player(10)
        call GroupEnumUnitsInRect(g, gg_rct_RandomItem, filterGetUnitsInRectOfPlayer)
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
    set u = null
    set g = null
endfunction

function IA_StartSpuwn takes nothing returns nothing
    local group g = CreateGroup()
    local unit u
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local integer s = LoadInteger( udg_hash, id, StringHash( "IAarc" ) )
    local integer n = LoadInteger( udg_hash, id, StringHash( "IAcom" ) ) 
    local integer h = LoadInteger( udg_hash, id, StringHash( "IAabom" ) ) 
    local integer x = LoadInteger( udg_hash, id, StringHash( "IAmag" ) ) 
    local integer m = LoadInteger( udg_hash, id, StringHash( "IAlim" ) ) + 1
    local integer k = LoadInteger( udg_hash, id, StringHash( "IAhrd" ) ) + 1
    local integer t = LoadInteger( udg_hash, id, StringHash( "IAtime" ) )
    local integer p = LoadInteger( udg_hash, id, StringHash( "IAhard" ) )
    local integer cyclA = 1
    local integer i
    local integer rand = GetRandomInt(1, 10)
    local item it
    local boolean l

    if not( udg_fightmod[2] ) then
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    else
        loop
            exitwhen cyclA > 4
            if CountUnitsInGroup(GetUnitsInRectOfPlayer(gg_rct_RandomItem, Player(10))) <= 7 + ( 7 * udg_Heroes_Amount ) then
                set l = false
                set n = n + 1
                set h = h + 1
                set s = s + 1
                set x = x + 1
                if n >= 21 then
                    set n = 0
                    set l = true
                    set i = p+12 
                endif
                if not(l) and h >= 7 then
                    set h = 0
                    set l = true
                    set i = p+18 
                endif
                if not(l) and x >= 6 then
                    set x = 0
                    set l = true
                    set i = p+24 
                endif
                if not(l) and s >= 5 then
                    set s = 0
                    set l = true
                    set i = p+6 
                endif
                if not(l) then
                    set i = p
                endif
                set bj_lastCreatedUnit = CreateUnitAtLoc(Player(10), udg_Database_IA_Unit[i], udg_point[cyclA + 13], ( 90. * cyclA ) - 45.)
                call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Orc\\FeralSpirit\\feralspirittarget.mdl", bj_lastCreatedUnit, "origin" ) )
            else
                set cyclA = 4
            endif
            set cyclA = cyclA + 1
        endloop
        call SaveInteger( udg_hash, id, StringHash( "IAarc" ), s )
        call SaveInteger( udg_hash, id, StringHash( "IAabom" ), h )
        call SaveInteger( udg_hash, id, StringHash( "IAcom" ), n )
        call SaveInteger( udg_hash, id, StringHash( "IAmag" ), x )
        if m > 6 and p < 6 then
            call SaveInteger( udg_hash, id, StringHash( "IAlim" ), 0 )
            call SaveInteger( udg_hash, id, StringHash( "IAhard" ), p + 1 )
        else
            call SaveInteger( udg_hash, id, StringHash( "IAlim" ), m )
        endif
        
        set bj_groupEnumOwningPlayer = Player(10)
        call GroupEnumUnitsInRect(g, gg_rct_RandomItem, filterGetUnitsInRectOfPlayer)
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if GetUnitCurrentOrder(u) == OrderId("stand") and GetUnitDefaultMoveSpeed(u) > 0 then
                call aggro( u )
            endif
            call GroupRemoveUnit(g,u)
            set u = FirstOfGroup(g)
        endloop
        if rand <= 6 then
            set it = CreateItem( 'I03J' + GetRandomInt(1, 6), GetRandomReal(GetRectMinX(udg_Boss_Rect), GetRectMaxX(udg_Boss_Rect)), GetRandomReal(GetRectMinY(udg_Boss_Rect), GetRectMaxY(udg_Boss_Rect)) )
            call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Orc\\FeralSpirit\\feralspirittarget.mdl", GetItemX( it ), GetItemY( it ) ) )
            if udg_modgood[21] then
                set it = CreateItem( 'I03J' + GetRandomInt(1, 6), GetRandomReal(GetRectMinX(udg_Boss_Rect), GetRectMaxX(udg_Boss_Rect)), GetRandomReal(GetRectMinY(udg_Boss_Rect), GetRectMaxY(udg_Boss_Rect)) )
                call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Orc\\FeralSpirit\\feralspirittarget.mdl", GetItemX( it ), GetItemY( it ) ) )
            endif
        endif
        if k >= 20 and t > 2 then
            call PauseTimer( GetExpiredTimer() )
            call SaveInteger( udg_hash, id, StringHash( "IAhrd" ), 0 )
            call SaveInteger( udg_hash, id, StringHash( "IAtime" ), t - 1 )
            set t = LoadInteger( udg_hash, id, StringHash( "IAtime" ) )
            call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( gg_unit_h00A_0034 ), StringHash( "IAsp" ) ), t, true, function IA_StartSpuwn )
        else
            call SaveInteger( udg_hash, id, StringHash( "IAhrd" ), k )
        endif
    endif
    
    call GroupClear( g )
    call DestroyGroup( g )
    set g = null
    set u = null
    set it = null
endfunction

function Trig_IA_StartWork_Actions takes nothing returns nothing
    local integer cyclA = 1
    local integer id

    set udg_Boss_Rect = gg_rct_RandomItem
    set udg_Boss_BigRect = gg_rct_Vision3
    set udg_ArenaLim[0] = udg_ArenaLim[0] + 1
    set udg_fightmod[2] = true
    set udg_logic[33] = true
    call FightStart()
    call TriggerExecute( gg_trg_BossDamage )
    call MultiSetColor( udg_multi, 4, 2, 0.00, 0.00, 0.00, 100.00 )
    
    call EnableTrigger( gg_trg_IA_TPBattle )
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
    
    set id = GetHandleId( gg_unit_h00A_0034 )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "IAsp" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "IAsp" ), CreateTimer() )
    endif
    set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "IAsp" ) ) ) 
    call SaveInteger( udg_hash, id, StringHash( "IAtime" ), 7 )
    call SaveInteger( udg_hash, id, StringHash( "IAhard" ), (udg_Arena_LvL[0]*2)+1 )
    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( gg_unit_h00A_0034 ), StringHash( "IAsp" ) ), 7, true, function IA_StartSpuwn )
    
    call EnableTrigger( gg_trg_IA_End )
    if udg_Arena_LvL[0] == 0 then
        set cyclA = 0
        loop
            exitwhen cyclA > 3
            if GetPlayerSlotState(Player(cyclA)) == PLAYER_SLOT_STATE_PLAYING and udg_LvL[cyclA+1] <= 5 then
                call DisplayTimedTextToPlayer( Player( cyclA ), 0, 0, 15, "|cffffcc00'Endless Arena'|r - an arena in which enemies will constantly appear. For each defeated enemy you will receive gold." )
                call DisplayTimedTextToPlayer( Player( cyclA ), 0, 0, 15, "|cffffcc00Death in this arena will not bring defeat.|r Enemy get stronger over time." )
            endif
            set cyclA = cyclA + 1
        endloop
    endif
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
function InitTrig_IA_StartWork takes nothing returns nothing
    set gg_trg_IA_StartWork = CreateTrigger(  )
    call TriggerAddAction( gg_trg_IA_StartWork, function Trig_IA_StartWork_Actions )
endfunction

