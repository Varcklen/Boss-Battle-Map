function Trig_Royal_letter_Conditions takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == 'I0CY'
endfunction

function Trig_Royal_letter_Actions takes nothing returns nothing
    local integer cyclA = 0
    local integer i = 0
    
    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\Polymorph\\PolyMorphDoneGround.mdl", GetUnitX( GetManipulatingUnit() ), GetUnitY( GetManipulatingUnit() ) ) )
    call stazisst( GetManipulatingUnit(), GetManipulatedItem() )
    
    loop
        exitwhen cyclA > 5
        if UnitHasItem(GetManipulatingUnit(), UnitItemInSlot(GetManipulatingUnit(), cyclA)) and GetItemType(UnitItemInSlot(GetManipulatingUnit(), cyclA)) != ITEM_TYPE_POWERUP and GetItemType(UnitItemInSlot(GetManipulatingUnit(), cyclA)) != ITEM_TYPE_PURCHASABLE then
            set i = i + 1
        endif
        set cyclA = cyclA + 1
    endloop
    if i == 0 then
        set cyclA = 1
        loop
            exitwhen cyclA > 6
            if UnitInventoryCount(GetManipulatingUnit()) < 6 then
                call UnitAddItem( GetManipulatingUnit(), CreateItem(udg_DB_Item_Destroyed[GetRandomInt( 1, udg_Database_NumberItems[29] )], GetUnitX(GetManipulatingUnit()), GetUnitY(GetManipulatingUnit()) ) )
            else
                set cyclA = 6
            endif
            set cyclA = cyclA + 1
        endloop
    else
        call UnitAddItem( GetManipulatingUnit(), CreateItem(udg_DB_Item_Destroyed[GetRandomInt( 1, udg_Database_NumberItems[29] )], GetUnitX(GetManipulatingUnit()), GetUnitY(GetManipulatingUnit()) ) )
    endif
endfunction

//===========================================================================
function InitTrig_Royal_letter takes nothing returns nothing
    set gg_trg_Royal_letter = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Royal_letter, EVENT_PLAYER_UNIT_USE_ITEM )
    call TriggerAddCondition( gg_trg_Royal_letter, Condition( function Trig_Royal_letter_Conditions ) )
    call TriggerAddAction( gg_trg_Royal_letter, function Trig_Royal_letter_Actions )
endfunction

