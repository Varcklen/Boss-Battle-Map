function Trig_VIP_card_Conditions takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == 'I0GB'
endfunction

function Trig_VIP_card_Actions takes nothing returns nothing
    call JuleUpgradeUse()
    call statst( GetManipulatingUnit(), 1, 1, 1, 0, true )
    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\Polymorph\\PolyMorphDoneGround.mdl", GetUnitX( GetManipulatingUnit() ), GetUnitY( GetManipulatingUnit() ) ) )
    call stazisst( GetManipulatingUnit(), GetManipulatedItem() )
endfunction

//===========================================================================
function InitTrig_VIP_card takes nothing returns nothing
    set gg_trg_VIP_card = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_VIP_card, EVENT_PLAYER_UNIT_USE_ITEM )
    call TriggerAddCondition( gg_trg_VIP_card, Condition( function Trig_VIP_card_Conditions ) )
    call TriggerAddAction( gg_trg_VIP_card, function Trig_VIP_card_Actions )
endfunction

