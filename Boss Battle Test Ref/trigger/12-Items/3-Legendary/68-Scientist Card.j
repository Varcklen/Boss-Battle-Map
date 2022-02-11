function Trig_Scientist_Card_Conditions takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == 'I0EZ'
endfunction

function Trig_Scientist_Card_Actions takes nothing returns nothing                
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Human\\Resurrect\\ResurrectTarget.mdl", GetManipulatingUnit(), "origin") )
    call statst( GetManipulatingUnit(), 20, 20, 20, 0, true )
    call stazisst( GetManipulatingUnit(), GetManipulatedItem() )
endfunction

//===========================================================================
function InitTrig_Scientist_Card takes nothing returns nothing
    set gg_trg_Scientist_Card = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Scientist_Card, EVENT_PLAYER_UNIT_USE_ITEM )
    call TriggerAddCondition( gg_trg_Scientist_Card, Condition( function Trig_Scientist_Card_Conditions ) )
    call TriggerAddAction( gg_trg_Scientist_Card, function Trig_Scientist_Card_Actions )
endfunction

