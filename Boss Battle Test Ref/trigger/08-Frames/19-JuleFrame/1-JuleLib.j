library JuleLib requires ItemRandomizerLib

    globals
        constant integer ROW_LIMIT = 4
        constant integer ROW_LIMIT_ARRAYS = ROW_LIMIT + 1
        constant integer COLUMN_LIMIT = 4
        constant integer COLUMN_LIMIT_ARRAYS = COLUMN_LIMIT + 1
        
        private constant integer ITEMS_COUNT = ROW_LIMIT*COLUMN_LIMIT
        private constant integer ITEMS_COUNT_ARRAYS = ITEMS_COUNT + 1
        
        public string array Item_Name[ITEMS_COUNT_ARRAYS]
        public string array Item_Description[ITEMS_COUNT_ARRAYS]
    endglobals

    function JuleCast takes nothing returns nothing
        local integer cyclA = 1
        local integer cyclB = 1

        call BlzFrameSetVisible( julerefr, true )
        set cyclA = 1
        loop
            exitwhen cyclA > 4
            set cyclB = 1
            loop
                exitwhen cyclB > 4
                if cyclB < 3 or (cyclB >= 3 and julebool[cyclA][IMaxBJ(1,cyclB-2)]) then
                    call BlzFrameSetVisible( juleicon[cyclA][cyclB], true )
                endif
                set cyclB = cyclB + 1
            endloop
            set cyclA = cyclA + 1
        endloop 

        call FlushChildHashtable( udg_hash, GetHandleId( GetExpiredTimer() ) )
    endfunction

    function JulePause takes nothing returns nothing
        local integer cyclA = 1
        local integer cyclB = 1
        
        call BlzFrameSetVisible( julerefr, false )
        set cyclA = 1
        loop
            exitwhen cyclA > 4
            set cyclB = 1
            loop
                exitwhen cyclB > 4
                if cyclB < 3 or (cyclB >= 3 and julebool[cyclA][IMaxBJ(1,cyclB-2)]) then
                    call BlzFrameSetVisible( juleicon[cyclA][cyclB], false )
                endif
                set cyclB = cyclB + 1
            endloop
            set cyclA = cyclA + 1
        endloop 
        
        if LoadTimerHandle( udg_hash, 1, StringHash( "jule" ) ) == null  then
            call SaveTimerHandle( udg_hash, 1, StringHash( "jule" ), CreateTimer() )
        endif
        call TimerStart( LoadTimerHandle( udg_hash, 1, StringHash( "jule" ) ), 0.25, false, function JuleCast )
    endfunction

    function PreCount takes nothing returns real
        local integer cyclA = 1
        local real count = 1
        
        loop
            exitwhen cyclA > 4
            if inv( udg_hero[cyclA], 'I01C' ) > 0 then
                set count = count - 0.2
            endif
            set cyclA = cyclA + 1
        endloop
        
        set count = 1 - RMaxBJ(0,count)
        return count
    endfunction

    function PreCount_Condition takes nothing returns boolean
        local integer cyclA = 1
        local boolean l = false
        
        loop
            exitwhen cyclA > 4
            if inv( udg_hero[cyclA], 'I01C' ) > 0 then
                set l = true
                set cyclA = 4
            endif
            set cyclA = cyclA + 1
        endloop
        
        return l
    endfunction

    function ChangeCost takes integer j, real count, integer number, boolean cond returns integer
        local integer cost = j
        
        set cost = cost - R2I(count*j)
        
        if GetRandomInt(1,100) == 1 then
            set cost = cost - R2I(0.6*j)
        elseif GetRandomInt(1,100) <= 4 or (number == 1 and cond) then
            set cost = cost - R2I(0.3*j)
        endif
        if udg_modbad[9] then
            set cost = cost + R2I(0.1*j)
        endif
        
        if cost < 0.2*j then
            set cost = R2I(0.2*j)
        endif
        return cost
    endfunction

    function JuleRef takes nothing returns nothing
        local integer cyclA
        local integer cyclAEnd
        local integer cyclB
        local integer cyclBEnd
        local integer cyclC
        local integer h = 8+IMinBJ(4,julenum)
        local integer array rarity
        local integer rand
        local integer array i
        local boolean l
        local integer j
        local integer m
        local integer f
        local integer legrarity = R2I(udg_RarityChance[3]/2)
        local string str
        
        local real preCount
        local boolean preCountBool
        
        call JulePause()
        call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\Polymorph\\PolyMorphDoneGround.mdl", GetUnitX( gg_unit_h01G_0201 ), GetUnitY( gg_unit_h01G_0201 ) ) )
        
        set cyclA = 1
        loop
            exitwhen cyclA > 16
            set udg_JuleItem[cyclA] = 0
            set cyclA = cyclA + 1
        endloop
        
        set cyclA = 1
        loop
            exitwhen cyclA > h
            set rarity[cyclA] = 0
            set rand = GetRandomInt(1, 100)
            if rand <= legrarity then
                set rarity[cyclA] = 3
            elseif rand > legrarity and rand <= udg_RarityChance[2] then
                set rarity[cyclA] = 2
            elseif rand > udg_RarityChance[2] then
                set rarity[cyclA] = 1
            endif
            set cyclA = cyclA + 1
        endloop
        set i[1] = GetRandomInt(1, udg_Database_NumberItems[rarity[1]])
        set cyclA = 2
        loop
            exitwhen cyclA > h
            set f = rarity[cyclA]
            set i[cyclA] = GetRandomInt(1, udg_Database_NumberItems[f])
            if not(udg_Dublicate) then
                set cyclB = 1
                set cyclBEnd = cyclA - 1
                loop
                    exitwhen cyclB > cyclBEnd
                    if i[cyclA] == i[cyclB] and f == rarity[cyclB] and f != 0 then
                        set cyclA = cyclA - 1
                        set cyclB = cyclBEnd
                    endif
                    set cyclB = cyclB + 1
                endloop
            endif
            set cyclA = cyclA + 1
        endloop
        set cyclA = 1
        loop
            exitwhen cyclA > h
            set f = rarity[cyclA]
            set m = 0
            set cyclB = 1
            loop
                exitwhen cyclB > 1
                set l = false
                set j = DB_Items[f][i[cyclA]]
                set cyclC = 1
                loop
                    exitwhen cyclC > 4
                    if inv( udg_hero[cyclC], j ) > 0 then
                        set l = true
                        set cyclC = 4
                    endif
                    set cyclC = cyclC + 1
                endloop
                set cyclC = 1
                loop
                    exitwhen cyclC > h
                    if j == udg_JuleItem[cyclC] then
                        set l = true
                        set cyclC = h
                    endif
                    set cyclC = cyclC + 1
                endloop
                if l and not(udg_Dublicate) and m < 10 then
                    if i[cyclA] != 1 then
                        set i[cyclA] = i[cyclA] - 1
                        set m = m + 1
                    else
                        set i[cyclA] = udg_Database_NumberItems[f]
                    endif
                    set cyclB = cyclB - 1
                else
                    set udg_JuleItem[cyclA] = j
                endif
                set cyclB = cyclB + 1
            endloop
            set cyclA = cyclA + 1
        endloop
        
        if julenum >= 5 then
            set h = julenum - 4
            
            set cyclA = 1
            loop
                exitwhen cyclA > h
                set m = 0
                set cyclB = 1
                loop
                    exitwhen cyclB > 1
                    set rand = GetRandomInt(1,9)
                    set l = false
                    set j = DB_SetItems[rand][GetRandomInt(1,udg_DB_SetItems_Num[rand])]
                    set cyclC = 1
                    loop
                        exitwhen cyclC > 4
                        if inv( udg_hero[cyclC], j ) > 0 then
                            set l = true
                            set cyclC = 4
                        endif
                        set cyclC = cyclC + 1
                    endloop
                    set cyclC = 1
                    loop
                        exitwhen cyclC > 12+h
                        if j == udg_JuleItem[cyclC] then
                            set l = true
                            set cyclC = 12+h
                        endif
                        set cyclC = cyclC + 1
                    endloop
                    if l and not(udg_Dublicate) and m < 30 then
                        set cyclB = cyclB - 1
                    else
                        set udg_JuleItem[12+cyclA] = j
                    endif
                    set cyclB = cyclB + 1
                endloop
                set cyclA = cyclA + 1
            endloop
        endif
        
        set f = 0
        set cyclB = 1
        set preCount = PreCount()
        set preCountBool = PreCount_Condition()
        loop
            exitwhen cyclB > 4
            set cyclA = 1
            loop
                exitwhen cyclA > 4
                set f = f + 1
                if udg_JuleItem[f] != 0 then
                    set bj_lastCreatedItem = CreateItem(udg_JuleItem[f], 0, 0 )
                    
                    set j = 0
                    set str = ""
                    if GetItemType(bj_lastCreatedItem) == ITEM_TYPE_PERMANENT then
                        set j = 500
                    elseif GetItemType(bj_lastCreatedItem) == ITEM_TYPE_CAMPAIGN then
                        set j = 750
                    elseif GetItemType(bj_lastCreatedItem) == ITEM_TYPE_ARTIFACT then
                        set j = 1000
                    endif
                    set m = j
                    set j = ChangeCost(j, preCount, f, preCountBool)
                    
                    if j <= (0.45*m) then
                        set str = "|cFFFF4646"
                    elseif j <= (0.75*m) then
                        set str = "|cFFFE9050" 
                    elseif j > m then
                        set str = "|cFFBCC0C3"
                    endif
                    set julecost[cyclA][cyclB] = j
                    call BlzFrameSetText( juletext[cyclA][cyclB], str+I2S(j)+" G|r" )
                    
                    set str = BlzGetItemDescription(bj_lastCreatedItem)
                    call BlzFrameSetTexture( juleicon[cyclA][cyclB], BlzGetItemIconPath(bj_lastCreatedItem), 0, true )
                    //call BlzFrameSetSize( julediscback[cyclA][cyclB], 0.35, StringSizeStableTool(str) )
                    //call BlzFrameSetText( julename[cyclA][cyclB], GetItemName(bj_lastCreatedItem) )
                    //call BlzFrameSetText( juledisc[cyclA][cyclB], str )
                    set Item_Name[f] = GetItemName(bj_lastCreatedItem)
                    set Item_Description[f] = str
                    call RemoveItem(bj_lastCreatedItem)
                endif
                set cyclA = cyclA + 1
            endloop
            set cyclB = cyclB + 1
        endloop 
    endfunction

endlibrary