library ForgeOtherLib

function FortuneDeck takes unit caster, item itm returns nothing
	local integer cyclA = 2
	local integer array it
	local integer k = LoadInteger( udg_hash, GetHandleId(itm), StringHash( "frtdk" ) )
	local boolean l

    //Нельзя иметь [-1] в локали
	set it[0] = 0
	set it[1] = 0
	loop
		exitwhen cyclA > 4
		set it[cyclA] = udg_DB_Tarot[GetRandomInt( 1, udg_Database_NumberItems[4] )]
		if (it[cyclA] == it[cyclA-1] or it[cyclA] == it[cyclA-2]) then
			set cyclA = cyclA - 1
		endif
		set cyclA = cyclA + 1
	endloop

    call BlzSetItemIconPath( itm, words( caster, BlzGetItemDescription(itm), "|cFF959697(", ")|r", I2S(2-k) + "/2" ) )
	if k < 1 then
		set l = false
	else
		set l = true
	endif

	call forge( caster, itm, it[2], it[3], it[4], l )
    
    set caster = null
    set itm = null
endfunction

function MimicOrb takes unit caster, item itm returns nothing
	local integer cyclA = 2
	local integer array it
	local integer k = LoadInteger( udg_hash, GetHandleId(itm), StringHash( "mmco" ) )
	local boolean l

    //Нельзя иметь [-1] в локали
	set it[0] = 0
	set it[1] = 0
	loop
		exitwhen cyclA > 4
		set it[cyclA] = udg_DB_Orb[GetRandomInt( 1, udg_Database_NumberItems[8] )]
		if (it[cyclA] == it[cyclA-1] or it[cyclA] == it[cyclA-2]) then
			set cyclA = cyclA - 1
		endif
		set cyclA = cyclA + 1
	endloop

    call BlzSetItemIconPath( itm, words( caster, BlzGetItemDescription(itm), "|cFF959697(", ")|r", I2S(2-k) + "/2" ) )
	if k < 1 then
		set l = false
	else
		set l = true
	endif

	call forge( caster, itm, it[2], it[3], it[4], l )
    
    set caster = null
    set itm = null
endfunction

function Sandro takes unit caster, item itm returns nothing
	local integer cyclA = 2
	local integer array it
	local integer k = LoadInteger( udg_hash, GetHandleId(itm), StringHash( "snddk" ) )
	local boolean l

    //Нельзя иметь [-1] в локали
	set it[0] = 0
	set it[1] = 0
	loop
		exitwhen cyclA > 4
		set it[cyclA] = DB_Items[2][GetRandomInt( 1, udg_Database_NumberItems[2] )]
		if (it[cyclA] == it[cyclA-1] or it[cyclA] == it[cyclA-2]) and udg_Database_NumberItems[2] > 2 then
			set cyclA = cyclA - 1
		endif
		set cyclA = cyclA + 1
	endloop

    call BlzSetItemIconPath( itm, words( caster, BlzGetItemDescription(itm), "|cFF959697(", ")|r", I2S(6-k) + "/6" ) )
	if k < 5 then
		set l = false
	else
		set l = true
	endif

	call forge( caster, itm, it[2], it[3], it[4], l )
    
    set caster = null
    set itm = null
endfunction

endlibrary