function LoadProgress takes integer i, string str returns nothing
    local integer cyclA = 1
    local integer cyclAEnd
    local integer cyclB
    local integer cyclBEnd
    local integer cyclC
    local integer KeyInt = 0
    local integer SumInt = 0
    local integer ic
    local integer str1
    local integer str2
    local string PrStr = ""
    local string PrStr2 = ""
    local string Char = ""
    local string Char2 = ""
    local string array EnNum
    local string array TempStr
    local string FinStr = null
    local string EnStr
    local string EnStr2
    local string EnKey
    local player p = Player(i-1)
    
    if str == "" then
        set FinStr = StringCase(SubString(udg_LoadCode[i], 6, StringLength(udg_LoadCode[i])), true)
    else
        set FinStr = StringCase(SubString(str, 6, StringLength(str)), true)
    endif
    
    if FinStr != null then
        set EnStr = SubString(FinStr, 1, StringLength(FinStr) - 1)
        set EnStr2 = SubString(FinStr, 1, StringLength(FinStr))
        set EnKey = SubString(FinStr, 0, 1)

        set cyclAEnd = udg_SaveLoadMaxCharacters
        loop
            exitwhen cyclA > cyclAEnd
            set EnNum[cyclA - 1] = ""
            set cyclA = cyclA + 1
        endloop
        set cyclA = 1
        loop
            exitwhen cyclA > 2
            set TempStr[cyclA] = ""
            set cyclA = cyclA + 1
        endloop
        set cyclA = 0
        set cyclAEnd = udg_SaveLoadMaxCharacters - 1
        loop
            exitwhen cyclA > cyclAEnd
            if EnKey == udg_SaveLoadCharacterNumbers[cyclA] then
                set KeyInt = cyclA
            endif
            set cyclA = cyclA + 1
        endloop
        set cyclA = 1
        set cyclAEnd = udg_SaveLoadMaxCharacters
        loop
            exitwhen cyclA > cyclAEnd
            set EnNum[cyclA - 1] = SubString(udg_SaveLoadEncryptionSet[KeyInt], cyclA - 1, cyclA)
            set cyclA = cyclA + 1
        endloop
        set cyclA = 1
        set cyclAEnd = StringLength(EnStr)
        loop
            exitwhen cyclA > cyclAEnd
            set cyclB = 0
            set cyclBEnd = udg_SaveLoadMaxCharacters - 1
            loop
                exitwhen cyclB > cyclBEnd
                if SubString(EnStr, cyclA - 1, cyclA) == EnNum[cyclB] then
                    set PrStr = PrStr + udg_SaveLoadCharacterNumbers[cyclB]
                endif
                set cyclB = cyclB + 1
            endloop
            set cyclA = cyclA + 1
        endloop
          
        set cyclA = 1
        set cyclAEnd = StringLength(EnStr2)
        loop
            exitwhen cyclA > cyclAEnd
            set cyclB = 0
            set cyclBEnd = udg_SaveLoadMaxCharacters - 1
            loop
                exitwhen cyclB > cyclBEnd
                if SubString(EnStr2, cyclA - 1, cyclA) == EnNum[cyclB] then
                    set PrStr2 = PrStr2 + udg_SaveLoadCharacterNumbers[cyclB]
                endif
                set cyclB = cyclB + 1
            endloop
            set cyclA = cyclA + 1
        endloop
        
        set ic = StringLength(PrStr)
        set Char = StringCase(SubString(PrStr, ic - 1, ic), true)  
        set ic = StringLength(PrStr2)
        set Char2 = StringCase(SubString(PrStr2, ic - 1, ic), true)
        set PrStr = SubString(PrStr, 0, StringLength(PrStr) - 1 )

        set cyclA = 1
        set cyclAEnd = StringLength(PrStr)
        loop
            exitwhen cyclA > cyclAEnd
            set cyclB = 0
            set cyclBEnd = udg_SaveLoadMaxCharacters - 1
            loop
                exitwhen cyclB > cyclBEnd
                if SubString(PrStr, cyclA - 1, cyclA) == udg_SaveLoadCharacterNumbers[cyclB] then
                    set SumInt = SumInt + cyclB
                endif
                set cyclB = cyclB + 1
            endloop
            set cyclA = cyclA + 1
        endloop

        set str1 = SumInt - ( ( SumInt / udg_SaveLoadMaxCharacters ) * udg_SaveLoadMaxCharacters )
        set SumInt = StringLength(GetPlayerName( p ))
        set cyclA = 1
        loop
            exitwhen cyclA > 2
            set cyclB = 1
            set cyclBEnd = udg_SaveLoadMaxCharacters
            loop
                exitwhen cyclB > cyclBEnd
                if SubString(GetPlayerName(p), cyclA - 1, cyclA) == SubString((udg_SaveLoadEncryptionSet[1]), cyclB - 1, cyclB) then
                    set SumInt = SumInt + cyclB
                endif
                set cyclB = cyclB + 1
            endloop
            set cyclA = cyclA + 1
        endloop
        set str2 = SumInt - ( ( SumInt / udg_SaveLoadMaxCharacters ) * udg_SaveLoadMaxCharacters )

        if Char2 != udg_SaveLoadCharacterNumbers[str2] or Char != udg_SaveLoadCharacterNumbers[str1] then
            if Char != null then
                call DisplayTimedTextToPlayer(p, 0, 0, 15, "|cffff0000Warning!|r Your save file is damaged, did not load or you are playing with a different nickname.")
                call DisplayTimedTextToPlayer(p, 0, 0, 15, "Please use the \"-autoload\" command, backup file or contact the developer.")
            endif
        elseif not( udg_SaveLoadHasLoaded[i]) then
            set ic = 1
            set cyclC = 1
            loop
                exitwhen cyclC > 2
                set TempStr[cyclC] = SubString(PrStr, ic - 1, ic + udg_SaveLoadSlots[cyclC] - 1 )
                set ic = ic + udg_SaveLoadSlots[cyclC]
                set cyclC = cyclC + 1
            endloop
            
            set cyclC = 1
            loop
                exitwhen cyclC > 2
                set udg_SaveLoadMultiple = 0
                set cyclA = 1
                set cyclAEnd = udg_SaveLoadSlots[cyclC]
                loop
                    exitwhen cyclA > cyclAEnd
                    set udg_SaveLoadPowerOfMaxNumber = 1
                    set cyclB = cyclA
                    set cyclBEnd = udg_SaveLoadSlots[cyclC] - 1
                    loop
                        exitwhen cyclB > cyclBEnd
                        set udg_SaveLoadPowerOfMaxNumber = udg_SaveLoadPowerOfMaxNumber * udg_SaveLoadMaxCharacters
                        set cyclB = cyclB + 1
                    endloop
                    set cyclB = 0
                    set cyclBEnd = udg_SaveLoadMaxCharacters - 1
                    loop
                        exitwhen cyclB > cyclBEnd
                        if SubString(TempStr[cyclC], cyclA - 1, cyclA) == udg_SaveLoadCharacterNumbers[cyclB] then
                            set udg_SaveLoadMultiple = udg_SaveLoadMultiple + ( cyclB * udg_SaveLoadPowerOfMaxNumber )
                        endif
                        set cyclB = cyclB + 1
                    endloop
                    set cyclA = cyclA + 1
                endloop
                if cyclC == 1 then
                    set udg_Exp[i] = udg_SaveLoadMultiple
                elseif cyclC == 2 then
                    set udg_LvL[i] = udg_SaveLoadMultiple
                endif
                set cyclC = cyclC + 1
            endloop

            if udg_LvL[i] > 100 then
                set udg_LvL[i] = 1
                set udg_Exp[i] = 0
            endif

            set udg_SaveLoadHasLoaded[cyclA] = false
            call DisplayTimedTextToPlayer(p, 0, 0, 10, "Welcome!")
            call DisplayTimedTextToPlayer(p, 0, 0, 10, "|cffffcc00Level:|r " + I2S( udg_LvL[i] ) )
            call DisplayTimedTextToPlayer(p, 0, 0, 10, "|cffffcc00Experience:|r " + I2S( udg_Exp[i] ) )
        else
            call DisplayTimedTextToPlayer(p, 0, 0, 10, "The saves have already been loaded.")
        endif
    endif
       
    set p = null
