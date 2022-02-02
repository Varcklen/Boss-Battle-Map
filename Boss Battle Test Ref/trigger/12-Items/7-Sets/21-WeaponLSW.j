function Trig_WeaponLSW_Conditions takes nothing returns boolean
    return not( udg_logic[36] ) and GetItemTypeId(GetManipulatedItem()) == 'I030'
endfunction

function Trig_WeaponLSW_Actions takes nothing returns nothing
    local unit n = GetManipulatingUnit()//udg_hero[GetPlayerId(GetOwningPlayer(GetManipulatingUnit())) + 1]
    local integer i = CorrectPlayer(n)//GetPlayerId(GetOwningPlayer(n)) + 1
    local integer cyclA = 0
    
    set udg_logic[i + 54] = false
    if udg_Set_Weapon_Logic[i + 4] then
        call UnitRemoveAbility( n, 'A05I')
    endif
    if udg_Set_Weapon_Logic[i + 12] then
        call UnitRemoveAbility( n, 'A0P3')
        call UnitRemoveAbility( n, 'A0P4')
    endif
    if udg_Set_Weapon_Logic[i + 16] then
        call UnitRemoveAbility( n, 'A0YX')
    endif
    if udg_Set_Weapon_Logic[i + 20] then
        call UnitRemoveAbility( n, 'A1DI')
    endif
    if udg_Set_Weapon_Logic[i + 24] then
        call UnitRemoveAbility( n, 'A02A')
    endif
    if udg_Set_Weapon_Logic[i + 28] then
        call UnitRemoveAbility( n, 'A0R2')
        call UnitRemoveAbility( n, 'A0R3')
    endif
    if udg_Set_Weapon_Logic[i + 40] then
        call UnitRemoveAbility( n, 'A0QX')
    endif
    if udg_Set_Weapon_Logic[i + 44] then
        call UnitRemoveAbility( n, 'A11S' )
    endif
    if udg_Set_Weapon_Logic[i + 64] then
        call UnitRemoveAbility( n, 'A0WH')
    endif
    if udg_Set_Weapon_Logic[i + 68] then
        call UnitRemoveAbility( n, 'A0X7')
    endif
    if udg_Set_Weapon_Logic[i + 84] then
        call UnitRemoveAbility( n, 'A175')
    endif
    if udg_Set_Weapon_Logic[i + 96] then
        call spdst( n, 30 )
    endif
    if udg_Set_Weapon_Logic[i + 100] then
        call spdst( n, -10 )
        call UnitRemoveAbility( n, 'A18J')
    endif
    if not( udg_logic[52] ) then
        call DisplayTimedTextToPlayer(GetOwningPlayer(n), 0, 0, 5., "Set |cff2d9995Weapon|r is now disassembled!")
        call iconoff( i, "Оружие" )
    endif
    
    
    set Event_UnitLoseUltimateWeapon_Hero = n
    set Event_UnitLoseUltimateWeapon_Item = GetManipulatedItem()
    
    set Event_UnitLoseUltimateWeapon_Real = 0.00
    set Event_UnitLoseUltimateWeapon_Real = 1.00
    set Event_UnitLoseUltimateWeapon_Real = 0.00
    
    set cyclA = 0
    set udg_Set_Weapon_Number[i] = 0
    loop
        exitwhen cyclA > 5
        if Weapon_Logic(UnitItemInSlot(n, cyclA)) then
            set udg_Set_Weapon_Number[i] = udg_Set_Weapon_Number[i] + 1
        endif
        set cyclA = cyclA + 1
    endloop
    
    set n = null
endfunction

//===========================================================================
function InitTrig_WeaponLSW takes nothing returns nothing
    set gg_trg_WeaponLSW = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_WeaponLSW, EVENT_PLAYER_UNIT_DROP_ITEM )
    call TriggerAddCondition( gg_trg_WeaponLSW, Condition( function Trig_WeaponLSW_Conditions ) )
    call TriggerAddAction( gg_trg_WeaponLSW, function Trig_WeaponLSW_Actions )
endfunction

