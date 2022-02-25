function Trig_Moonglade_Conditions takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == 'I0C8'
endfunction

function Trig_Moonglade_Actions takes nothing returns nothing
	local integer cyclA = 2
	local integer array it

	set it[0] = 0
	set it[1] = 0
	loop
		exitwhen cyclA > 4
		if cyclA == 4 then
			set it[cyclA] = DB_SetItems[6][GetRandomInt( 1, udg_DB_SetItems_Num[6] )]
		elseif cyclA == 2 then
			set it[cyclA] = DB_SetItems[7][GetRandomInt( 1, udg_DB_SetItems_Num[7] )]
		elseif cyclA == 3 then
			set it[cyclA] = DB_SetItems[9][GetRandomInt( 1, udg_DB_SetItems_Num[9] )]
		endif
		if (it[cyclA] == it[cyclA-1] or it[cyclA] == it[cyclA-2]) then
			set cyclA = cyclA - 1
		endif
		set cyclA = cyclA + 1
	endloop
	call forge( GetManipulatingUnit(), GetManipulatedItem(), it[4], it[2], it[3], true )
endfunction

//===========================================================================
function InitTrig_Moonglade takes nothing returns nothing
    set gg_trg_Moonglade = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Moonglade, EVENT_PLAYER_UNIT_USE_ITEM )
    call TriggerAddCondition( gg_trg_Moonglade, Condition( function Trig_Moonglade_Conditions ) )
    call TriggerAddAction( gg_trg_Moonglade, function Trig_Moonglade_Actions )
endfunction

