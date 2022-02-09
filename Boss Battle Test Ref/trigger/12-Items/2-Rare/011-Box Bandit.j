function Trig_Box_Bandit_Conditions takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == 'I06Z'
endfunction

function Trig_Box_Bandit_Actions takes nothing returns nothing
	call forge( GetManipulatingUnit(), GetManipulatedItem(), 'I05V', 'I06A', 'I06B', true )
endfunction

//===========================================================================
function InitTrig_Box_Bandit takes nothing returns nothing
    set gg_trg_Box_Bandit = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Box_Bandit, EVENT_PLAYER_UNIT_USE_ITEM )
    call TriggerAddCondition( gg_trg_Box_Bandit, Condition( function Trig_Box_Bandit_Conditions ) )
    call TriggerAddAction( gg_trg_Box_Bandit, function Trig_Box_Bandit_Actions )
endfunction

