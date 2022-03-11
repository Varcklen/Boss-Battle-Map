function Trig_Ditto_Conditions takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == 'I05H'
endfunction

function Trig_Ditto_Actions takes nothing returns nothing
	local integer cyclA = 2
	local integer array it
    local integer rand

	set it[0] = 0
	set it[1] = 0
	loop
		exitwhen cyclA > 4
        set rand = GetRandomInt(1,3)
		set it[cyclA] = DB_Items[rand][GetRandomInt( 1, udg_Database_NumberItems[rand] )]
		if (it[cyclA] == it[cyclA-1] or it[cyclA] == it[cyclA-2]) and udg_Database_NumberItems[rand] > 2 then
			set cyclA = cyclA - 1
		endif
		set cyclA = cyclA + 1
	endloop
	call forge( GetManipulatingUnit(), GetManipulatedItem(), it[4], it[2], it[3], true )
endfunction

//===========================================================================
function InitTrig_Ditto takes nothing returns nothing
    set gg_trg_Ditto = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Ditto, EVENT_PLAYER_UNIT_USE_ITEM )
    call TriggerAddCondition( gg_trg_Ditto, Condition( function Trig_Ditto_Conditions ) )
    call TriggerAddAction( gg_trg_Ditto, function Trig_Ditto_Actions )
endfunction

