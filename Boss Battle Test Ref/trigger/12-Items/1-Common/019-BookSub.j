function Trig_BookSub_Conditions takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == 'I00H'
endfunction

function Trig_BookSub_Actions takes nothing returns nothing
    call SetHeroLevel( GetManipulatingUnit(), GetHeroLevel(GetManipulatingUnit()) + 1, true)
    call stazisst( GetManipulatingUnit(), GetManipulatedItem() )
endfunction

//===========================================================================
function InitTrig_BookSub takes nothing returns nothing
    set gg_trg_BookSub = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_BookSub, EVENT_PLAYER_UNIT_USE_ITEM )
    call TriggerAddCondition( gg_trg_BookSub, Condition( function Trig_BookSub_Conditions ) )
    call TriggerAddAction( gg_trg_BookSub, function Trig_BookSub_Actions )
endfunction

