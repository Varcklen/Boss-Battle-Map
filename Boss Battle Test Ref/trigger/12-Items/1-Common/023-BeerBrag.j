function Trig_BeerBrag_Conditions takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == 'I0CS'
endfunction

function Trig_BeerBrag_Actions takes nothing returns nothing
    call NewUniques( GetManipulatingUnit(), 'A15W' )
    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Other\\StrongDrink\\BrewmasterMissile.mdl", GetUnitX( GetManipulatingUnit() ), GetUnitY( GetManipulatingUnit() ) ) )
    call stazisst( GetManipulatingUnit(), GetManipulatedItem() )
endfunction

//===========================================================================
function InitTrig_BeerBrag takes nothing returns nothing
    set gg_trg_BeerBrag = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_BeerBrag, EVENT_PLAYER_UNIT_USE_ITEM )
    call TriggerAddCondition( gg_trg_BeerBrag, Condition( function Trig_BeerBrag_Conditions ) )
    call TriggerAddAction( gg_trg_BeerBrag, function Trig_BeerBrag_Actions )
endfunction

