function Trig_Fast_Start_Choose_Actions takes nothing returns nothing
	local integer cyclA
	local integer cyclB
	local integer cyclBEnd
	local integer cyclC = 1
	local integer cyclD
	local integer array i
	local integer array h
	local integer j
	local integer g
	local integer l
    local string text
    local integer k

    call BlzFrameSetVisible( fastbut,true)
    call BlzFrameSetVisible( fastvis,true)

    set cyclA = 1
    loop
        exitwhen cyclC > 4
        if GetPlayerSlotState(Player( cyclC - 1 )) == PLAYER_SLOT_STATE_PLAYING then
            set j = (cyclC-1)*3
            set cyclA = 2
            set i[j+1] = GetRandomInt(1, udg_DB_FS_Size)
            loop
                exitwhen cyclA > 12
                set i[j+cyclA] = GetRandomInt(1, udg_DB_FS_Size)
                set cyclB = j+1
                set cyclBEnd = j+cyclA - 1
                loop
                    exitwhen cyclB > cyclBEnd
                    if i[j+cyclA] == i[cyclB] then
                        set cyclA = cyclA - 1
                        set cyclB = cyclBEnd
                    endif
                    set cyclB = cyclB + 1
                endloop
                set cyclA = cyclA + 1
            endloop
            set cyclD = 1
            loop
                exitwhen cyclD > 3
                set udg_DB_FS_SetType[(cyclC*3)+(cyclD-3)] = i[(cyclC*3)+(cyclD-3)]
                set l = udg_DB_FS_SetType[(cyclC*3)+(cyclD-3)]

                if GetLocalPlayer() == Player(cyclC-1) then
                    call BlzFrameSetText( fasttool[cyclD], udg_DB_FS_Name[l] )
                endif

                set cyclA = 2
                set g = ((cyclC-1)*18)+((cyclD-1)*6)
                set h[g+1] = GetRandomInt(udg_DB_FS_Start[l], udg_DB_FS_End[l])
                loop
                    exitwhen cyclA > 6
                    set h[g+cyclA] = GetRandomInt(udg_DB_FS_Start[l], udg_DB_FS_End[l])
                    set cyclB = g+1
                    set cyclBEnd = g+cyclA - 1
                    loop
                        exitwhen cyclB > cyclBEnd
                        if h[g+cyclA] == h[cyclB] then
                            set cyclA = cyclA - 1
                            set cyclB = cyclBEnd
                        endif
                        set cyclB = cyclB + 1
                    endloop
                    set cyclA = cyclA + 1
                endloop
            set cyclD = cyclD + 1
            endloop
            set cyclA = 1
            set j = (cyclC-1)*18
            loop
                exitwhen cyclA > 18
                set udg_DB_FS_SetItem[j+cyclA] = h[j+cyclA]
                call CreateItemLoc( udg_DB_FS_Item[udg_DB_FS_SetItem[j+cyclA]], GetRectCenter(gg_rct_HeroesTp) )
                set text = BlzGetItemDescription(bj_lastCreatedItem)
                set k = StringLength(text)
                if GetLocalPlayer() == Player(cyclC-1) then
                    call BlzFrameSetTexture( fasticon[cyclA], BlzGetItemIconPath(bj_lastCreatedItem), 0, true )
                    
                    call BlzFrameSetSize( fastback[j+cyclA], 0.35, 0.04+(0.0004*k) )
                    call BlzFrameSetText( fastdisc[j+cyclA], text )
                    call BlzFrameSetText( fastname[j+cyclA], GetItemName(bj_lastCreatedItem) )
                endif
                call RemoveItem( bj_lastCreatedItem )
                set cyclA = cyclA + 1
            endloop
        endif
        set cyclC = cyclC + 1
    endloop
endfunction

//===========================================================================
function InitTrig_Fast_Start_Choose takes nothing returns nothing
    set gg_trg_Fast_Start_Choose = CreateTrigger(  )
    call TriggerAddAction( gg_trg_Fast_Start_Choose, function Trig_Fast_Start_Choose_Actions )
endfunction

