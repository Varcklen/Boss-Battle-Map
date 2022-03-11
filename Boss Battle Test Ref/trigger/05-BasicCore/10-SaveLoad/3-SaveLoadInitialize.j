function Trig_SaveLoadInitialize_Actions takes nothing returns nothing
    local integer cyclA = 1
    local integer cyclAEnd
    
    set udg_SaveLoadCharacterSet = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    set udg_SaveLoadMaxCharacters = 36
    set udg_SaveLoadEncryptionSet[1] = "JCYVQSB71EXK65WZ0LTA2POM8UIRHD43N9FG"
    set udg_SaveLoadEncryptionSet[2] = "A09UYH1R3CMZBK4DQ8OTS5LVIXPF7NGJ2E6W"
    set udg_SaveLoadEncryptionSet[3] = "92QXCID71KOLZ0PH6UWNMTB5GS38VJERAFY4"
    set udg_SaveLoadEncryptionSet[4] = "7MWYO49IVESG10ZC2NUTQ8AJFXR6K5BHDLP3"
    set udg_SaveLoadEncryptionSet[5] = "JU9RAWQYL4ICP73K8OSFM1BTN6EXVD025GHZ"
    set udg_SaveLoadEncryptionSet[6] = "YXN70HR64ZBG9UIJE3DWS5TOPCLMAKF2V81Q"
    set udg_SaveLoadMaxEncryptionSets = 6
    set cyclAEnd = udg_SaveLoadMaxCharacters 
    loop
        exitwhen cyclA > cyclAEnd
        set udg_SaveLoadCharacterNumbers[cyclA - 1] = SubString( udg_SaveLoadCharacterSet, cyclA - 1, cyclA )
        set cyclA = cyclA + 1
    endloop
    set udg_SaveLoadBlockSize = 6
    //Expirience
    set udg_SaveLoadSlots[1] = 4
    //LvL
    set udg_SaveLoadSlots[2] = 2
    set cyclA = 1
    loop
        exitwhen cyclA > 2
        set udg_SaveLoadHasLoaded[cyclA] = false
        set cyclA = cyclA + 1
    endloop
    
    set udg_ExpNeeded[1] = 500
    set udg_ExpNeeded[2] = 600
    set udg_ExpNeeded[3] = 700
    set udg_ExpNeeded[4] = 800
    set udg_ExpNeeded[5] = 900
    set udg_ExpNeeded[6] = 1000
    set udg_ExpNeeded[7] = 1500
    set udg_ExpNeeded[8] = 2000
    set udg_ExpNeeded[9] = 2000
    set udg_ExpNeeded[10] = 2500
    set udg_ExpNeeded[11] = 3000
    set udg_ExpNeeded[12] = 4000
    set udg_ExpNeeded[13] = 4500
    set udg_ExpNeeded[14] = 5000
    set udg_ExpNeeded[15] = 6000
    set udg_ExpNeeded[16] = 6500
    set udg_ExpNeeded[17] = 7000
    set udg_ExpNeeded[18] = 7500
    set udg_ExpNeeded[19] = 8000
    set udg_ExpNeeded[20] = 10000
    
    set udg_ExpBonuses[2] = 'A01L'
    set udg_ExpBonuses[3] = 'A01M'
    set udg_ExpBonuses[4] = 'A01N'
    set udg_ExpBonuses[5] = 'A01O'
    set udg_ExpBonuses[6] = 'A01P'
    set udg_ExpBonuses[7] = 'A01Q'
    set udg_ExpBonuses[8] = 'A0P2'
    set udg_ExpBonuses[9] = 'A01S'
    set udg_ExpBonuses[10] = 'A0KK'
    set udg_ExpBonuses[11] = 'A0QV'
    set udg_ExpBonuses[12] = 'A0P9'
    set udg_ExpBonuses[13] = 'A0PK'
    set udg_ExpBonuses[14] = 'A0QO'
    set udg_ExpBonuses[15] = 'A0QR'
    set udg_ExpBonuses[20] = 'A0RH'
endfunction

//===========================================================================
function InitTrig_SaveLoadInitialize takes nothing returns nothing
    set gg_trg_SaveLoadInitialize = CreateTrigger(  )
    call TriggerRegisterTimerExpireEvent( gg_trg_SaveLoadInitialize, udg_StartTimer )
    call TriggerAddAction( gg_trg_SaveLoadInitialize, function Trig_SaveLoadInitialize_Actions )
endfunction