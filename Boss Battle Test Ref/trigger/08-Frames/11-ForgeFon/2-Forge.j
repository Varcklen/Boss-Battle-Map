library Forge

function forge takes unit caster, item it, integer it1, integer it2, integer it3, boolean dest returns nothing
	local integer cyclA
	local item array forgetarget
	local string text
	local player p = GetOwningPlayer( caster )
	local integer i = GetPlayerId(p)
	local real k
	local integer array itd
	local integer id = GetHandleId(it) 
	local integer j = i*3

    set cyclA = 1
    loop
        exitwhen cyclA > 3
        set forgetarget[cyclA] = null
        set cyclA = cyclA + 1
    endloop

    if it1 != null or it2 != null or it3 != null then//
        call BlzFrameSetVisible(itemfon, false)
        call BlzFrameSetVisible(unitfon, false)
        
        set itd[j+1] = it1
        set itd[j+2] = it2
        set itd[j+3] = it3
        
        if udg_combatlogic[i+1] then
            call BlzFrameSetAbsPoint(forgebut, FRAMEPOINT_CENTER, 0.4, 0.15)
        else
            call BlzFrameSetAbsPoint(forgebut, FRAMEPOINT_CENTER, 0.4, 0.22)
        endif

        set cyclA = 1
        loop
            exitwhen cyclA > 3
            if LoadInteger( udg_hash, id, StringHash( "frg" + I2S(cyclA) ) ) == 0 then
                call SaveInteger( udg_hash, id, StringHash( "frg" + I2S(cyclA) ), itd[j+cyclA] )
            else
                set itd[j+cyclA] = LoadInteger( udg_hash, id, StringHash( "frg" + I2S(cyclA) ) )
            endif
            set forgetarget[cyclA] = CreateItem( itd[j+cyclA], GetUnitX(caster), GetUnitY(caster) )
            set cyclA = cyclA + 1
        endloop
        call SaveBoolean( udg_hash, id, StringHash( "frgdest" ), dest )
        /*
        if LoadInteger( udg_hash, id, StringHash( "frg2" ) ) == 0 then
            set itd[j+2] = it2
            call SaveInteger( udg_hash, id, StringHash( "frg2" ), itd[j+2] )
        else
            set itd[j+2] = LoadInteger( udg_hash, id, StringHash( "frg2" ) )
        endif

        if LoadInteger( udg_hash, id, StringHash( "frg3" ) ) == 0 then
            set itd[j+3] = it3
            call SaveInteger( udg_hash, id, StringHash( "frg3" ), itd[j+3] )
        else
            set itd[j+3] = LoadInteger( udg_hash, id, StringHash( "frg3" ) )
        endif
        set forgetarget[2] = CreateItem( itd[j+2], GetUnitX(caster), GetUnitY(caster) )
        set forgetarget[3] = CreateItem( itd[j+3], GetUnitX(caster), GetUnitY(caster) )
        */
        set udg_forgelose[i+1] = it

        if p == GetLocalPlayer() then
            call BlzFrameSetText(forgebut, "Hide")
            call BlzFrameSetVisible(forgebuts, false)
            call BlzFrameSetVisible(forgebut, true)
        endif

        set cyclA = 1
        loop
            exitwhen cyclA > 3
            if forgetarget[cyclA] != null then
                set udg_forgeitem[j+cyclA] = GetItemTypeId(forgetarget[cyclA])
                set text = BlzGetItemDescription(forgetarget[cyclA])
                set k = 0.0003*StringLength(text)
                if p == GetLocalPlayer() then
                    call BlzFrameSetVisible(bgfrgfon[cyclA], true)
                    call BlzFrameSetTexture( forgeicon[cyclA], BlzGetItemIconPath(forgetarget[cyclA]), 0, true )
                    call BlzFrameSetText( forgename[cyclA], GetItemName(forgetarget[cyclA]) )

                    call BlzFrameSetText( forgetool[cyclA], text )
                
                    call BlzFrameSetSize( forgetool[cyclA], 0.23, 0.02+k )
                    call BlzFrameSetSize( forgename[cyclA], 0.21, 0.09+k )
                    call BlzFrameSetSize(bgfrgfon[cyclA], 0.26, 0.08+k)

                    call BlzFrameSetVisible(bgfrgfon[cyclA], true)
                    
                    call BlzFrameSetVisible(bgfrgfons[cyclA], false)
                    call BlzFrameSetVisible(forgealticons[cyclA], false)
                endif
            endif
            call RemoveItem( forgetarget[cyclA] )
            set cyclA = cyclA + 1
        endloop
    endif
    
    set cyclA = 1
    loop
        exitwhen cyclA > 3
        set forgetarget[cyclA] = null
        set cyclA = cyclA + 1
    endloop

	set p = null
    set caster = null
    set it = null
endfunction

endlibrary