endfunction

function BonusLoadModule takes nothing returns nothing
    local integer cyclA = 1
    local integer j
    
    set cyclA = 1
    loop
        exitwhen cyclA > 4
        if GetPlayerSlotState( Player( cyclA - 1 ) ) == PLAYER_SLOT_STATE_PLAYING and not(udg_AlreadyLoaded[cyclA]) and udg_LvL[cyclA] > 1 then
            set j = cyclA + 4
            set udg_AlreadyLoaded[cyclA] = true
            if udg_LvL[cyclA] >= 2 then
                call UnitAddAbility( udg_unit[j], udg_ExpBonuses[2] )
            endif
            if udg_LvL[cyclA] >= 3 then
                call UnitAddAbility( udg_unit[j], udg_ExpBonuses[3] )
            endif
            if udg_LvL[cyclA] >= 4 then
                call UnitAddAbility( udg_unit[j], udg_ExpBonuses[4] )
            endif
            if udg_LvL[cyclA] >= 5 then
                call UnitAddAbility( udg_unit[j], udg_ExpBonuses[5] )
                set udg_logic[cyclA + 90] = true
            endif
            if udg_LvL[cyclA] >= 11 then
                call UnitAddAbility( udg_unit[j], udg_ExpBonuses[11] )
            elseif udg_LvL[cyclA] >= 8 then
                call UnitAddAbility( udg_unit[j], udg_ExpBonuses[8] )
            elseif udg_LvL[cyclA] >= 6 then
                call UnitAddAbility( udg_unit[j], udg_ExpBonuses[6] )
            endif
            if udg_LvL[cyclA] >= 14 then
                call UnitAddAbility( udg_unit[j], udg_ExpBonuses[14] )
                set udg_rollbase[cyclA] = udg_rollbase[cyclA] + 2
            elseif udg_LvL[cyclA] >= 7 then
                call UnitAddAbility( udg_unit[j], udg_ExpBonuses[7] )
                set udg_rollbase[cyclA] = udg_rollbase[cyclA] + 1
            endif
            if udg_LvL[cyclA] >= 9 then
                call UnitAddAbility( udg_unit[j], udg_ExpBonuses[9] )
            endif
            if udg_LvL[cyclA] >= 10 then
                call UnitAddAbility( udg_unit[j], udg_ExpBonuses[10] )
            endif
            if udg_LvL[cyclA] >= 12 then
                call UnitAddAbility( udg_unit[j], udg_ExpBonuses[12] )
                call SetRaritySpawn(udg_RarityChance[3] + 1, udg_RarityChance[2] + 1)
            endif
            if udg_LvL[cyclA] >= 13 then
                call UnitAddAbility( udg_unit[j], udg_ExpBonuses[13] )
            endif
            if udg_LvL[cyclA] >= 15 then
                call UnitAddAbility( udg_unit[j], udg_ExpBonuses[15] )
            endif
            if udg_LvL[cyclA] >= 20 then
                call UnitAddAbility( udg_unit[j], udg_ExpBonuses[20] )
            endif
        endif
        set cyclA = cyclA + 1
    endloop
