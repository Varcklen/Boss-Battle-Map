function Trig_MiracleBrewL_Conditions takes nothing returns boolean
    return GetUnitAbilityLevel(GetManipulatingUnit(), 'A0DC') > 0 and not(LoadBoolean( udg_hash, GetHandleId( GetManipulatedItem() ), StringHash( "nocrt" ))) and GetItemType(GetManipulatedItem()) == ITEM_TYPE_POWERUP and inv( GetManipulatingUnit(), GetItemTypeId( GetManipulatedItem() ) ) > 1 and SubString(BlzGetItemDescription(GetManipulatedItem()), 0, 16) == "|cff088a08Potion"
endfunction
//and not(udg_logic[74])
function Trig_MiracleBrewL_Actions takes nothing returns nothing
    local integer cyclA = 0
    local item it
    local unit c = GetManipulatingUnit()
    local integer lim = GetUnitAbilityLevel(c, 'A0DC') + 2
    
    loop
        exitwhen cyclA > bj_MAX_INVENTORY
        set it = UnitItemInSlot(c, cyclA)
        if GetManipulatedItem() != it and GetItemTypeId(it) == GetItemTypeId( GetManipulatedItem() ) and BlzGetItemIntegerField(it, ITEM_IF_NUMBER_OF_CHARGES) < lim then
            set cyclA = bj_MAX_INVENTORY
        else
            set it = null
        endif
        set cyclA = cyclA + 1
    endloop
        
    if it != null and not(LoadBoolean( udg_hash, GetHandleId( it ), StringHash( "nocrt" ))) then
        call BlzSetItemIntegerFieldBJ( it, ITEM_IF_NUMBER_OF_CHARGES, BlzGetItemIntegerField(it, ITEM_IF_NUMBER_OF_CHARGES) + BlzGetItemIntegerField(GetManipulatedItem(), ITEM_IF_NUMBER_OF_CHARGES) )
        call RemoveItem( GetManipulatedItem() )
    endif

    set it = null
    set c = null
endfunction

//===========================================================================
function InitTrig_MiracleBrewL takes nothing returns nothing
    set gg_trg_MiracleBrewL = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_MiracleBrewL, EVENT_PLAYER_UNIT_PICKUP_ITEM )
    call TriggerAddCondition( gg_trg_MiracleBrewL, Condition( function Trig_MiracleBrewL_Conditions ) )
    call TriggerAddAction( gg_trg_MiracleBrewL, function Trig_MiracleBrewL_Actions )
endfunction

