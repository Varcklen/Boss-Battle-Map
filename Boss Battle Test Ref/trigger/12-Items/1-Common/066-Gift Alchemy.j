function Trig_Gift_Alchemy_Conditions takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == 'I05N'
endfunction

function Trig_Gift_Alchemy_Actions takes nothing returns nothing
    local integer cyclA = 2
	local integer array it

	set it[0] = 0
	set it[1] = 0
	loop
		exitwhen cyclA > 4
        set it[cyclA] = DB_SetItems[8][GetRandomInt( 1, udg_DB_SetItems_Num[8] )]
		if (it[cyclA] == it[cyclA-1] or it[cyclA] == it[cyclA-2]) then
			set cyclA = cyclA - 1
		endif
		set cyclA = cyclA + 1
	endloop
	call forge( GetManipulatingUnit(), GetManipulatedItem(), it[4], it[2], it[3], true )
endfunction

//===========================================================================
function InitTrig_Gift_Alchemy takes nothing returns nothing
    set gg_trg_Gift_Alchemy = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Gift_Alchemy, EVENT_PLAYER_UNIT_USE_ITEM )
    call TriggerAddCondition( gg_trg_Gift_Alchemy, Condition( function Trig_Gift_Alchemy_Conditions ) )
    call TriggerAddAction( gg_trg_Gift_Alchemy, function Trig_Gift_Alchemy_Actions )
endfunction

