function Trig_Big_Surprise_Conditions takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == 'I0A1'
endfunction

function Trig_Big_Surprise_Actions takes nothing returns nothing
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
            exitwhen cyclA > 3
            if UnitInventoryCount(GetManipulatingUnit()) < 6 then
                call ItemRandomizer( GetManipulatingUnit(), "common" )
            else
                set cyclA = 3
            endif
            set cyclA = cyclA + 1
        endloop
    else
        call ItemRandomizer( GetManipulatingUnit(), "common" )
    endif
endfunction

//===========================================================================
function InitTrig_Big_Surprise takes nothing returns nothing
    set gg_trg_Big_Surprise = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Big_Surprise, EVENT_PLAYER_UNIT_USE_ITEM )
    call TriggerAddCondition( gg_trg_Big_Surprise, Condition( function Trig_Big_Surprise_Conditions ) )
    call TriggerAddAction( gg_trg_Big_Surprise, function Trig_Big_Surprise_Actions )
endfunction

