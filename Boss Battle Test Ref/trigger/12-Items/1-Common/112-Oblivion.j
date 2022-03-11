function Trig_Oblivion_Conditions takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == 'I05Y'
endfunction

function Trig_Oblivion_Actions takes nothing returns nothing
    call stazisst( GetManipulatingUnit(), GetManipulatedItem() )
    call statst( GetManipulatingUnit(), 1, 1, 1, 0, true )
    call UnitAddItem(GetManipulatingUnit(), CreateItem( 'I01M', GetUnitX(GetManipulatingUnit()), GetUnitY(GetManipulatingUnit())))
endfunction

//===========================================================================
function InitTrig_Oblivion takes nothing returns nothing
    set gg_trg_Oblivion = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Oblivion, EVENT_PLAYER_UNIT_USE_ITEM )
    call TriggerAddCondition( gg_trg_Oblivion, Condition( function Trig_Oblivion_Conditions ) )
    call TriggerAddAction( gg_trg_Oblivion, function Trig_Oblivion_Actions )
endfunction

