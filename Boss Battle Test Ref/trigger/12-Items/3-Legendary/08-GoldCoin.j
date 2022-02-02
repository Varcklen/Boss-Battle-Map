function Trig_GoldCoin_Conditions takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == 'I00G'
endfunction

function Trig_GoldCoin_Actions takes nothing returns nothing
    call moneyst( GetManipulatingUnit(), 1000 )
    call stazisst( GetManipulatingUnit(), GetManipulatedItem() )
endfunction

//===========================================================================
function InitTrig_GoldCoin takes nothing returns nothing
    set gg_trg_GoldCoin = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_GoldCoin, EVENT_PLAYER_UNIT_USE_ITEM )
    call TriggerAddCondition( gg_trg_GoldCoin, Condition( function Trig_GoldCoin_Conditions ) )
    call TriggerAddAction( gg_trg_GoldCoin, function Trig_GoldCoin_Actions )
endfunction

