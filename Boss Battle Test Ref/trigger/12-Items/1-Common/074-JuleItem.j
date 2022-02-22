function Trig_JuleItem_Conditions takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == 'I0BC'
endfunction

function Trig_JuleItem_Actions takes nothing returns nothing
    call JuleRef()
    call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\Human\\Polymorph\\PolyMorphDoneGround.mdl", GetManipulatingUnit(), "origin" ) )
    call statst( GetManipulatingUnit(), 1, 1, 1, 0, true )
    
    call stazisst( GetManipulatingUnit(), GetManipulatedItem() )
endfunction

//===========================================================================
function InitTrig_JuleItem takes nothing returns nothing
    set gg_trg_JuleItem = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_JuleItem, EVENT_PLAYER_UNIT_USE_ITEM )
    call TriggerAddCondition( gg_trg_JuleItem, Condition( function Trig_JuleItem_Conditions ) )
    call TriggerAddAction( gg_trg_JuleItem, function Trig_JuleItem_Actions )
endfunction

