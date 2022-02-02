function Trig_Corrupted_Wish_Conditions takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == 'I00N'
endfunction

function Trig_Corrupted_Wish_Actions takes nothing returns nothing
    local integer cyclA = 1
    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\Polymorph\\PolyMorphDoneGround.mdl", GetUnitX( GetManipulatingUnit() ), GetUnitY( GetManipulatingUnit() ) ) )
    call stazisst( GetManipulatingUnit(), GetManipulatedItem() )
    loop
        exitwhen cyclA > 3
        if UnitInventoryCount(GetManipulatingUnit()) < 6 then
            call UnitAddItem( GetManipulatingUnit(), CreateItem(udg_DB_Item_Destroyed[GetRandomInt( 1, udg_Database_NumberItems[29] )], GetUnitX( GetManipulatingUnit() ), GetUnitY( GetManipulatingUnit() )))
        endif
        set cyclA = cyclA + 1
    endloop
endfunction

//===========================================================================
function InitTrig_Corrupted_Wish takes nothing returns nothing
    set gg_trg_Corrupted_Wish = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Corrupted_Wish, EVENT_PLAYER_UNIT_USE_ITEM )
    call TriggerAddCondition( gg_trg_Corrupted_Wish, Condition( function Trig_Corrupted_Wish_Conditions ) )
    call TriggerAddAction( gg_trg_Corrupted_Wish, function Trig_Corrupted_Wish_Actions )
endfunction

