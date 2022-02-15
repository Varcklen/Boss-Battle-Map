function Trig_Fortune_deck_Conditions takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == 'I0C7'
endfunction

function Trig_Fortune_deck_Actions takes nothing returns nothing
	call FortuneDeck( GetManipulatingUnit(), GetManipulatedItem() )
endfunction

//===========================================================================
function InitTrig_Fortune_deck takes nothing returns nothing
    set gg_trg_Fortune_deck = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Fortune_deck, EVENT_PLAYER_UNIT_USE_ITEM )
    call TriggerAddCondition( gg_trg_Fortune_deck, Condition( function Trig_Fortune_deck_Conditions ) )
    call TriggerAddAction( gg_trg_Fortune_deck, function Trig_Fortune_deck_Actions )
endfunction

