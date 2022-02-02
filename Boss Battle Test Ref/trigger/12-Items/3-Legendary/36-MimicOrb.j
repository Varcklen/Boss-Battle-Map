function Trig_MimicOrb_Conditions takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == 'I0EN'
endfunction

function Trig_MimicOrb_Actions takes nothing returns nothing
	call MimicOrb( GetManipulatingUnit(), GetManipulatedItem() )
endfunction

//===========================================================================
function InitTrig_MimicOrb takes nothing returns nothing
    set gg_trg_MimicOrb = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_MimicOrb, EVENT_PLAYER_UNIT_USE_ITEM )
    call TriggerAddCondition( gg_trg_MimicOrb, Condition( function Trig_MimicOrb_Conditions ) )
    call TriggerAddAction( gg_trg_MimicOrb, function Trig_MimicOrb_Actions )
endfunction

