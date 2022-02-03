function Trig_FutureBall_Conditions takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == 'I0FH'
endfunction

function Trig_FutureBall_Actions takes nothing returns nothing
	local integer cyclA = 2
	local integer array it
    local integer randl

	set it[0] = 0
	set it[1] = 0
	loop
		exitwhen cyclA > 4
		set randl = GetRandomInt(1, 100)
        if randl <= udg_RarityChance[3] then
            set it[cyclA] = DB_Items[3][GetRandomInt( 1, udg_Database_NumberItems[3] )]
            if (it[cyclA] == it[cyclA-1] or it[cyclA] == it[cyclA-2]) and udg_Database_NumberItems[3] > 2 then
                set cyclA = cyclA - 1
            endif
        elseif randl >= udg_RarityChance[3]+1 and randl <= udg_RarityChance[2] then
            set it[cyclA] = DB_Items[2][GetRandomInt( 1, udg_Database_NumberItems[2] )]
            if (it[cyclA] == it[cyclA-1] or it[cyclA] == it[cyclA-2]) and udg_Database_NumberItems[2] > 2 then
                set cyclA = cyclA - 1
            endif
        elseif randl >= udg_RarityChance[2]+1 then
            set it[cyclA] = DB_Items[1][GetRandomInt( 1, udg_Database_NumberItems[1] )]
            if (it[cyclA] == it[cyclA-1] or it[cyclA] == it[cyclA-2]) and udg_Database_NumberItems[1] > 2 then
                set cyclA = cyclA - 1
            endif
        endif
		set cyclA = cyclA + 1
	endloop
	call forge( GetManipulatingUnit(), GetManipulatedItem(), it[4], it[2], it[3], true )
endfunction

//===========================================================================
function InitTrig_FutureBall takes nothing returns nothing
    set gg_trg_FutureBall = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_FutureBall, EVENT_PLAYER_UNIT_USE_ITEM )
    call TriggerAddCondition( gg_trg_FutureBall, Condition( function Trig_FutureBall_Conditions ) )
    call TriggerAddAction( gg_trg_FutureBall, function Trig_FutureBall_Actions )
endfunction

