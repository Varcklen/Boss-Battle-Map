library ForgeSpecLib //requires ResourceLib

function RandomAbility takes unit u, integer h, integer boon1, integer boon2 returns integer
    local integer cyclA
    local integer cyclAEnd
    local integer i = GetPlayerId(GetOwningPlayer( u )) + 1
    local integer rand = 0
    local integer done = 0
    local integer n = 0
    local integer array v
    
    set cyclA = 1
    set cyclAEnd = udg_Database_NumberItems[37]
    loop
        exitwhen cyclA > cyclAEnd
        if (udg_DB_Ability_Special[cyclA] != boon1 and udg_DB_Ability_Special[cyclA] != boon2) or cyclAEnd < 3 then
            set n = n + 1
            set v[n] = cyclA
            //call DisplayTimedTextToForce( GetPlayersAll(), 5.00, "n: " + I2S(n) )
            //call DisplayTimedTextToForce( GetPlayersAll(), 5.00, "vn: " + I2S(v[n]) )
        endif
        set cyclA = cyclA + 1
    endloop
    
    set rand = v[GetRandomInt(1, n)]
    set done = udg_DB_Ability_Special[rand]
    
    //call DisplayTimedTextToForce( GetPlayersAll(), 5.00, "Done: " + BlzGetAbilityTooltip(done, 0) )
    //call DisplayTimedTextToForce( GetPlayersAll(), 5.00, "a: " + I2S(a) )
    set u = null
    return done
endfunction

function forgespell takes unit caster, item it returns nothing
	local integer cyclA
	local string text
	local player p = GetOwningPlayer( caster )
	local integer i = GetPlayerId(p)
	local real k
	local integer id = GetHandleId(it) 
    local integer array boon

    if not(udg_combatlogic[i+1]) then
        if LoadInteger( udg_hash, id, StringHash( "frg1" ) ) == 0 then
            set boon[1] = RandomAbility(caster, 1, 1, 1)
            call SaveInteger( udg_hash, id, StringHash( "frg1" ), boon[1] )
        else
            set boon[1] = LoadInteger( udg_hash, id, StringHash( "frg1" ) )
        endif

        if LoadInteger( udg_hash, id, StringHash( "frg2" ) ) == 0 then
            set boon[2] = RandomAbility(caster, 2, boon[1], 1)
            call SaveInteger( udg_hash, id, StringHash( "frg2" ), boon[2] )
        else
            set boon[2] = LoadInteger( udg_hash, id, StringHash( "frg2" ) )
        endif

        if LoadInteger( udg_hash, id, StringHash( "frg3" ) ) == 0 then
            set boon[3] = RandomAbility(caster, 3, boon[1], boon[2])
            call SaveInteger( udg_hash, id, StringHash( "frg3" ), boon[3] )
        else
            set boon[3] = LoadInteger( udg_hash, id, StringHash( "frg3" ) )
        endif

        set udg_forgelose[i+1] = it

        if p == GetLocalPlayer() then
            call BlzFrameSetVisible(forgebut, false)
            call BlzFrameSetText(forgebuts, "Hide")
            call BlzFrameSetVisible(forgebuts, true)

            call BlzFrameSetVisible(bgfrgfons[1], true)
            call BlzFrameSetVisible(bgfrgfons[2], true)
            call BlzFrameSetVisible(bgfrgfons[3], true)
        endif

        set cyclA = 1
        loop
            exitwhen cyclA > 3
                //set text = BlzGetAbilityExtendedTooltip(boon[cyclA], 0)
                
                set text = BlzGetAbilityExtendedTooltip( boon[cyclA], 0 )

                //call DisplayTimedTextToForce( GetPlayersAll(), 5.00, text )
                
                set k = 0.0003*StringLength(text)
                if p == GetLocalPlayer() then	
                    call BlzFrameSetTexture( forgeicons[cyclA], BlzGetAbilityIcon( boon[cyclA] ), 0, true )
                    call BlzFrameSetText( forgenames[cyclA], BlzGetAbilityTooltip(boon[cyclA], 0) )
                    
                    call BlzFrameSetSize( forgetools[cyclA], 0.23, 0.02+k )
                    call BlzFrameSetSize( forgenames[cyclA], 0.21, 0.09+k )
                    call BlzFrameSetSize( bgfrgfons[cyclA], 0.26, 0.09+k)
                    call BlzFrameSetText( forgetools[cyclA], text )

                    call BlzFrameSetVisible(bgfrgfons[cyclA], true)
                    call BlzFrameSetVisible(forgealticons[cyclA], false)
                    
                    call BlzFrameSetVisible(bgfrgfon[cyclA], false)
                endif
            set cyclA = cyclA + 1
        endloop
    endif

    set caster = null
    set it = null
	set p = null
endfunction

endlibrary