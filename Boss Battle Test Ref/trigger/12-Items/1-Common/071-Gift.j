function Trig_Gift_Conditions takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == 'I02W'
endfunction

function Trig_Gift_Actions takes nothing returns nothing
    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\Polymorph\\PolyMorphDoneGround.mdl", GetUnitX( GetManipulatingUnit() ), GetUnitY( GetManipulatingUnit() ) ) )
    call moneyst( GetManipulatingUnit(), 250 )
    call stazisst( GetManipulatingUnit(), GetManipulatedItem() )
    call ItemRandomizer( GetManipulatingUnit(), "common" )
endfunction

//===========================================================================
function InitTrig_Gift takes nothing returns nothing
    set gg_trg_Gift = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Gift, EVENT_PLAYER_UNIT_USE_ITEM )
    call TriggerAddCondition( gg_trg_Gift, Condition( function Trig_Gift_Conditions ) )
    call TriggerAddAction( gg_trg_Gift, function Trig_Gift_Actions )
endfunction

