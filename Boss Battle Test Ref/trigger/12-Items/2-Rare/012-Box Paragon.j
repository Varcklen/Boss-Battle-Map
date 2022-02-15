function Trig_Box_Paragon_Conditions takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == 'I0GL'
endfunction

function Trig_Box_Paragon_Actions takes nothing returns nothing
	call forge( GetManipulatingUnit(), GetManipulatedItem(), PARAGON_PIECE_01, PARAGON_PIECE_02, PARAGON_PIECE_03, true )
endfunction

//===========================================================================
function InitTrig_Box_Paragon takes nothing returns nothing
    set gg_trg_Box_Paragon = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Box_Paragon, EVENT_PLAYER_UNIT_USE_ITEM )
    call TriggerAddCondition( gg_trg_Box_Paragon, Condition( function Trig_Box_Paragon_Conditions ) )
    call TriggerAddAction( gg_trg_Box_Paragon, function Trig_Box_Paragon_Actions )
endfunction

