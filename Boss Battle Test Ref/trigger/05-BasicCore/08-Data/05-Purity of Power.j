function Trig_Purity_of_Power_Actions takes nothing returns nothing
    set udg_Database_NumberItems[1] = 51
    set DB_Items[1][1] = 'I0C9'
    set DB_Items[1][2] = 'I09Z'
    set DB_Items[1][3] = 'I04I'
    set DB_Items[1][4] = 'I064'
    set DB_Items[1][5] = 'I04K'
    set DB_Items[1][6] = 'I06W'
    set DB_Items[1][7] = 'I023'
    set DB_Items[1][8] = 'I0BM'
    set DB_Items[1][9] = 'I0D5'
    set DB_Items[1][10] = 'I05J'
    set DB_Items[1][11] = 'I0A3'
    set DB_Items[1][12] = 'I026'
    set DB_Items[1][13] = 'I0AY'
    set DB_Items[1][14] = 'I00Y'
    set DB_Items[1][15] = 'I0B0'
    set DB_Items[1][16] = 'I0AZ'
    set DB_Items[1][17] = 'I04X'
    set DB_Items[1][18] = 'I0CU'
    set DB_Items[1][19] = 'I07D'
    set DB_Items[1][20] = 'I03Y'
    set DB_Items[1][21] = 'I06O'
    set DB_Items[1][22] = 'I0C4'
    set DB_Items[1][23] = 'I0C5'
    set DB_Items[1][24] = 'I09G'
    set DB_Items[1][25] = 'I04Z'
    set DB_Items[1][26] = 'I0CT'
    set DB_Items[1][27] = 'I00S'
    set DB_Items[1][28] = 'I06L'
    set DB_Items[1][29] = 'I002'
    set DB_Items[1][30] = 'I000'
    set DB_Items[1][31] = 'I001'
    set DB_Items[1][32] = 'I03V'
    set DB_Items[1][33] = 'I0D1'
    set DB_Items[1][34] = 'I0A0'
    set DB_Items[1][35] = 'I08O'
    set DB_Items[1][36] = 'I0AE'
    set DB_Items[1][37] = 'I0A2'
    set DB_Items[1][38] = 'I04D'
    set DB_Items[1][39] = 'I01H'
    set DB_Items[1][40] = 'I02A'
    set DB_Items[1][41] = 'I022'
    set DB_Items[1][42] = 'I066'
    set DB_Items[1][43] = 'I069'
    set DB_Items[1][44] = 'I029'
    set DB_Items[1][45] = 'I008'
    set DB_Items[1][46] = 'I02Y'
    set DB_Items[1][47] = 'I0CX'
    set DB_Items[1][48] = 'I07A'
    set DB_Items[1][49] = 'I09U'
    set DB_Items[1][50] = 'I06F'
    set DB_Items[1][51] = 'I08H'
    // a
    set udg_Database_NumberItems[2] = 29
    set DB_Items[2][1] = 'I08K'
    set DB_Items[2][2] = 'I047'
    set DB_Items[2][3] = 'I08P'
    set DB_Items[2][4] = 'I0AT'
    set DB_Items[2][5] = 'I0A9'
    set DB_Items[2][6] = 'I06Q'
    set DB_Items[2][7] = 'I0A8'
    set DB_Items[2][8] = 'I0BQ'
    set DB_Items[2][9] = 'I0B3'
    set DB_Items[2][10] = 'I0CI'
    set DB_Items[2][11] = 'I0AO'
    set DB_Items[2][12] = 'I09P'
    set DB_Items[2][13] = 'I09O'
    set DB_Items[2][14] = 'I09K'
    set DB_Items[2][15] = 'I09N'
    set DB_Items[2][16] = 'I09Q'
    set DB_Items[2][17] = 'I04E'
    set DB_Items[2][18] = 'I09M'
    set DB_Items[2][19] = 'I021'
    set DB_Items[2][20] = 'I0BS'
    set DB_Items[2][21] = 'I017'
    set DB_Items[2][22] = 'I08D'
    set DB_Items[2][23] = 'I084'
    set DB_Items[2][24] = 'I031'
    set DB_Items[2][25] = 'I043'
    set DB_Items[2][26] = 'I07P'
    set DB_Items[2][27] = 'I018'
    set DB_Items[2][28] = 'I0CK'
    set DB_Items[2][29] = 'I050'
    // a
    set udg_Database_NumberItems[3] = 14
    set DB_Items[3][1] = 'I00U'
    set DB_Items[3][2] = 'I0A5'
    set DB_Items[3][3] = 'I0C6'
    set DB_Items[3][4] = 'I06S'
    set DB_Items[3][5] = 'I0DI'
    set DB_Items[3][6] = 'I0DA'
    set DB_Items[3][7] = 'I01J'
    set DB_Items[3][8] = 'I04L'
    set DB_Items[3][9] = 'I06C'
    set DB_Items[3][10] = 'I05U'
    set DB_Items[3][11] = 'I0D6'
    set DB_Items[3][12] = 'I0D2'
    set DB_Items[3][13] = 'I0D7'
    set DB_Items[3][14] = 'I01L'
endfunction

//===========================================================================
function InitTrig_Purity_of_Power takes nothing returns nothing
    set gg_trg_Purity_of_Power = CreateTrigger(  )
    call TriggerAddAction( gg_trg_Purity_of_Power, function Trig_Purity_of_Power_Actions )
endfunction

