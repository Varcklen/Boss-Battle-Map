function Trig_Wheel_of_Fortune_Conditions takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == 'I0A7'
endfunction

function Trig_Wheel_of_Fortune_Actions takes nothing returns nothing
    local unit u = GetManipulatingUnit()
    local integer cyclA = 0
    local item it
    
    call stazisst( GetManipulatingUnit(), GetManipulatedItem() )
    loop
        exitwhen cyclA > 5
        set it = UnitItemInSlot( u, cyclA )
        if it != null and GetItemType(it) != ITEM_TYPE_POWERUP and GetItemType(it) != ITEM_TYPE_PURCHASABLE then
            call Inventory_ReplaceItem(GetManipulatingUnit(), it, ItemRandomizerAll( GetManipulatingUnit(), 0 ))
        endif
        set cyclA = cyclA + 1
    endloop
    
    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\Polymorph\\PolyMorphDoneGround.mdl", GetUnitX( GetManipulatingUnit() ), GetUnitY( GetManipulatingUnit() ) ) )
    
    set u = null
    set it = null
endfunction

//===========================================================================
function InitTrig_Wheel_of_Fortune takes nothing returns nothing
    set gg_trg_Wheel_of_Fortune = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Wheel_of_Fortune, EVENT_PLAYER_UNIT_USE_ITEM )
    call TriggerAddCondition( gg_trg_Wheel_of_Fortune, Condition( function Trig_Wheel_of_Fortune_Conditions ) )
    call TriggerAddAction( gg_trg_Wheel_of_Fortune, function Trig_Wheel_of_Fortune_Actions )
endfunction

