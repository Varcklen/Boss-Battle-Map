function Trig_Box_Thief_Conditions takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == 'I0GM'
endfunction

function Trig_Box_Thief_Actions takes nothing returns nothing
	call forge( GetManipulatingUnit(), GetManipulatedItem(), THIEF_PIECE_01, THIEF_PIECE_02, THIEF_PIECE_03, true )
endfunction

//===========================================================================
function InitTrig_Box_Thief takes nothing returns nothing
    set gg_trg_Box_Thief = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Box_Thief, EVENT_PLAYER_UNIT_USE_ITEM )
    call TriggerAddCondition( gg_trg_Box_Thief, Condition( function Trig_Box_Thief_Conditions ) )
    call TriggerAddAction( gg_trg_Box_Thief, function Trig_Box_Thief_Actions )
endfunction