endfunction

function ItemLoadModule takes nothing returns nothing
    local integer cyclA
    local integer cyclAEnd
    
    if udg_UntilFirstFight then
        if AnyHasLvL(6) and not(udg_logic[48]) then
            set udg_logic[48] = true
            set cyclA = 1
            set cyclAEnd = udg_DB_NumLvLItems[1]
            loop
                exitwhen cyclA > cyclAEnd
                set DB_Items[1][udg_Database_NumberItems[1]+cyclA] = udg_DB_Item_ForLvL1_Common[cyclA]
                set cyclA = cyclA + 1
            endloop
            set udg_Database_NumberItems[1] = udg_Database_NumberItems[1] + udg_DB_NumLvLItems[1]
            
            set cyclA = 1
            set cyclAEnd = udg_DB_NumLvLItems[4]
            loop
                exitwhen cyclA > cyclAEnd
                set DB_Items[2][udg_Database_NumberItems[2]+cyclA] = udg_DB_Item_ForLvL1_Rare[cyclA]
                set cyclA = cyclA + 1
            endloop
            set udg_Database_NumberItems[2] = udg_Database_NumberItems[2] + udg_DB_NumLvLItems[4]
            
            set cyclA = 1
            set cyclAEnd = udg_DB_NumLvLItems[7]
            loop
                exitwhen cyclA > cyclAEnd
                set DB_Items[3][udg_Database_NumberItems[3]+cyclA] = udg_DB_Item_ForLvL1_Legendary[cyclA]
                set cyclA = cyclA + 1
            endloop
            set udg_Database_NumberItems[3] = udg_Database_NumberItems[3] + udg_DB_NumLvLItems[7]
        endif
        
        if AnyHasLvL(8) and not(udg_logic[49]) then
            set udg_logic[49] = true
            set cyclA = 1
            set cyclAEnd = udg_DB_NumLvLItems[2]
            loop
                exitwhen cyclA > cyclAEnd
                set DB_Items[1][udg_Database_NumberItems[1]+cyclA] = udg_DB_Item_ForLvL2_Common[cyclA]
                set cyclA = cyclA + 1
            endloop
            set udg_Database_NumberItems[1] = udg_Database_NumberItems[1] + udg_DB_NumLvLItems[2]
            
            set cyclA = 1
            set cyclAEnd = udg_DB_NumLvLItems[5]
            loop
                exitwhen cyclA > cyclAEnd
                set DB_Items[2][udg_Database_NumberItems[2]+cyclA] = udg_DB_Item_ForLvL2_Rare[cyclA]
                set cyclA = cyclA + 1
            endloop
            set udg_Database_NumberItems[2] = udg_Database_NumberItems[2] + udg_DB_NumLvLItems[5]
            
            set cyclA = 1
            set cyclAEnd = udg_DB_NumLvLItems[8]
            loop
                exitwhen cyclA > cyclAEnd
                set DB_Items[3][udg_Database_NumberItems[3]+cyclA] = udg_DB_Item_ForLvL2_Legendary[cyclA]
                set cyclA = cyclA + 1
            endloop
            set udg_Database_NumberItems[3] = udg_Database_NumberItems[3] + udg_DB_NumLvLItems[8]
        endif
        
        if AnyHasLvL(11) and not(udg_logic[50]) then
            set udg_logic[50] = true
            set cyclA = 1
            set cyclAEnd = udg_DB_NumLvLItems[3]
            loop
                exitwhen cyclA > cyclAEnd
                set DB_Items[1][udg_Database_NumberItems[1]+cyclA] = udg_DB_Item_ForLvL3_Common[cyclA]
                set cyclA = cyclA + 1
            endloop
            set udg_Database_NumberItems[1] = udg_Database_NumberItems[1] + udg_DB_NumLvLItems[3]
            
            set cyclA = 1
            set cyclAEnd = udg_DB_NumLvLItems[6]
            loop
                exitwhen cyclA > cyclAEnd
                set DB_Items[2][udg_Database_NumberItems[2]+cyclA] = udg_DB_Item_ForLvL3_Rare[cyclA]
                set cyclA = cyclA + 1
            endloop
            set udg_Database_NumberItems[2] = udg_Database_NumberItems[2] + udg_DB_NumLvLItems[6]
            
            set cyclA = 1
            set cyclAEnd = udg_DB_NumLvLItems[9]
            loop
                exitwhen cyclA > cyclAEnd
                set DB_Items[3][udg_Database_NumberItems[3]+cyclA] = udg_DB_Item_ForLvL3_Legendary[cyclA]
                set cyclA = cyclA + 1
            endloop
            set udg_Database_NumberItems[3] = udg_Database_NumberItems[3] + udg_DB_NumLvLItems[9]
        endif
    endif
endfunction

function Trig_LoadModuleSingle_Actions takes nothing returns nothing
    local integer cyclA = 1

    //call Preloader("BossBattleSave\\Boss Battle Progress.txt")
    //call LoadProgress(GetPlayerId(GetLocalPlayer()) + 1)
    
    loop
        exitwhen cyclA > 4
        if GetPlayerSlotState( Player( cyclA - 1 ) ) == PLAYER_SLOT_STATE_PLAYING then
            call LoadProgress( cyclA, "" )
            call BlzFrameSetText( lvltxt[cyclA], I2S(udg_LvL[cyclA]) )
        endif
        set cyclA = cyclA + 1
    endloop
    
    call BonusLoadModule()
    call ItemLoadModule()
endfunction

//===========================================================================
function InitTrig_LoadModuleSingle takes nothing returns nothing
    set gg_trg_LoadModuleSingle = CreateTrigger(  )
    call TriggerRegisterTimerEvent(gg_trg_LoadModuleSingle, 1.5, false)
    call TriggerAddAction( gg_trg_LoadModuleSingle, function Trig_LoadModuleSingle_Actions )
endfunction

