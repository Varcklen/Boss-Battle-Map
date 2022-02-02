function Trig_Chest_Conditions takes nothing returns boolean
    return GetUnitTypeId(GetDyingUnit()) == 'h01L'
endfunction

function Trig_Chest_Actions takes nothing returns nothing
    local group g = CreateGroup()
    local unit u
    local integer rand = GetRandomInt( 1, 8 )
    local integer cyclA
    local integer i
    local integer n
    local integer m
    local unit h = GroupPickRandomUnit(udg_heroinfo)
    local location loc
    
    if rand == 1 then
        call textst( "|c00FF6000 Minions!", GetDyingUnit(), 64, 90, 15, 1.5 )
        set cyclA = 1
        loop
            exitwhen cyclA > 3
            set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer(h), udg_Database_RandomUnit[GetRandomInt(1, udg_Database_NumberItems[5])], GetUnitX( GetDyingUnit() ) + GetRandomReal( -200, 200 ), GetUnitY( GetDyingUnit() ) + GetRandomReal( -200, 200 ), GetRandomReal( 0, 360 ) )
            call UnitApplyTimedLife( bj_lastCreatedUnit, 'BTLF', 60)
            call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Orc\\FeralSpirit\\feralspirittarget.mdl", GetUnitX( bj_lastCreatedUnit ), GetUnitY( bj_lastCreatedUnit ) ) )
            set cyclA = cyclA + 1
        endloop
    elseif rand == 2 then
        call textst( "|c00FF6000 Runes!", GetDyingUnit(), 64, 90, 15, 1.5 )
        set cyclA = 1
        loop
            exitwhen cyclA > 7
            call CreateItem( 'I03J' + GetRandomInt( 1, 6 ), GetRandomReal(GetRectMinX(udg_Boss_Rect), GetRectMaxX(udg_Boss_Rect)), GetRandomReal(GetRectMinY(udg_Boss_Rect), GetRectMaxY(udg_Boss_Rect)) )
            set cyclA = cyclA + 1
        endloop
    elseif rand == 3 then
        call textst( "|c00FF6000 Reborn!", GetDyingUnit(), 64, 90, 15, 1.5 )
        set cyclA = 1
        loop
            exitwhen cyclA > 4
            if GetPlayerSlotState( Player( cyclA - 1 ) ) == PLAYER_SLOT_STATE_PLAYING then
                call SetUnitState( udg_hero[cyclA], UNIT_STATE_LIFE, GetUnitState( udg_hero[cyclA], UNIT_STATE_LIFE ) + (0.4*GetUnitState( udg_hero[cyclA], UNIT_STATE_MAX_LIFE )) )
                call SetUnitState( udg_hero[cyclA], UNIT_STATE_MANA, GetUnitState( udg_hero[cyclA], UNIT_STATE_MANA ) + (0.4*GetUnitState( udg_hero[cyclA], UNIT_STATE_MAX_MANA )) )
            endif
            set cyclA = cyclA + 1
        endloop
    elseif rand == 4 then
        call textst( "|c00FF6000 Money!", GetDyingUnit(), 64, 90, 15, 1.5 )
        set cyclA = 1
        loop
            exitwhen cyclA > 4
            if GetPlayerSlotState( Player( cyclA - 1 ) ) == PLAYER_SLOT_STATE_PLAYING then
                call moneyst( udg_hero[cyclA], 150 )
            endif
            set cyclA = cyclA + 1
        endloop
    elseif rand == 5 then
        call textst( "|c00FF6000 Destroy!", GetDyingUnit(), 64, 90, 15, 1.5 )
        call GroupEnumUnitsOfPlayer(g, Player(10), null)
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null 
            if GetUnitState( u, UNIT_STATE_LIFE ) > 0.405 and GetUnitName( u ) != "dummy" then
                call SetUnitState( u, UNIT_STATE_LIFE, GetUnitState( u, UNIT_STATE_LIFE ) - ( GetUnitState( u, UNIT_STATE_MAX_LIFE ) * 0.1 ) )
                call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Undead\\AnimateDead\\AnimateDeadTarget.mdl", GetUnitX( u ), GetUnitY( u ) ) )
            endif
            call GroupRemoveUnit(g,u)
            set u = FirstOfGroup(g)
        endloop
    elseif rand == 6 then
        call textst( "|c00FF6000 Weakening!", GetDyingUnit(), 64, 90, 15, 1.5 )
        call dummyspawn( h, 0,'A11E', 0, 0 )
    elseif rand == 7 then
        call textst( "|c00FF6000 Boss!", GetDyingUnit(), 64, 90, 15, 1.5 )
        set i = 0
        set cyclA = 1
        call KillUnit( LoadUnitHandle( udg_hash, GetHandleId( h ), StringHash( "dmch" ) ) )
        loop
            exitwhen cyclA > 1
            set m = GetRandomInt( 1, 4 )
            set n = GetRandomInt( 1, 5 )
            if CountUnitsInGroup(GetUnitsOfTypeIdAll(DB_Boss_id[m][n])) == 0 and i < 30 then
                set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer(h), DB_Boss_id[m][n], GetUnitX( h ) + GetRandomReal(-200, 200), GetUnitY( h ) + GetRandomReal(-200, 200), GetRandomReal( 0, 360) )
                call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Orc\\FeralSpirit\\feralspirittarget.mdl", bj_lastCreatedUnit, "origin" ) )
                call UnitApplyTimedLife( bj_lastCreatedUnit, 'BTLF', 30 )
                call SaveUnitHandle( udg_hash, GetHandleId( h ), StringHash( "dmch" ), bj_lastCreatedUnit )
            else
                set cyclA = cyclA - 1
            endif
            set cyclA = cyclA + 1
            set i = i + 1
        endloop
    elseif rand == 8 then
        call textst( "|c00FF6000 More chests!", GetDyingUnit(), 64, 90, 15, 1.5 )
        set cyclA = 1
        loop
            exitwhen cyclA > 2
            call CreateUnit( Player(PLAYER_NEUTRAL_AGGRESSIVE), 'h01L', GetUnitX( GetDyingUnit() ) + GetRandomReal( -200, 200 ), GetUnitY( GetDyingUnit() ) + GetRandomReal( -200, 200 ), 270 )
            set cyclA = cyclA + 1
        endloop
    endif
    
    call GroupClear( g )
    call DestroyGroup( g )
    set g = null
    set u = null
    set h = null
    set loc = null
endfunction

//===========================================================================
function InitTrig_Chest takes nothing returns nothing
    set gg_trg_Chest = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Chest, EVENT_PLAYER_UNIT_DEATH )
    call TriggerAddCondition( gg_trg_Chest, Condition( function Trig_Chest_Conditions ) )
    call TriggerAddAction( gg_trg_Chest, function Trig_Chest_Actions )
endfunction

