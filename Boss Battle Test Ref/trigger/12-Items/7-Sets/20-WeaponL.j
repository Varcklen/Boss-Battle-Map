function Trig_WeaponL_Conditions takes nothing returns boolean
    if udg_logic[36] then
        return false
    endif
    if not( Weapon_Logic(GetManipulatedItem()) ) then
        return false
    endif
    if udg_logic[GetPlayerId(GetOwningPlayer(GetManipulatingUnit())) + 1 + 54] then
        return false
    endif
    return true
endfunction

function Trig_WeaponL_Actions takes nothing returns nothing
    local unit n = GetManipulatingUnit()//udg_hero[GetPlayerId(GetOwningPlayer(GetManipulatingUnit())) + 1]
    local integer i = CorrectPlayer(n)//GetPlayerId(GetOwningPlayer(n)) + 1

    set udg_Set_Weapon_Number[i] = udg_Set_Weapon_Number[i] - 1
    
    set Event_UnitLoseWeapon_Hero = n
    set Event_UnitLoseWeapon_Item = GetManipulatedItem()
    
    set Event_UnitLoseWeapon_Real = 0.00
    set Event_UnitLoseWeapon_Real = 1.00
    set Event_UnitLoseWeapon_Real = 0.00
    
    //call AllSetRing( n, 7, GetManipulatedItem() )
    
    set n = null
endfunction

//===========================================================================
function InitTrig_WeaponL takes nothing returns nothing
    set gg_trg_WeaponL = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_WeaponL, EVENT_PLAYER_UNIT_DROP_ITEM )
    call TriggerAddCondition( gg_trg_WeaponL, Condition( function Trig_WeaponL_Conditions ) )
    call TriggerAddAction( gg_trg_WeaponL, function Trig_WeaponL_Actions )
endfunction

