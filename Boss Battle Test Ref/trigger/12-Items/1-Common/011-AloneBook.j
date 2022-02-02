function Trig_AloneBook_Conditions takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == 'I0B4'
endfunction

function Trig_AloneBook_Actions takes nothing returns nothing
    call stazisst( GetManipulatingUnit(), GetManipulatedItem() )
    call SetHeroLevel( GetManipulatingUnit(), GetHeroLevel(GetManipulatingUnit()) + 4, true)
endfunction

//===========================================================================
function InitTrig_AloneBook takes nothing returns nothing
    set gg_trg_AloneBook = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_AloneBook, EVENT_PLAYER_UNIT_USE_ITEM )
    call TriggerAddCondition( gg_trg_AloneBook, Condition( function Trig_AloneBook_Conditions ) )
    call TriggerAddAction( gg_trg_AloneBook, function Trig_AloneBook_Actions )
endfunction

