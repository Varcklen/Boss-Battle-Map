function Trig_SniperRH_Conditions takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == 'I05T'
endfunction

function Trig_SniperRH_Actions takes nothing returns nothing
    call healst( LoadUnitHandle( udg_hash, GetHandleId( GetManipulatedItem() ), StringHash( "snpr" ) ), GetManipulatingUnit(), LoadReal( udg_hash, GetHandleId( GetManipulatedItem() ), StringHash( "snpr" ) ) )
    call RemoveSavedHandle(udg_hash, GetHandleId( GetManipulatedItem() ), StringHash( "snpr" ) )
    call RemoveSavedReal(udg_hash, GetHandleId( GetManipulatedItem() ), StringHash( "snpr" ) )
    call spectimeunit( GetManipulatingUnit(), "Abilities\\Spells\\Human\\Heal\\HealTarget.mdl", "origin", 2 )
endfunction

//===========================================================================
function InitTrig_SniperRH takes nothing returns nothing
    set gg_trg_SniperRH = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_SniperRH, EVENT_PLAYER_UNIT_PICKUP_ITEM )
    call TriggerAddCondition( gg_trg_SniperRH, Condition( function Trig_SniperRH_Conditions ) )
    call TriggerAddAction( gg_trg_SniperRH, function Trig_SniperRH_Actions )
endfunction

