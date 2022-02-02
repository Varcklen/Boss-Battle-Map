function Trig_Iromforge_Conditions takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == 'I0CC'
endfunction

function Trig_Iromforge_Actions takes nothing returns nothing
	local integer cyclA = 2
	local integer array it

	set it[0] = 0
	set it[1] = 0
	loop
		exitwhen cyclA > 4
		if cyclA == 4 then
			set it[cyclA] = DB_SetItems[2][GetRandomInt( 1, udg_DB_SetItems_Num[2] )]
		elseif cyclA == 2 then
			set it[cyclA] = DB_SetItems[1][GetRandomInt( 1, udg_DB_SetItems_Num[1] )]
		elseif cyclA == 3 then
			set it[cyclA] = DB_SetItems[5][GetRandomInt( 1, udg_DB_SetItems_Num[5] )]
		endif
		if (it[cyclA] == it[cyclA-1] or it[cyclA] == it[cyclA-2]) then
			set cyclA = cyclA - 1
		endif
		set cyclA = cyclA + 1
	endloop
	call forge( GetManipulatingUnit(), GetManipulatedItem(), it[4], it[2], it[3], true )
endfunction

//===========================================================================
function InitTrig_Iromforge takes nothing returns nothing
    set gg_trg_Iromforge = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Iromforge, EVENT_PLAYER_UNIT_USE_ITEM )
    call TriggerAddCondition( gg_trg_Iromforge, Condition( function Trig_Iromforge_Conditions ) )
    call TriggerAddAction( gg_trg_Iromforge, function Trig_Iromforge_Actions )
endfunction

