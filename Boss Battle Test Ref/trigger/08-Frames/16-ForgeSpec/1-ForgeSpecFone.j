library ForgeSpecFone requires SpecialLib //ResourceLib, ChangeDiscriptionLib, 

globals
	framehandle array bgfrgfons
	framehandle array forgeicons
	framehandle array forgenames
	framehandle array forgetools
	framehandle array forgebutschss
    framehandle array forgealticons
	framehandle array forgealtnames
	framehandle forgebuts
	framehandle frgviss
endglobals

function ButtonFSpell takes nothing returns nothing
	if GetTriggerPlayer() == GetLocalPlayer() then
        if not(BlzFrameIsVisible(bgfrgfons[1])) then
            call BlzFrameSetText(forgebuts, "Hide")
            call BlzFrameSetVisible(bgfrgfons[1], true)
            call BlzFrameSetVisible(bgfrgfons[2], true)
            call BlzFrameSetVisible(bgfrgfons[3], true)
        else
            call BlzFrameSetText(forgebuts, "Show")
            call BlzFrameSetVisible(bgfrgfons[1], false)
            call BlzFrameSetVisible(bgfrgfons[2], false)
            call BlzFrameSetVisible(bgfrgfons[3], false)
        endif
	endif
endfunction

function ChangeAbility takes unit u, integer ab returns nothing
    local player p = GetOwningPlayer(u)
    local integer i = GetPlayerId(p)+1
    local integer cyclA
    
    call NewSpecial( u, ab )
    
    set p = null
    set u = null
endfunction

function Button1S takes nothing returns nothing
	local integer k = GetPlayerId(GetTriggerPlayer())
	local integer i = k + 1
	local integer j = k*3
	local integer m = GetItemTypeId(udg_forgelose[i])
	local integer id = GetHandleId(udg_forgelose[i])
    local integer ab = LoadInteger( udg_hash, id, StringHash( "frg1" ) )

    if GetUnitState( udg_hero[i], UNIT_STATE_LIFE ) > 0.405 then 
        if UnitHasItem(udg_hero[i], udg_forgelose[i]) then
            call DestroyEffect( AddSpecialEffect( "Objects\\Spawnmodels\\NightElf\\NECancelDeath\\NECancelDeath.mdl", GetUnitX( udg_hero[i] ), GetUnitY( udg_hero[i] ) ) )
            if udg_forgelose[i] != null then
                call RemoveItem( udg_forgelose[i] )
                set udg_forgelose[i] = null
            endif
            call ChangeAbility(udg_hero[i], ab)
        endif
        if GetTriggerPlayer() == GetLocalPlayer() then
            call BlzFrameSetVisible(bgfrgfons[1], false)
            call BlzFrameSetVisible(bgfrgfons[2], false)
            call BlzFrameSetVisible(bgfrgfons[3], false)
            call BlzFrameSetVisible(forgebuts, false)
        endif
        
        call SaveInteger( udg_hash, id, StringHash( "frg1" ), 0 )
        call SaveInteger( udg_hash, id, StringHash( "frg2" ), 0 )
        call SaveInteger( udg_hash, id, StringHash( "frg3" ), 0 )
    endif
endfunction

function Button2S takes nothing returns nothing
	local integer k = GetPlayerId(GetTriggerPlayer())
	local integer i = k + 1
	local integer j = k*3
	local integer m = GetItemTypeId(udg_forgelose[i])
    local integer id = GetHandleId(udg_forgelose[i])
    local integer ab = LoadInteger( udg_hash, id, StringHash( "frg2" ) )
	
    if GetUnitState( udg_hero[i], UNIT_STATE_LIFE ) > 0.405 then 
        if UnitHasItem(udg_hero[i], udg_forgelose[i]) then
            call DestroyEffect( AddSpecialEffect( "Objects\\Spawnmodels\\NightElf\\NECancelDeath\\NECancelDeath.mdl", GetUnitX( udg_hero[i] ), GetUnitY( udg_hero[i] ) ) )
            if udg_forgelose[i] != null then
                call RemoveItem( udg_forgelose[i] )
                set udg_forgelose[i] = null
            endif
            call ChangeAbility(udg_hero[i], ab)
        endif
        if GetTriggerPlayer() == GetLocalPlayer() then
            call BlzFrameSetVisible(bgfrgfons[1], false)
            call BlzFrameSetVisible(bgfrgfons[2], false)
            call BlzFrameSetVisible(bgfrgfons[3], false)
            call BlzFrameSetVisible(forgebuts, false)
        endif
        
        call SaveInteger( udg_hash, id, StringHash( "frg1" ), 0 )
        call SaveInteger( udg_hash, id, StringHash( "frg2" ), 0 )
        call SaveInteger( udg_hash, id, StringHash( "frg3" ), 0 )
    endif
endfunction

function Button3S takes nothing returns nothing
	local integer k = GetPlayerId(GetTriggerPlayer())
	local integer i = k + 1
	local integer j = k*3
	local integer m = GetItemTypeId(udg_forgelose[i])
    local integer id = GetHandleId(udg_forgelose[i])
    local integer ab = LoadInteger( udg_hash, id, StringHash( "frg3" ) )
	
    if GetUnitState( udg_hero[i], UNIT_STATE_LIFE ) > 0.405 then 
        if UnitHasItem(udg_hero[i], udg_forgelose[i]) then
            call DestroyEffect( AddSpecialEffect( "Objects\\Spawnmodels\\NightElf\\NECancelDeath\\NECancelDeath.mdl", GetUnitX( udg_hero[i] ), GetUnitY( udg_hero[i] ) ) )
            if udg_forgelose[i] != null then
                call RemoveItem( udg_forgelose[i] )
                set udg_forgelose[i] = null
            endif
            call ChangeAbility(udg_hero[i], ab)
        endif
        if GetTriggerPlayer() == GetLocalPlayer() then
            call BlzFrameSetVisible(bgfrgfons[1], false)
            call BlzFrameSetVisible(bgfrgfons[2], false)
            call BlzFrameSetVisible(bgfrgfons[3], false)
            call BlzFrameSetVisible(forgebuts, false)
        endif
        
        call SaveInteger( udg_hash, id, StringHash( "frg1" ), 0 )
        call SaveInteger( udg_hash, id, StringHash( "frg2" ), 0 )
        call SaveInteger( udg_hash, id, StringHash( "frg3" ), 0 )
    endif
endfunction

endlibrary