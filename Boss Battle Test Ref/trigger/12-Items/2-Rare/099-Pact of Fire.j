function Trig_Pact_of_Fire_Conditions takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == 'I0FF'
endfunction

function Trig_Pact_of_Fire_Actions takes nothing returns nothing    
    call SpellUniqueUnit(GetManipulatingUnit(), 25)
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Demon\\DarkPortal\\DarkPortalTarget.mdl", GetManipulatingUnit(), "origin") )
    call statst( GetManipulatingUnit(), 1, 1, 1, 0, true )
    call stazisst( GetManipulatingUnit(), GetManipulatedItem() )
endfunction

//===========================================================================
function InitTrig_Pact_of_Fire takes nothing returns nothing
    set gg_trg_Pact_of_Fire = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Pact_of_Fire, EVENT_PLAYER_UNIT_USE_ITEM )
    call TriggerAddCondition( gg_trg_Pact_of_Fire, Condition( function Trig_Pact_of_Fire_Conditions ) )
    call TriggerAddAction( gg_trg_Pact_of_Fire, function Trig_Pact_of_Fire_Actions )
endfunction

