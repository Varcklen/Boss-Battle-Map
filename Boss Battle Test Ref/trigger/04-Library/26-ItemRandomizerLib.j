library ItemRandomizerLib requires SetRaritySpawnLib

    globals 
        boolean IsItemsRefreshed = false

        real Event_ItemRewardCreate_Real
        unit Event_ItemRewardCreate_Hero
        integer Event_ItemRewardCreate_Position
        integer Event_ItemRewardCreate_ItemReward
    endglobals

    function LegLogic takes integer i returns boolean
        local integer cyclA = 1
        local boolean l = false
        
    //if not( udg_Dublicate) then
        loop
            exitwhen cyclA > 4
            if inv( udg_hero[cyclA], DB_Items[3][i] ) > 0 then
                set l = true
            endif
            set cyclA = cyclA + 1
        endloop
    //endif
        return l
    endfunction

    function RareLogic takes integer i returns boolean
        local integer cyclA = 1
        local boolean l = false
    //if not( udg_Dublicate) then
        loop
            exitwhen cyclA > 4
            if inv( udg_hero[cyclA], DB_Items[2][i] ) > 0 then
                set l = true
            endif
            set cyclA = cyclA + 1
        endloop
    //endif
        return l
    endfunction

    function CommonLogic takes integer i returns boolean
        local integer cyclA = 1
        local boolean l = false

        //if not( udg_Dublicate) then
        loop
            exitwhen cyclA > 4
            if inv( udg_hero[cyclA], DB_Items[1][i] ) > 0 then
                set l = true
            endif
            set cyclA = cyclA + 1
        endloop
        //endif
        return l
    endfunction

    function ItemCreate_ItemPosition takes integer c, integer index returns boolean
        if index > 3 then
            set index = 3
        elseif index < 1 then
            set index = 1
        endif
        return c == index or c == (3+index) or c == (6+index) or c == (9+index)
    endfunction

    function ItemCreate takes integer index, integer i, integer c returns nothing
        local real x = GetLocationX(udg_itemcentr[c])
        local real y = GetLocationY(udg_itemcentr[c])
        local integer currentIndex = 0
        
        set Event_ItemRewardCreate_Hero = udg_hero[i]
        set Event_ItemRewardCreate_Position = c
        set Event_ItemRewardCreate_ItemReward = 0
        
        set Event_ItemRewardCreate_Real = 0.00
        set Event_ItemRewardCreate_Real = 1.00
        set Event_ItemRewardCreate_Real = 0.00
        
        set currentIndex = Event_ItemRewardCreate_ItemReward
        
        //if GetUnitAbilityLevel( udg_hero[i], 'A09I') > 0 and luckylogic( udg_hero[i], 4+(2*GetUnitAbilityLevel( udg_hero[i], 'A09I')), 1, 100 ) and ItemCreate_ItemPosition(c, 1) then
            //set currentIndex = 'I03X'
        if inv(udg_hero[i], 'I01I') > 0 and ItemCreate_ItemPosition(c, 2) then
            set currentIndex = udg_DB_Item_Destroyed[GetRandomInt(1,udg_DB_SetItems_Num[29])]
        elseif inv(udg_hero[i], 'I0FT') > 0 and ItemCreate_ItemPosition(c, 3) then
            set currentIndex = DB_SetItems[7][GetRandomInt(1,udg_DB_SetItems_Num[7])]
        elseif udg_FutureBall[i] != 0 then
            set currentIndex = udg_FutureBall[i]
            set udg_FutureBall[i] = 0
            call ChangeToolItem( udg_hero[i], 'I0FH', "Future: ", ")|r", "Nothing" )
        else
            set currentIndex = index
        endif
        
        if udg_modbad[25] and ItemCreate_ItemPosition(c, 1) then
            set udg_item[c] = CreateItem('I0FC', x, y)
            call SaveInteger( udg_hash, GetHandleId(udg_item[c]), StringHash( "modbad25" ), currentIndex )
        else
            set udg_item[c] = CreateItem( currentIndex, x, y)
        endif
        
        if GetItemType(udg_item[c]) == ITEM_TYPE_ARTIFACT then
            call SpecialEffectAngle( "Abilities\\Spells\\Human\\Resurrect\\ResurrectCaster.mdl", 270, x, y )
        else
            call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\Polymorph\\PolyMorphDoneGround.mdl", x, y ) )
        endif
        
        if GetItemTypeId(udg_item[c]) == 'I0FC' then
            set udg_LastReward[c] = LoadInteger( udg_hash, GetHandleId(udg_item[c]), StringHash( "modbad25" ) )
        else
            set udg_LastReward[c] = GetItemTypeId(udg_item[c])
        endif
    endfunction

    function ItemSpawn takes boolean a, boolean b, boolean c, boolean d returns nothing
        local integer array i
        local boolean array k
        local integer cyclA
        local integer cyclB
        local integer cyclBEnd
        local integer cyclC
        local boolean l
        local integer j
        local integer m
        local boolean h
        local integer f

        set k[0] = a
        set k[1] = b
        set k[2] = c
        set k[3] = d
        
        set cyclA = 1
        loop
            exitwhen cyclA > 4
            if k[cyclA-1] then
                set udg_ItemGetChoosed[cyclA] = false
                set udg_ItemGetActive[cyclA] = true
            endif
            set cyclA = cyclA + 1
        endloop
        
        set i[1] = GetRandomInt(1, udg_Database_NumberItems[udg_itemrarity[1]])
        set cyclA = 2
        loop
            exitwhen cyclA > 12
            set f = udg_itemrarity[cyclA]
            set i[cyclA] = GetRandomInt(1, udg_Database_NumberItems[f])
            if not(udg_Dublicate) and GetPlayerSlotState(Player((cyclA - 1)/3)) == PLAYER_SLOT_STATE_PLAYING then
                set cyclB = 1
                set cyclBEnd = cyclA - 1
                loop
                    exitwhen cyclB > cyclBEnd
                    if i[cyclA] == i[cyclB] and f == udg_itemrarity[cyclB] and f != 0 then
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
            exitwhen cyclA > 12
            set j = (cyclA - 1)/3
            set f = udg_itemrarity[cyclA]
            set m = 0
            if GetPlayerSlotState(Player( j )) == PLAYER_SLOT_STATE_PLAYING and k[j] then
                set cyclB = 1
                loop
                    exitwhen cyclB > 1
                    set cyclC = 1
                    set l = false
                    loop
                        exitwhen cyclC > 12
                        if GetItemTypeId(udg_item[cyclC]) == DB_Items[f][i[cyclA]] then
                            set l = true
                            set cyclC = 12
                        endif
                        set cyclC = cyclC + 1
                    endloop
                    set cyclC = 1
                    loop
                        exitwhen cyclC > 4
                        if inv( udg_hero[cyclC], DB_Items[f][i[cyclA]] ) > 0 then
                            set l = true
                            set cyclC = 4
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
                        call ItemCreate(DB_Items[f][i[cyclA]], j+1, cyclA )
                    endif
                    set cyclB = cyclB + 1
                endloop
            endif
            set cyclA = cyclA + 1
        endloop
    endfunction

    function ItemRandomizerAll takes unit caster, integer it returns item
        local integer randl = GetRandomInt(1, 100)
        local integer cyclA = 1
        local integer rand

        set udg_ItemBuf = null
        if randl <= udg_RarityChance[3] then
            loop
                exitwhen cyclA > 1
                set rand = GetRandomInt(1, udg_Database_NumberItems[3])
                if LegLogic(rand) then
                    set cyclA  = cyclA - 1
                else
                    set udg_ItemBuf = CreateItem(DB_Items[3][rand], GetUnitX(caster), GetUnitY(caster) )
                endif
                set cyclA = cyclA  + 1
            endloop
        elseif randl >= udg_RarityChance[3]+1 and randl <= udg_RarityChance[2] then
            loop
                exitwhen cyclA > 1
                set rand = GetRandomInt(1, udg_Database_NumberItems[2])
                if RareLogic(rand) then
                    set cyclA  = cyclA - 1
                else
                    set udg_ItemBuf = CreateItem(DB_Items[2][rand], GetUnitX(caster), GetUnitY(caster) )
                endif
                set cyclA = cyclA + 1
            endloop
        elseif randl >= udg_RarityChance[2]+1 then
            loop
                exitwhen cyclA > 1
                set rand = GetRandomInt(1, udg_Database_NumberItems[1])
                if CommonLogic(rand) then
                    set cyclA  = cyclA - 1
                else
                    set udg_ItemBuf = CreateItem(DB_Items[1][rand], GetUnitX(caster), GetUnitY(caster) )
                endif
                set cyclA = cyclA  + 1
            endloop
        endif
        if it == GetItemTypeId(udg_ItemBuf) then
            call SetPlayerState(GetOwningPlayer(caster), PLAYER_STATE_RESOURCE_GOLD, GetPlayerState(GetOwningPlayer(caster), PLAYER_STATE_RESOURCE_GOLD) + 200 )
        endif
        if udg_ItemBuf != null then
            call UnitAddItem( caster, udg_ItemBuf )
            set bj_lastCreatedItem = udg_ItemBuf
        endif
        set caster = null
        return udg_ItemBuf
    endfunction

    function ItemRandomizer takes unit caster, string str returns item
        local integer rand = GetRandomInt(1, 100)
        local integer cyclA = 1
        local integer i
        local integer it
        local integer r
        local integer k = 0
        
        set bj_lastCreatedItem = null
        if UnitInventoryCount(caster) < 6 then 
            if str == "legendary" then
                set i = 3
            elseif str == "rare" then
                set i = 2
            elseif str == "common" then
                set i = 1
            endif
            
            loop
                exitwhen cyclA > 1
                set r = GetRandomInt(1, udg_Database_NumberItems[i])
                if k < 12 and (( LegLogic(r) and str == "legendary" ) or ( RareLogic(r) and str == "rare" ) or ( CommonLogic(r) and str == "common" )) then
                    set cyclA  = cyclA - 1
                    set k = k + 1
                else
                    if str == "legendary" then
                        set it = DB_Items[3][r]
                    elseif str == "rare" then
                        set it = DB_Items[2][r]
                    elseif str == "common" then
                        set it = DB_Items[1][r]
                    endif
                    //bj_lastCreatedItem обязателен
                    set bj_lastCreatedItem = CreateItem( it, GetUnitX(caster), GetUnitY(caster) )
                    call UnitAddItem( caster, bj_lastCreatedItem )
                endif
                set cyclA = cyclA  + 1
            endloop
        endif
        set caster = null
        return bj_lastCreatedItem
    endfunction

    function ItemRandomizerItemId takes unit caster, string str returns integer
        local integer rand = GetRandomInt(1, 100)
        local integer cyclA = 1
        local integer i
        local integer it = 0
        local integer r
        local integer k = 0
        
        if str == "legendary" then
            set i = 3
        elseif str == "rare" then
            set i = 2
        elseif str == "common" then
            set i = 1
        endif
        
        loop
            exitwhen cyclA > 1
            set r = GetRandomInt(1, udg_Database_NumberItems[i])
            if k < 12 and (( LegLogic(r) and str == "legendary" ) or ( RareLogic(r) and str == "rare" ) or ( CommonLogic(r) and str == "common" )) then
                set cyclA  = cyclA - 1
                set k = k + 1
            else
                if str == "legendary" then
                    set it = DB_Items[3][r]
                elseif str == "rare" then
                    set it = DB_Items[2][r]
                elseif str == "common" then
                    set it = DB_Items[1][r]
                endif
            endif
            set cyclA = cyclA  + 1
        endloop
        
        set caster = null
        return it
    endfunction

    function Randomizer takes boolean a, boolean b, boolean c, boolean d returns nothing
        local integer cyclA = 1
        local integer cyclB
        local integer rand
        local integer j 
        local boolean l = false

        if a and b and c and d then
            set l = true
        endif
        
        if l and udg_logic[98] and not(udg_logic[76]) then
            call SetRaritySpawn( udg_RarityChance[3]+20, udg_RarityChance[2]+20 )
        endif

        if not( udg_worldmod[1] ) and not( udg_worldmod[8] ) then
            set cyclA = 1
            loop
                exitwhen cyclA > 12 
                set j = ( ( cyclA - 1 ) / 3 ) + 1
                set udg_itemrarity[cyclA] = 0
                if GetPlayerSlotState(Player( j - 1 )) == PLAYER_SLOT_STATE_PLAYING and not( inv( udg_hero[j], 'I0AC' ) > 0 and not(udg_logic[GetPlayerId( GetOwningPlayer( udg_hero[j] ) ) + 1 + 26]) and ( cyclA == 2 or cyclA == 5 or cyclA == 8 or cyclA == 11 ) ) then
                    set rand = GetRandomInt(1, 100)
                    if rand <= udg_RarityChance[3] or ( udg_logic[76] and l ) then
                        set udg_itemrarity[cyclA] = 3
                    elseif ( rand > udg_RarityChance[3] and rand <= udg_RarityChance[2] ) or ( inv( udg_hero[j], 'I0BU' ) > 0 and (cyclA == 3 or cyclA == 6 or cyclA == 9 or cyclA == 12) ) then
                        set udg_itemrarity[cyclA] = 2
                    elseif rand > udg_RarityChance[2] then
                        set udg_itemrarity[cyclA] = 1
                    endif
                endif
                set cyclA = cyclA + 1
            endloop
            call ItemSpawn( a,b,c,d)
        endif
        
        if l and udg_logic[98] and not(udg_logic[76]) then
            set udg_logic[98] = false
            call SetRaritySpawn( udg_RarityChance[3]-20, udg_RarityChance[2]-20 )
            call IconFrameDel( "Rarity" )
        endif
        
        if udg_logic[76] and l then
            set udg_logic[76] = false
            call IconFrameDel( "LegBook" )
        endif
    endfunction

endlibrary