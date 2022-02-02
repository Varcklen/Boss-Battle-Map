function Trig_Tarot_Card_Wealth_Conditions takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == 'I0D9'
endfunction

function Trig_Tarot_Card_Wealth_Actions takes nothing returns nothing
    local unit u = GetManipulatingUnit()
    local integer cyclA = 0
    local item it
    
    call stazisst( GetManipulatingUnit(), GetManipulatedItem() )
    loop
        exitwhen cyclA > 5
	set it = UnitItemInSlot( u, cyclA )
        if it != null and GetItemType(it) != ITEM_TYPE_ARTIFACT and GetItemType(it) != ITEM_TYPE_POWERUP and GetItemType(it) != ITEM_TYPE_PURCHASABLE then
            call Inventory_ReplaceItemByNew(u, UnitItemInSlot( u, cyclA ), ItemRandomizerItemId( u, "legendary" ))
        endif
        set cyclA = cyclA + 1
    endloop
    
    call DestroyEffect( AddSpecialEffect( "Objects\\Spawnmodels\\Human\\HCancelDeath\\HCancelDeath.mdl", GetUnitX( GetManipulatingUnit() ), GetUnitY( GetManipulatingUnit() ) ) )
    
    set u = null
    set it = null
endfunction

//===========================================================================
function InitTrig_Tarot_Card_Wealth takes nothing returns nothing
    set gg_trg_Tarot_Card_Wealth = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Tarot_Card_Wealth, EVENT_PLAYER_UNIT_USE_ITEM )
    call TriggerAddCondition( gg_trg_Tarot_Card_Wealth, Condition( function Trig_Tarot_Card_Wealth_Conditions ) )
    call TriggerAddAction( gg_trg_Tarot_Card_Wealth, function Trig_Tarot_Card_Wealth_Actions )
endfunction

