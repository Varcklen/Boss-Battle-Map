function Trig_Undercity_Conditions takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == 'I0CD'
endfunction

function Trig_Undercity_Actions takes nothing returns nothing
	local integer cyclA = 2
	local integer array it

	set it[0] = 0
	set it[1] = 0
	loop
		exitwhen cyclA > 4
		if cyclA == 4 then
			set it[cyclA] = DB_SetItems[3][GetRandomInt( 1, udg_DB_SetItems_Num[3] )]
		elseif cyclA == 2 then
			set it[cyclA] = DB_SetItems[8][GetRandomInt( 1, udg_DB_SetItems_Num[8] )]
		elseif cyclA == 3 then
			set it[cyclA] = DB_SetItems[4][GetRandomInt( 1, udg_DB_SetItems_Num[4] )]
		endif
		if (it[cyclA] == it[cyclA-1] or it[cyclA] == it[cyclA-2]) then
			set cyclA = cyclA - 1
		endif
		set cyclA = cyclA + 1
	endloop
	call forge( GetManipulatingUnit(), GetManipulatedItem(), it[4], it[2], it[3], true )
endfunction

//===========================================================================
function InitTrig_Undercity takes nothing returns nothing
    set gg_trg_Undercity = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Undercity, EVENT_PLAYER_UNIT_USE_ITEM )
    call TriggerAddCondition( gg_trg_Undercity, Condition( function Trig_Undercity_Conditions ) )
    call TriggerAddAction( gg_trg_Undercity, function Trig_Undercity_Actions )
endfunction

