function Trig_GunMasterW_Conditions takes nothing returns boolean
    return GetUnitAbilityLevel(GetOrderedUnit(), 'A19F') > 0
endfunction

function Trig_GunMasterW_Actions takes nothing returns nothing
    local unit u = GetOrderedUnit()
    local integer lvl = GetUnitAbilityLevel( u, 'A19F' )

    if GetIssuedOrderId() == OrderId("immolation") then
        call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Human\\ControlMagic\\ControlMagicTarget.mdl", u, "overhead") )
        call BlzSetUnitWeaponStringFieldBJ( u, UNIT_WEAPON_SF_ATTACK_PROJECTILE_ART, 0, ".mdl" )
    elseif GetIssuedOrderId() == OrderId("unimmolation") then
        call BlzSetUnitWeaponStringFieldBJ( u, UNIT_WEAPON_SF_ATTACK_PROJECTILE_ART, 0, "Abilities\\Weapons\\Rifle\\RifleImpact.mdl" )
    endif
    
    set u = null
endfunction

//===========================================================================
function InitTrig_GunMasterW takes nothing returns nothing
    set gg_trg_GunMasterW = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_GunMasterW, EVENT_PLAYER_UNIT_ISSUED_ORDER )
    call TriggerAddCondition( gg_trg_GunMasterW, Condition( function Trig_GunMasterW_Conditions ) )
    call TriggerAddAction( gg_trg_GunMasterW, function Trig_GunMasterW_Actions )
endfunction