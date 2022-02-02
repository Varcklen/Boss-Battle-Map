globals
    real Event_UnitAddUltimateWeapon_Real
    unit Event_UnitAddUltimateWeapon_Hero
    item Event_UnitAddUltimateWeapon_Item
    
    real Event_UnitLoseUltimateWeapon_Real
    unit Event_UnitLoseUltimateWeapon_Hero
    item Event_UnitLoseUltimateWeapon_Item
endglobals

function Trig_WeaponGSW_Conditions takes nothing returns boolean
    return not( udg_logic[36] ) and GetItemTypeId(GetManipulatedItem()) == 'I030'
endfunction

function Trig_WeaponGSW_Actions takes nothing returns nothing
    local unit n = GetManipulatingUnit()//udg_hero[GetPlayerId(GetOwningPlayer(GetManipulatingUnit())) + 1]
    local integer i = CorrectPlayer(n)//GetPlayerId(GetOwningPlayer(n)) + 1

    set udg_logic[i + 54] = true

    //if GetUnitAbilityLevel( n, 'A09I') > 0 then
    //    call BlzSetUnitBaseDamage( n, BlzGetUnitBaseDamage(n, 0) + 6, 0 )
    //endif

    if udg_Set_Weapon_Logic[i + 4] then
        call UnitAddAbility( n, 'A05I')
    endif
    if udg_Set_Weapon_Logic[i + 12] then
        call UnitAddAbility( n, 'A0P3')
        call UnitAddAbility( n, 'A0P4')
    endif
    if udg_Set_Weapon_Logic[i + 16] then
        call UnitAddAbility( n, 'A0YX')
    endif
    if udg_Set_Weapon_Logic[i + 20] then
        call UnitAddAbility( n, 'A1DI')
    endif
    if udg_Set_Weapon_Logic[i + 24] then
        call UnitAddAbility( n, 'A02A')
    endif
    if udg_Set_Weapon_Logic[i + 28] then
        call UnitAddAbility( n, 'A0R2')
        call UnitAddAbility( n, 'A0R3')
    endif
    if udg_Set_Weapon_Logic[i + 40] then
        call UnitAddAbility( n, 'A0QX')
    endif
    if udg_Set_Weapon_Logic[i + 44] then
        call UnitAddAbility( n, 'A11S' )
    endif
    if udg_Set_Weapon_Logic[i + 64] then
        call UnitAddAbility( n, 'A0WH')
    endif
    if udg_Set_Weapon_Logic[i + 68] then
        call UnitAddAbility( n, 'A0X7')
    endif
    if udg_Set_Weapon_Logic[i + 84] then
        call UnitAddAbility( n, 'A175')
    endif
    if udg_Set_Weapon_Logic[i + 96] then
        call spdst( n, -30 )
    endif
    if udg_Set_Weapon_Logic[i + 100] then
        call spdst( n, 10 )
        call UnitAddAbility( n, 'A18J')
    endif
    call DisplayTimedTextToForce( bj_FORCE_ALL_PLAYERS, 5.00, udg_Player_Color[i] + GetPlayerName(GetOwningPlayer(n)) + "|r assembled set |cff2d9995Weapon|r!" )
    call DestroyEffect( AddSpecialEffect( "Objects\\Spawnmodels\\Human\\HCancelDeath\\HCancelDeath.mdl", GetUnitX( n ), GetUnitY( n ) ) )
    call iconon( i,  "Оружие", "war3mapImported\\PASAchievement_Arena_3v3_7_result.blp" )
    
    
    
    set Event_UnitAddUltimateWeapon_Hero = n
    set Event_UnitAddUltimateWeapon_Item = GetManipulatedItem()
    
    set Event_UnitAddUltimateWeapon_Real = 0.00
    set Event_UnitAddUltimateWeapon_Real = 1.00
    set Event_UnitAddUltimateWeapon_Real = 0.00
    
    set n = null
endfunction

//===========================================================================
function InitTrig_WeaponGSW takes nothing returns nothing
    set gg_trg_WeaponGSW = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_WeaponGSW, EVENT_PLAYER_UNIT_PICKUP_ITEM )
    call TriggerAddCondition( gg_trg_WeaponGSW, Condition( function Trig_WeaponGSW_Conditions ) )
    call TriggerAddAction( gg_trg_WeaponGSW, function Trig_WeaponGSW_Actions )
endfunction

