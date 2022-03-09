library SaveLoadStartLib

function ExpEnd takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local player p = LoadPlayerHandle( udg_hash, id, StringHash( "exp2" ) )
    
    if GetLocalPlayer() == p then
        call BlzFrameSetVisible( expbar, false )
        call BlzFrameSetVisible( expicon, false )
    endif
    call FlushChildHashtable( udg_hash, id )
    
    set p = null
endfunction

function ExpDo takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local integer oldexp = LoadInteger( udg_hash, id, StringHash( "exp1old" ) ) + 5
    local integer expc = LoadInteger( udg_hash, id, StringHash( "exp1give" ) )
    local integer oldlvl = LoadInteger( udg_hash, id, StringHash( "exp1lvl" ) )
    local integer c = LoadInteger( udg_hash, id, StringHash( "exp1" ) ) + 5
    local player p = LoadPlayerHandle( udg_hash, id, StringHash( "exp1" ) )
    local integer ab1 
    local integer ab2 
    local integer id1
    local integer needenexp = 0
    
    if c < expc then
        call SaveInteger( udg_hash, id, StringHash( "exp1" ), c )
        if oldlvl <= 20 then
            set needenexp = udg_ExpNeeded[oldlvl]
        else
            set needenexp = udg_ExpNeeded[20] + (1000*(oldlvl-20))
        endif
        if oldexp < needenexp then
            if GetLocalPlayer() == p then
                call BlzFrameSetValue(BlzGetFrameByName("ExpBarEx",1), RMinBJ(100,(oldexp*100)/needenexp) )
                call BlzFrameSetText(BlzGetFrameByName("ExpBarExText",1), I2S(oldexp)+"/"+I2S(needenexp))
            endif
        else
            set oldexp = 0
            set oldlvl = oldlvl + 1
            if udg_ExpBonuses[oldlvl + 1] != 0 then
                set ab1 = udg_ExpBonuses[oldlvl + 1]
                set ab2 = udg_ExpBonuses[oldlvl]
            else
                set ab1 = 'A0RI'
                set ab2 = 'A0RI'
            endif
            
            call SaveInteger( udg_hash, id, StringHash( "exp1lvl" ), oldlvl )
            call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\Human\\ReviveHuman\\ReviveHuman.mdl", udg_hero[GetPlayerId(p) + 1], "origin" ) )
            if GetLocalPlayer() == p then
                if udg_ExpBonuses[oldlvl + 1] != 0 then
                    call BlzFrameSetVisible( expfon, true )
                    call BlzFrameSetTexture( expicon, BlzGetAbilityIcon(ab1),0, true)
                endif
                call BlzFrameSetValue(BlzGetFrameByName("ExpBarEx",1), 0 )
                call BlzFrameSetText(BlzGetFrameByName("ExpBarExText",1), I2S(oldexp)+"/"+I2S(needenexp))
                if ab2 != 'A0RI' then
                    call BlzFrameSetText( expword, BlzGetAbilityExtendedTooltip(ab2, 0) ) 
                endif
            endif
        endif
        call SaveInteger( udg_hash, id, StringHash( "exp1old" ), oldexp )
    else    
        set id1 = GetHandleId( p )
        if LoadTimerHandle( udg_hash, id1, StringHash( "exp2" ) ) == null  then
            call SaveTimerHandle( udg_hash, id1, StringHash( "exp2" ), CreateTimer() )
        endif
        set id1 = GetHandleId( LoadTimerHandle(udg_hash, id1, StringHash( "exp2" ) ) )
        call SavePlayerHandle( udg_hash, id1, StringHash( "exp2" ), p )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( p ), StringHash( "exp2" ) ), 10, false, function ExpEnd )
        
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    endif
    
    set p = null
endfunction

function ExpCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local integer oldexp = LoadInteger( udg_hash, id, StringHash( "expold" ) )
    local integer expc = LoadInteger( udg_hash, id, StringHash( "expgive" ) )
    local integer oldlvl = LoadInteger( udg_hash, id, StringHash( "explvl" ) )
    local player p = LoadPlayerHandle( udg_hash, id, StringHash( "exp" ) )
    local integer id1
    local integer ab1 
    
    if udg_ExpBonuses[oldlvl+1] != 0 then
        set ab1 = udg_ExpBonuses[oldlvl+1]
    else
        set ab1 = 'A0RI'
    endif

    if GetLocalPlayer() == p then
        call BlzFrameSetVisible( expbar, true )
        call BlzFrameSetVisible( expicon, true )
        call BlzFrameSetVisible( expfon, false )
        call BlzFrameSetTexture( expicon, BlzGetAbilityIcon(ab1),0, true)
        call BlzFrameSetText( expgive, "|cffffcc00 +" + I2S(expc) )
    endif

    set id1 = GetHandleId( p )
    if LoadTimerHandle( udg_hash, id1, StringHash( "exp1" ) ) == null then
        call SaveTimerHandle( udg_hash, id1, StringHash( "exp1" ), CreateTimer() )
    endif
    set id1 = GetHandleId( LoadTimerHandle(udg_hash, id1, StringHash( "exp1" ) ) )
    call SaveInteger( udg_hash, id1, StringHash( "exp1old" ), oldexp )
    call SaveInteger( udg_hash, id1, StringHash( "exp1lvl" ), oldlvl )
    call SaveInteger( udg_hash, id1, StringHash( "exp1give" ), expc )
    call SavePlayerHandle( udg_hash, id1, StringHash( "exp1" ), p )
    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( p ), StringHash( "exp1" ) ), 0.02, true, function ExpDo )

    call FlushChildHashtable( udg_hash, id )
    
    set p = null
endfunction

function ExperienceCounting takes integer i, integer exp, player p returns nothing
    local integer needenexp
    local integer expst = exp
    local integer expc = exp
    local integer oldexp = udg_Exp[i]
    local integer oldlvl = udg_LvL[i]
    local integer id
    
    if udg_LvL[i] <= 20 then
        set needenexp = udg_ExpNeeded[udg_LvL[i]]
    else
        set needenexp = udg_ExpNeeded[20] + (1000*(udg_LvL[i]-20))
    endif
    
    set expc = expc + udg_ExtraExp[i]
    if udg_HardNum > 0 and udg_Boss_LvL > 3 then
        set expc = expc + R2I(expst*0.2*udg_HardNum)
    endif
    if udg_logic[101] and udg_Boss_LvL > 3 then
        set expc = expc + R2I(expst*0.3)
    endif
    if udg_logic[6] and udg_Boss_LvL > 3 then
        set expc = expc + R2I(expst*0.15)
    endif
    if udg_logic[78] then
        set expc = expc + R2I(expst*0.15)
    endif
    if udg_Preset[9] then
        set expc = expc - R2I(expst*0.4)
    endif
    if udg_BossChange then
        set expc = expc - R2I(expst*0.8)
    endif
    if udg_worldmod[2] then
        set expc = expc + R2I(expst*0.25)
    endif
    if udg_worldmod[6] then
        set expc = expc + R2I(expst*0.5)
    endif
    if udg_worldmod[7] then
        set expc = expc + R2I(expst*0.2)
    endif
    
    if expc < 0 then
        set expc = 0
    endif
    if expc > 0 then
        set udg_Exp[i] = udg_Exp[i] + expc
        if udg_Exp[i] >= needenexp then
            set udg_Exp[i] = udg_Exp[i] - needenexp
            set udg_LvL[i] = udg_LvL[i] + 1
             
            if udg_LvL[i] <= 20 then
                set needenexp = udg_ExpNeeded[udg_LvL[i]]
            else
                set needenexp = udg_ExpNeeded[20] + (1000*(udg_LvL[i]-20))
            endif
            if udg_Exp[i] >= needenexp then
                set udg_Exp[i] = needenexp - 5
            endif
        endif
        
        set id = GetHandleId( p )
        if LoadTimerHandle( udg_hash, id, StringHash( "exp" ) ) == null  then
            call SaveTimerHandle( udg_hash, id, StringHash( "exp" ), CreateTimer() )
        endif
        set id = GetHandleId( LoadTimerHandle(udg_hash, id, StringHash( "exp" ) ) )
        call SaveInteger( udg_hash, id, StringHash( "expold" ), oldexp )
        call SaveInteger( udg_hash, id, StringHash( "explvl" ), oldlvl )
        call SaveInteger( udg_hash, id, StringHash( "expgive" ), expc )
        call SavePlayerHandle( udg_hash, id, StringHash( "exp" ), p )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( p ), StringHash( "exp" ) ), 2, false, function ExpCast )
    endif
