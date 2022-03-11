function Trig_Courage_Conditions takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == 'I0BD'
endfunction

function Trig_Courage_Actions takes nothing returns nothing                
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Human\\Avatar\\AvatarCaster.mdl", GetManipulatingUnit(), "origin") )
    call statst( GetManipulatingUnit(), 3, 3, 3, 0, true )
    call stazisst( GetManipulatingUnit(), GetManipulatedItem() )
endfunction

//===========================================================================
function InitTrig_Courage takes nothing returns nothing
    set gg_trg_Courage = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Courage, EVENT_PLAYER_UNIT_USE_ITEM )
    call TriggerAddCondition( gg_trg_Courage, Condition( function Trig_Courage_Conditions ) )
    call TriggerAddAction( gg_trg_Courage, function Trig_Courage_Actions )
endfunction

