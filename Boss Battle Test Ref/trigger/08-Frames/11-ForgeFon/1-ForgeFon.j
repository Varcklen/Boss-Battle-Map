library ForgeFon requires CorruptedLib, ForgeOtherLib

globals
	framehandle array bgfrgfon
	framehandle array forgeicon
	framehandle array forgename
	framehandle array forgetool
	framehandle array forgebutchs
	framehandle forgebut
	framehandle frgvis
    
    real Event_AfterForge_Real
    item Event_AfterForge_NewItem
    integer Event_AfterForge_ForgedItem
    item Event_AfterForge_ForgedItem_Item
    unit Event_AfterForge_Hero
    
    real Event_BeforeForge_Real
    integer Event_BeforeForge_NewItem
    item Event_BeforeForge_ForgedItem
    unit Event_BeforeForge_Hero
endglobals

function ButtonF takes nothing returns nothing
    local integer i = 3*(GetUnitUserData(udg_hero[GetPlayerId( GetTriggerPlayer() ) + 1])-1)
	if GetTriggerPlayer() == GetLocalPlayer() then
        if BlzFrameGetText(forgebut) == "Show" then
            call BlzFrameSetText(forgebut, "Hide")
            if udg_forgeitem[i+1] != null then
                call BlzFrameSetVisible(bgfrgfon[1], true)
            endif
            if udg_forgeitem[i+2] != null then
                call BlzFrameSetVisible(bgfrgfon[2], true)
            endif
            if udg_forgeitem[i+3] != null then
                call BlzFrameSetVisible(bgfrgfon[3], true)
            endif
        else
            call BlzFrameSetText(forgebut, "Show")
            call BlzFrameSetVisible(bgfrgfon[1], false)
            call BlzFrameSetVisible(bgfrgfon[2], false)
            call BlzFrameSetVisible(bgfrgfon[3], false)
        endif
	endif
endfunction

function ForgeAfter takes unit caster, item forgedItem, integer m returns nothing
	local integer k
	local integer id = GetHandleId(forgedItem)
    
	if m == 'I0C7' and inv( caster, m ) > 0 then
		set k = LoadInteger( udg_hash, id, StringHash( "frtdk" ) ) + 1
		call SaveInteger( udg_hash, id, StringHash( "frtdk" ), k )
		call FortuneDeck( caster, forgedItem )
	endif
	if m == 'I03F' and inv( caster, m ) > 0 then
		set k = LoadInteger( udg_hash, id, StringHash( "snddk" ) ) + 1
		call SaveInteger( udg_hash, id, StringHash( "snddk" ), k )
		call Sandro( caster, forgedItem )
	endif
    if m == 'I0EN' and inv( caster, m ) > 0 then
		set k = LoadInteger( udg_hash, id, StringHash( "mmco" ) ) + 1
		call SaveInteger( udg_hash, id, StringHash( "mmco" ), k )
		call MimicOrb( caster, forgedItem )
	endif
	if m == 'I0CA' then
		call BlzSetItemIntegerFieldBJ( bj_lastCreatedItem, ITEM_IF_NUMBER_OF_CHARGES, 3 )
        call UnitRemoveItem(caster, bj_lastCreatedItem)
        call UnitAddItem(caster, bj_lastCreatedItem)
	endif
    if m == 'I05H' then
        call BlzSetItemIconPath( bj_lastCreatedItem, "|cFFB20080Ditto|r|n" + BlzGetItemExtendedTooltip(bj_lastCreatedItem) )
    endif
    
    set Event_AfterForge_NewItem = bj_lastCreatedItem
    set Event_AfterForge_ForgedItem = m
    set Event_AfterForge_Hero = caster
    set Event_AfterForge_ForgedItem_Item = forgedItem
    
    set Event_AfterForge_Real = 0.00
    set Event_AfterForge_Real = 1.00
    set Event_AfterForge_Real = 0.00
    
    set caster = null
endfunction

function NoRemoveItem takes integer i returns boolean
    if i == 'I0FH' then
        return false
    endif
    if i == 'I086' then
        return false
    endif
    return true
endfunction

function TakeItem takes unit caster, integer itm, item m returns nothing
    local integer i = GetPlayerId(GetOwningPlayer(caster)) + 1
    
    if m != null then
        if GetItemTypeId(m) == 'I0FH' then
            set udg_FutureBall[i] = itm
            set bj_lastCreatedItem = CreateItem( itm, 0, 0 )
            call BlzSetItemIconPath( m, words( caster, BlzGetItemDescription(m), "Future: ", ")|r", GetItemName(bj_lastCreatedItem) ) )
            call RemoveItem(bj_lastCreatedItem)
        elseif UnitInventoryCount(caster) < 6 then
            call UnitAddItem(caster, CreateItem( itm, GetUnitX(caster), GetUnitY(caster) ))
        endif
    elseif UnitInventoryCount(caster) < 6 then
        //bj_lastCreatedItem обязательно!
        set bj_lastCreatedItem = CreateItem( itm, GetUnitX(caster), GetUnitY(caster) )
        call UnitAddItem(caster, bj_lastCreatedItem)
    endif
    set caster = null
    set m = null
endfunction

function ButtonUse takes player p, integer b returns nothing
    local integer k = GetPlayerId(p)
	local integer i = k + 1
	local integer j = k*3
	local integer m = GetItemTypeId(udg_forgelose[i]) 
    local integer id = GetHandleId(udg_forgelose[i])
    local integer cyclA
    
	if UnitHasItem(udg_hero[i], udg_forgelose[i]) then
        set cyclA = 1
        loop
            exitwhen cyclA > 3
            set LastForgeItems[i][cyclA] = udg_forgeitem[j+cyclA]
            call SaveInteger( udg_hash, id, StringHash( "frg" + I2S(cyclA) ), 0 )
            set cyclA = cyclA + 1
        endloop
        call DestroyEffect( AddSpecialEffect( "Objects\\Spawnmodels\\NightElf\\NECancelDeath\\NECancelDeath.mdl", GetUnitX( udg_hero[i] ), GetUnitY( udg_hero[i] ) ) )
        
        set Event_BeforeForge_ForgedItem = udg_forgelose[i]
        set Event_BeforeForge_Hero = udg_hero[i]
        set Event_BeforeForge_NewItem = udg_forgeitem[j+b]
        set Event_BeforeForge_Real = 0.00
        set Event_BeforeForge_Real = 1.00
        set Event_BeforeForge_Real = 0.00
        
		if LoadBoolean( udg_hash, GetHandleId(udg_forgelose[i]), StringHash( "frgdest" ) ) and NoRemoveItem(GetItemTypeId(udg_forgelose[i])) then
			call stazisst( udg_hero[i], udg_forgelose[i] )
			set udg_forgelose[i] = null
		endif
		call TakeItem(udg_hero[i], udg_forgeitem[j+b], udg_forgelose[i] )
	endif
	if p == GetLocalPlayer() then
		call BlzFrameSetVisible(bgfrgfon[1], false)
		call BlzFrameSetVisible(bgfrgfon[2], false)
		call BlzFrameSetVisible(bgfrgfon[3], false)
		call BlzFrameSetVisible(forgebut, false)
	endif
	
	call ForgeAfter( udg_hero[i], udg_forgelose[i], m )

    set p = null
endfunction

function Button1 takes nothing returns nothing
	call ButtonUse(GetTriggerPlayer(), 1)
endfunction

function Button2 takes nothing returns nothing
	call ButtonUse(GetTriggerPlayer(), 2)
endfunction

function Button3 takes nothing returns nothing
	call ButtonUse(GetTriggerPlayer(), 3)
endfunction

endlibrary