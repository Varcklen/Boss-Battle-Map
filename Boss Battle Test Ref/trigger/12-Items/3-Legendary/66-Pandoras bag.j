function Trig_Pandoras_bag_Conditions takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == 'I0EV'
endfunction

function Trig_Pandoras_bag_Actions takes nothing returns nothing
	local integer cyclA = 2
	local integer array it

	set it[0] = 0
	set it[1] = 0
	loop
		exitwhen cyclA > 4
		set it[cyclA] = udg_DB_Rewards[GetRandomInt( 1, udg_Database_NumberItems[23] )]
		if (it[cyclA] == it[cyclA-1] or it[cyclA] == it[cyclA-2]) then
			set cyclA = cyclA - 1
		endif
		set cyclA = cyclA + 1
	endloop
	call forge( GetManipulatingUnit(), GetManipulatedItem(), it[4], it[2], it[3], true )
endfunction

//===========================================================================
function InitTrig_Pandoras_bag takes nothing returns nothing
    set gg_trg_Pandoras_bag = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Pandoras_bag, EVENT_PLAYER_UNIT_USE_ITEM )
    call TriggerAddCondition( gg_trg_Pandoras_bag, Condition( function Trig_Pandoras_bag_Conditions ) )
    call TriggerAddAction( gg_trg_Pandoras_bag, function Trig_Pandoras_bag_Actions )
endfunction

