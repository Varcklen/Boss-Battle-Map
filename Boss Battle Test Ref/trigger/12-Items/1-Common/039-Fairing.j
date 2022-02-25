function Trig_Fairing_Conditions takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == 'I065'
endfunction

function Trig_Fairing_Actions takes nothing returns nothing
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Human\\Polymorph\\PolyMorphDoneGround.mdl", GetManipulatingUnit(), "origin" ) )
    call stazisst( GetManipulatingUnit(), GetManipulatedItem() )
    call ItemRandomizer( GetManipulatingUnit(), "rare" )
endfunction

//===========================================================================
function InitTrig_Fairing takes nothing returns nothing
    set gg_trg_Fairing = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Fairing, EVENT_PLAYER_UNIT_USE_ITEM )
    call TriggerAddCondition( gg_trg_Fairing, Condition( function Trig_Fairing_Conditions ) )
    call TriggerAddAction( gg_trg_Fairing, function Trig_Fairing_Actions )
endfunction

