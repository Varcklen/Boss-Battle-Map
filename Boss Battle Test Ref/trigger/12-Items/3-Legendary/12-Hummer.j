function Trig_Hummer_Conditions takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == 'I01U'
endfunction

function Trig_Hummer_Actions takes nothing returns nothing
	local integer cyclA = 2
	local integer array it

	set it[0] = 0
	set it[1] = 0
	loop
		exitwhen cyclA > 4
		set it[cyclA] = DB_Items[3][GetRandomInt( 1, udg_Database_NumberItems[3] )]
		if (it[cyclA] == it[cyclA-1] or it[cyclA] == it[cyclA-2]) and udg_Database_NumberItems[3] > 2 then
			set cyclA = cyclA - 1
		endif
		set cyclA = cyclA + 1
	endloop
	call forge( GetManipulatingUnit(), GetManipulatedItem(), it[4], it[2], it[3], true )
endfunction

//===========================================================================
function InitTrig_Hummer takes nothing returns nothing
    set gg_trg_Hummer = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Hummer, EVENT_PLAYER_UNIT_USE_ITEM )
    call TriggerAddCondition( gg_trg_Hummer, Condition( function Trig_Hummer_Conditions ) )
    call TriggerAddAction( gg_trg_Hummer, function Trig_Hummer_Actions )
endfunction

