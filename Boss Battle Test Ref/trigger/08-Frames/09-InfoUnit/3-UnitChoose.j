function Trig_UnitChoose_Conditions takes nothing returns boolean
    return not(udg_fightmod[0]) and udg_Boss_LvL < 5// and not(BlzFrameIsVisible(bgfrgfon[1]))
endfunction

function Trig_UnitChoose_Actions takes nothing returns nothing
	local string text = null
	local integer k
	local integer cyclA = 1
	local integer cyclAEnd = udg_DB_Seller_Number
	local unit u = GetTriggerUnit()
	local player pl = GetTriggerPlayer()
	local string path = null
	local integer i = GetPlayerId( pl ) + 1 

	loop
		exitwhen cyclA > cyclAEnd
		if GetUnitTypeId(u) == udg_DB_Seller[cyclA] then
            set text = udg_DB_Seller_Text[cyclA]
			set path = udg_DB_Seller_Icon[cyclA]
			set cyclA = cyclAEnd
		endif
		set cyclA = cyclA + 1
	endloop

	if text == null then
		if GetLocalPlayer() == GetTriggerPlayer() then
			call BlzFrameSetVisible(unitfon, false)
		endif
	elseif udg_LvL[GetPlayerId(GetTriggerPlayer()) + 1] <= 8 then
		set k = StringLength(text)
		if GetLocalPlayer() == pl then
			call BlzFrameSetAbsPoint(unitfon, FRAMEPOINT_TOP, 0.125, 0.55-bnspos)
			call BlzFrameSetVisible(itemfon, false)
			call BlzFrameSetVisible(unitfon, true)
			call BlzFrameSetTexture( uniticon, path, 0, true )
			call BlzFrameSetText( unitname, GetUnitName(u) )
			call BlzFrameSetText( unittool, text )

			call BlzFrameSetSize(unitfon, 0.25, 0.08+(0.0002*k))
			call BlzFrameSetSize(unittool, 0.23, 0.02+(0.0002*k))
		endif
	endif
	set u = null
	set pl = null
endfunction

//===========================================================================
function InitTrig_UnitChoose takes nothing returns nothing
    local integer i = 0
    set gg_trg_UnitChoose = CreateTrigger()
    loop
        exitwhen i > 3
        call TriggerRegisterPlayerSelectionEventBJ( gg_trg_UnitChoose, Player(i), true )
        set i = i + 1
    endloop
    call TriggerAddCondition( gg_trg_UnitChoose, Condition( function Trig_UnitChoose_Conditions ) )
    call TriggerAddAction( gg_trg_UnitChoose, function Trig_UnitChoose_Actions )
endfunction