endfunction

function SaveCoding takes integer i, integer exp, player p returns nothing
    local integer cyclA = 1
    local integer cyclAEnd
    local integer cyclB
    local integer cyclBEnd
    local integer cyclC
    local integer Con
    local integer KeyInt = 0
    local integer SumInt = 0
    local string Char = ""
    local string String = ""
    local string Key = ""
    local string EnString = ""
    local string FinString = ""
    local integer name
    
    if udg_LvL[i] < 100 then
        call ExperienceCounting(i,exp, p)
    endif
    
    set cyclAEnd = udg_SaveLoadMaxCharacters - 1
    loop
        exitwhen cyclA > cyclAEnd
        set udg_SaveLoadEncryptionNumbers[cyclA] = ""
        set cyclA = cyclA + 1
    endloop
    set cyclA = 1
    loop
        exitwhen cyclA > 2
        set udg_SaveLoadTempStrings[cyclA] = ""
        set cyclA = cyclA + 1
    endloop
    set KeyInt = GetRandomInt(1, udg_SaveLoadMaxEncryptionSets)
    set Key = udg_SaveLoadCharacterNumbers[KeyInt]
    set cyclA = 1
    set cyclAEnd = udg_SaveLoadMaxCharacters
    loop
        exitwhen cyclA > cyclAEnd
        set udg_SaveLoadEncryptionNumbers[cyclA - 1] = SubString(udg_SaveLoadEncryptionSet[KeyInt], cyclA - 1, cyclA)
        set cyclA = cyclA + 1
    endloop
    
    set cyclC = 1
    loop
        exitwhen cyclC > 2
        if cyclC == 1 then
            set Con = udg_Exp[i]
        elseif cyclC == 2 then
            set Con = udg_LvL[i]
        endif
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
            if udg_SaveLoadSlots[cyclC] - cyclA >= 1 then
                set udg_SaveLoadConversionDividedInt = Con / udg_SaveLoadPowerOfMaxNumber
                set udg_SaveLoadConversionRemainder = Con - ( udg_SaveLoadConversionDividedInt * udg_SaveLoadPowerOfMaxNumber )
                set udg_SaveLoadTempStrings[cyclC] = udg_SaveLoadTempStrings[cyclC] + udg_SaveLoadCharacterNumbers[udg_SaveLoadConversionDividedInt]
            else
                set udg_SaveLoadTempStrings[cyclC] = udg_SaveLoadTempStrings[cyclC] + udg_SaveLoadCharacterNumbers[udg_SaveLoadConversionRemainder]
            endif
            set Con = udg_SaveLoadConversionRemainder
            set cyclA = cyclA + 1
        endloop
        set cyclC = cyclC + 1
    endloop
    
    set cyclA = 1
    loop
        exitwhen cyclA > 2
        set EnString = EnString + udg_SaveLoadTempStrings[cyclA]
        set cyclA = cyclA + 1
    endloop
    
    set cyclA = 1
    set cyclAEnd = StringLength(EnString)
    loop
        exitwhen cyclA > cyclAEnd
        set cyclB = 0
        set cyclBEnd = udg_SaveLoadMaxCharacters - 1
        loop
            exitwhen cyclB > cyclBEnd
            if SubString(EnString, cyclA - 1, cyclA) == udg_SaveLoadCharacterNumbers[cyclB] then
                set SumInt = SumInt + cyclB
            endif
            set cyclB = cyclB + 1
        endloop
        set cyclA = cyclA + 1
    endloop
    set Con = SumInt
    set udg_SaveLoadConversionDividedInt = Con / udg_SaveLoadMaxCharacters
    set udg_SaveLoadConversionRemainder = Con - ( udg_SaveLoadConversionDividedInt * udg_SaveLoadMaxCharacters )
    set Char = udg_SaveLoadCharacterNumbers[udg_SaveLoadConversionRemainder]
    set EnString = EnString + Char

    set name = StringLength(GetPlayerName( p ))
    set cyclA = 1
    loop
        exitwhen cyclA > 2
        set cyclB = 1
        set cyclBEnd = udg_SaveLoadMaxCharacters
        loop
            exitwhen cyclB > cyclBEnd
            if SubString(GetPlayerName(p), cyclA - 1, cyclA) == SubString((udg_SaveLoadEncryptionSet[1]), cyclB - 1, cyclB) then
                set name = name + cyclB
            endif
            set cyclB = cyclB + 1
        endloop
        set cyclA = cyclA + 1
    endloop
    
    set Con = name
    set udg_SaveLoadConversionDividedInt = Con / udg_SaveLoadMaxCharacters
    set udg_SaveLoadConversionRemainder = Con - ( udg_SaveLoadConversionDividedInt * udg_SaveLoadMaxCharacters )
    set Char = udg_SaveLoadCharacterNumbers[udg_SaveLoadConversionRemainder]
    set EnString = EnString + Char

    set cyclA = 1
    set cyclAEnd = StringLength(EnString)
    loop
        exitwhen cyclA > cyclAEnd
        set cyclB = 0
        set cyclBEnd = udg_SaveLoadMaxCharacters - 1
        loop
            exitwhen cyclB > cyclBEnd
            if SubString(EnString, cyclA - 1, cyclA) == udg_SaveLoadCharacterNumbers[cyclB] then
                set String = String + udg_SaveLoadEncryptionNumbers[cyclB]
            endif
            set cyclB = cyclB + 1
        endloop
        set Con = cyclA
        set udg_SaveLoadConversionDividedInt = Con / udg_SaveLoadBlockSize
        set udg_SaveLoadConversionRemainder = Con - ( udg_SaveLoadConversionDividedInt * udg_SaveLoadBlockSize )
        if udg_SaveLoadConversionRemainder <= 0 then
            set String = String + "-"
        endif
        set cyclA = cyclA + 1
    endloop
    set FinString = Key + "-" + String
       
    if GetLocalPlayer() == p then
        call PreloadGenClear() 
        call PreloadGenStart()  
        call Preload("\")\ncall BlzSendSyncData(\"myprefix\", \"-load "+(FinString)+"\")//" )
        call PreloadGenEnd("BossBattleSave\\Boss Battle Progress.txt" ) 
        
        call PreloadGenClear() 
        call PreloadGenStart()  
        call Preload("\")\ncall BlzSendSyncData(\"myprefix\", \"-load "+(FinString)+"\")//" )
        call PreloadGenEnd("BossBattleSave\\Backup\\Boss Battle BackUp " + GetPlayerName(p) + " LvL " + I2S(udg_LvL[i]) + " Exp " + I2S(udg_Exp[i]) + " Key " + I2S(GetRandomInt(1, 9999 )) + ".txt" )
    endif
endfunction

function SaveLoadStart takes nothing returns nothing
    local integer cyclA
    local integer exp = 0
    local player p
    
    if (GetPlayerName(Player(0)) == "WorldEdit" and udg_GameStatus == GAME_STATUS_OFFLINE) or ( udg_Endgame == 1 and udg_GameStatus == GAME_STATUS_ONLINE ) then
        if udg_logic[43] then
            set exp = 500
            if udg_Multiboard_Time[3] == 0 then
                set exp = exp + R2I( 400 * ( 1 - ( udg_Multiboard_Time[2] / 60 ) ) )
            endif
        elseif udg_logic[1] then
            set exp = 50*(udg_Boss_LvL-1)
        endif
        set cyclA = 1
        loop
            exitwhen cyclA > 4
            set p = Player( cyclA - 1 )
            if GetPlayerSlotState( p ) == PLAYER_SLOT_STATE_PLAYING then
                call SaveCoding(cyclA, exp, p)
            endif
            set cyclA = cyclA + 1
        endloop
    endif
    
    set p = null
endfunction

endlibrary