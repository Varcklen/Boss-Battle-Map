function Trig_FastStart_Data_Actions takes nothing returns nothing
    set udg_DB_FS_Size = 17
    // Боец
    set udg_DB_FS_Name[1] = "Fighter"
    set udg_DB_FS_Start[1] = 1
    set udg_DB_FS_End[1] = 28
    set udg_DB_FS_Item[1] = 'I09K'
    set udg_DB_FS_Item[2] = 'I02P'
    set udg_DB_FS_Item[3] = 'I00W'
    set udg_DB_FS_Item[4] = 'I00A'
    set udg_DB_FS_Item[5] = 'I047'
    set udg_DB_FS_Item[6] = 'I09N'
    set udg_DB_FS_Item[7] = 'I00G'
    set udg_DB_FS_Item[8] = 'I05G'
    set udg_DB_FS_Item[9] = 'I02O'
    set udg_DB_FS_Item[10] = 'I046'
    set udg_DB_FS_Item[11] = 'I02E'
    set udg_DB_FS_Item[12] = 'I02X'
    set udg_DB_FS_Item[13] = 'I06L'
    set udg_DB_FS_Item[14] = 'I04X'
    set udg_DB_FS_Item[15] = 'I079'
    set udg_DB_FS_Item[16] = 'I09H'
    set udg_DB_FS_Item[17] = 'I04Y'
    set udg_DB_FS_Item[18] = 'I0BD'
    set udg_DB_FS_Item[19] = 'I01B'
    set udg_DB_FS_Item[20] = 'I07F'
    set udg_DB_FS_Item[21] = 'I0AF'
    set udg_DB_FS_Item[22] = 'I00M'
    set udg_DB_FS_Item[23] = 'I09W'
    set udg_DB_FS_Item[24] = 'I07N'
    set udg_DB_FS_Item[25] = 'I027'
    set udg_DB_FS_Item[26] = 'I0BF'
    set udg_DB_FS_Item[27] = 'I07R'
    set udg_DB_FS_Item[28] = 'I0B8'
    // Защитник
    set udg_DB_FS_Name[2] = "Defender"
    set udg_DB_FS_Start[2] = ( udg_DB_FS_End[1] + 1 )
    set udg_DB_FS_End[2] = ( udg_DB_FS_End[1] + 29 )
    set udg_DB_FS_Item[( udg_DB_FS_End[1] + 1 )] = 'I0AV'
    set udg_DB_FS_Item[( udg_DB_FS_End[1] + 2 )] = 'I0AM'
    set udg_DB_FS_Item[( udg_DB_FS_End[1] + 3 )] = 'I09Z'
    set udg_DB_FS_Item[( udg_DB_FS_End[1] + 4 )] = 'I0AK'
    set udg_DB_FS_Item[( udg_DB_FS_End[1] + 5 )] = 'I002'
    set udg_DB_FS_Item[( udg_DB_FS_End[1] + 6 )] = 'I08F'
    set udg_DB_FS_Item[( udg_DB_FS_End[1] + 7 )] = 'I0AP'
    set udg_DB_FS_Item[( udg_DB_FS_End[1] + 8 )] = 'I04G'
    set udg_DB_FS_Item[( udg_DB_FS_End[1] + 9 )] = 'I049'
    set udg_DB_FS_Item[( udg_DB_FS_End[1] + 10 )] = 'I0AT'
    set udg_DB_FS_Item[( udg_DB_FS_End[1] + 11 )] = 'I04S'
    set udg_DB_FS_Item[( udg_DB_FS_End[1] + 12 )] = 'I09Q'
    set udg_DB_FS_Item[( udg_DB_FS_End[1] + 13 )] = 'I000'
    set udg_DB_FS_Item[( udg_DB_FS_End[1] + 14 )] = 'I001'
    set udg_DB_FS_Item[( udg_DB_FS_End[1] + 15 )] = 'I06U'
    set udg_DB_FS_Item[( udg_DB_FS_End[1] + 16 )] = 'I066'
    set udg_DB_FS_Item[( udg_DB_FS_End[1] + 17 )] = 'I029'
    set udg_DB_FS_Item[( udg_DB_FS_End[1] + 18 )] = 'I02Y'
    set udg_DB_FS_Item[( udg_DB_FS_End[1] + 19 )] = 'I03X'
    set udg_DB_FS_Item[( udg_DB_FS_End[1] + 20 )] = 'I02G'
    set udg_DB_FS_Item[( udg_DB_FS_End[1] + 21 )] = 'I00O'
    set udg_DB_FS_Item[( udg_DB_FS_End[1] + 22 )] = 'I04Z'
    set udg_DB_FS_Item[( udg_DB_FS_End[1] + 23 )] = 'I09T'
    set udg_DB_FS_Item[( udg_DB_FS_End[1] + 24 )] = 'I0A6'
    set udg_DB_FS_Item[( udg_DB_FS_End[1] + 25 )] = 'I00X'
    set udg_DB_FS_Item[( udg_DB_FS_End[1] + 26 )] = 'I04T'
    set udg_DB_FS_Item[( udg_DB_FS_End[1] + 27 )] = 'I01L'
    set udg_DB_FS_Item[( udg_DB_FS_End[1] + 28 )] = 'I0AJ'
    set udg_DB_FS_Item[( udg_DB_FS_End[1] + 29 )] = 'I00B'
    // Алхимик
    set udg_DB_FS_Name[3] = "Alchemist"
    set udg_DB_FS_Start[3] = ( udg_DB_FS_End[2] + 1 )
    set udg_DB_FS_End[3] = ( udg_DB_FS_End[2] + 20 )
    set udg_DB_FS_Item[( udg_DB_FS_End[2] + 1 )] = 'I05N'
    set udg_DB_FS_Item[( udg_DB_FS_End[2] + 2 )] = 'I023'
    set udg_DB_FS_Item[( udg_DB_FS_End[2] + 3 )] = 'I05Q'
    set udg_DB_FS_Item[( udg_DB_FS_End[2] + 21 )] = 'I0AS'
    set udg_DB_FS_Item[( udg_DB_FS_End[2] + 4 )] = 'I04B'
    set udg_DB_FS_Item[( udg_DB_FS_End[2] + 5 )] = 'I06U'
    set udg_DB_FS_Item[( udg_DB_FS_End[2] + 6 )] = 'I07E'
    set udg_DB_FS_Item[( udg_DB_FS_End[2] + 7 )] = 'I014'
    set udg_DB_FS_Item[( udg_DB_FS_End[2] + 8 )] = 'I03Q'
    set udg_DB_FS_Item[( udg_DB_FS_End[2] + 9 )] = 'I07H'
    set udg_DB_FS_Item[( udg_DB_FS_End[2] + 10 )] = 'I07F'
    set udg_DB_FS_Item[( udg_DB_FS_End[2] + 11 )] = 'I075'
    set udg_DB_FS_Item[( udg_DB_FS_End[2] + 12 )] = 'I08E'
    set udg_DB_FS_Item[( udg_DB_FS_End[2] + 13 )] = 'I09Y'
    set udg_DB_FS_Item[( udg_DB_FS_End[2] + 14 )] = 'I0AR'
    set udg_DB_FS_Item[( udg_DB_FS_End[2] + 15 )] = 'I02V'
    set udg_DB_FS_Item[( udg_DB_FS_End[2] + 16 )] = 'I0BA'
    set udg_DB_FS_Item[( udg_DB_FS_End[2] + 17 )] = 'I07B'
    set udg_DB_FS_Item[( udg_DB_FS_End[2] + 18 )] = 'I09M'
    set udg_DB_FS_Item[( udg_DB_FS_End[2] + 19 )] = 'I07U'
    set udg_DB_FS_Item[( udg_DB_FS_End[2] + 20 )] = 'I044'
    // Лекарь
    set udg_DB_FS_Name[4] = "Healer"
    set udg_DB_FS_Start[4] = ( udg_DB_FS_End[3] + 1 )
    set udg_DB_FS_End[4] = ( udg_DB_FS_End[3] + 19 )
    set udg_DB_FS_Item[( udg_DB_FS_End[3] + 1 )] = 'I04I'
    set udg_DB_FS_Item[( udg_DB_FS_End[3] + 2 )] = 'I0AK'
    set udg_DB_FS_Item[( udg_DB_FS_End[3] + 3 )] = 'I049'
    set udg_DB_FS_Item[( udg_DB_FS_End[3] + 4 )] = 'I07D'
    set udg_DB_FS_Item[( udg_DB_FS_End[3] + 5 )] = 'I04G'
    set udg_DB_FS_Item[( udg_DB_FS_End[3] + 6 )] = 'I043'
    set udg_DB_FS_Item[( udg_DB_FS_End[3] + 7 )] = 'I0A0'
    set udg_DB_FS_Item[( udg_DB_FS_End[3] + 8 )] = 'I00H'
    set udg_DB_FS_Item[( udg_DB_FS_End[3] + 9 )] = 'I0AW'
    set udg_DB_FS_Item[( udg_DB_FS_End[3] + 10 )] = 'I015'
    set udg_DB_FS_Item[( udg_DB_FS_End[3] + 11 )] = 'I00Q'
    set udg_DB_FS_Item[( udg_DB_FS_End[3] + 12 )] = 'I08H'
    set udg_DB_FS_Item[( udg_DB_FS_End[3] + 13 )] = 'I08E'
    set udg_DB_FS_Item[( udg_DB_FS_End[3] + 14 )] = 'I0B6'
    set udg_DB_FS_Item[( udg_DB_FS_End[3] + 15 )] = 'I06R'
    set udg_DB_FS_Item[( udg_DB_FS_End[3] + 16 )] = 'I00U'
    set udg_DB_FS_Item[( udg_DB_FS_End[3] + 17 )] = 'I020'
    set udg_DB_FS_Item[( udg_DB_FS_End[3] + 18 )] = 'I0A8'
    set udg_DB_FS_Item[( udg_DB_FS_End[3] + 19 )] = 'I05K'
    // Рой
    set udg_DB_FS_Name[5] = "Swarm"
    set udg_DB_FS_Start[5] = ( udg_DB_FS_End[4] + 1 )
    set udg_DB_FS_End[5] = ( udg_DB_FS_End[4] + 20 )
    set udg_DB_FS_Item[( udg_DB_FS_End[4] + 1 )] = 'I06Q'
    set udg_DB_FS_Item[( udg_DB_FS_End[4] + 2 )] = 'I0AX'
    set udg_DB_FS_Item[( udg_DB_FS_End[4] + 3 )] = 'I09E'
    set udg_DB_FS_Item[( udg_DB_FS_End[4] + 4 )] = 'I0B0'
    set udg_DB_FS_Item[( udg_DB_FS_End[4] + 5 )] = 'I04D'
    set udg_DB_FS_Item[( udg_DB_FS_End[4] + 6 )] = 'I0AE'
    set udg_DB_FS_Item[( udg_DB_FS_End[4] + 7 )] = 'I07W'
    set udg_DB_FS_Item[( udg_DB_FS_End[4] + 8 )] = 'I06T'
    set udg_DB_FS_Item[( udg_DB_FS_End[4] + 9 )] = 'I09U'
    set udg_DB_FS_Item[( udg_DB_FS_End[4] + 10 )] = 'I02I'
    set udg_DB_FS_Item[( udg_DB_FS_End[4] + 11 )] = 'I06W'
    set udg_DB_FS_Item[( udg_DB_FS_End[4] + 12 )] = 'I00Y'
    set udg_DB_FS_Item[( udg_DB_FS_End[4] + 13 )] = 'I026'
    set udg_DB_FS_Item[( udg_DB_FS_End[4] + 14 )] = 'I0BE'
    set udg_DB_FS_Item[( udg_DB_FS_End[4] + 15 )] = 'I040'
    set udg_DB_FS_Item[( udg_DB_FS_End[4] + 16 )] = 'I08D'
    set udg_DB_FS_Item[( udg_DB_FS_End[4] + 17 )] = 'I07S'
    set udg_DB_FS_Item[( udg_DB_FS_End[4] + 18 )] = 'I0AQ'
    set udg_DB_FS_Item[( udg_DB_FS_End[4] + 19 )] = 'I08J'
    set udg_DB_FS_Item[( udg_DB_FS_End[4] + 20 )] = 'I04A'
    // Игра со здоровьем
    set udg_DB_FS_Name[6] = "Play with health"
    set udg_DB_FS_Start[6] = ( udg_DB_FS_End[5] + 1 )
    set udg_DB_FS_End[6] = ( udg_DB_FS_End[5] + 13 )
    set udg_DB_FS_Item[( udg_DB_FS_End[5] + 1 )] = 'I0AK'
    set udg_DB_FS_Item[( udg_DB_FS_End[5] + 2 )] = 'I021'
    set udg_DB_FS_Item[( udg_DB_FS_End[5] + 3 )] = 'I09Q'
    set udg_DB_FS_Item[( udg_DB_FS_End[5] + 4 )] = 'I02M'
    set udg_DB_FS_Item[( udg_DB_FS_End[5] + 5 )] = 'I00Q'
    set udg_DB_FS_Item[( udg_DB_FS_End[5] + 6 )] = 'I013'
    set udg_DB_FS_Item[( udg_DB_FS_End[5] + 7 )] = 'I07N'
    set udg_DB_FS_Item[( udg_DB_FS_End[5] + 8 )] = 'I06H'
    set udg_DB_FS_Item[( udg_DB_FS_End[5] + 9 )] = 'I014'
    set udg_DB_FS_Item[( udg_DB_FS_End[5] + 10 )] = 'I09X'
    set udg_DB_FS_Item[( udg_DB_FS_End[5] + 11 )] = 'I06I'
    set udg_DB_FS_Item[( udg_DB_FS_End[5] + 12 )] = 'I07P'
    set udg_DB_FS_Item[( udg_DB_FS_End[5] + 13 )] = 'I0AL'
    // Безпредметник
    set udg_DB_FS_Name[7] = "No items"
    set udg_DB_FS_Start[7] = ( udg_DB_FS_End[6] + 1 )
    set udg_DB_FS_End[7] = ( udg_DB_FS_End[6] + 20 )
    set udg_DB_FS_Item[( udg_DB_FS_End[6] + 1 )] = 'I024'
    set udg_DB_FS_Item[( udg_DB_FS_End[6] + 2 )] = 'I0A1'
    set udg_DB_FS_Item[( udg_DB_FS_End[6] + 3 )] = 'I00H'
    set udg_DB_FS_Item[( udg_DB_FS_End[6] + 4 )] = 'I07H'
    set udg_DB_FS_Item[( udg_DB_FS_End[6] + 5 )] = 'I07R'
    set udg_DB_FS_Item[( udg_DB_FS_End[6] + 6 )] = 'I0B8'
    set udg_DB_FS_Item[( udg_DB_FS_End[6] + 7 )] = 'I0BE'
    set udg_DB_FS_Item[( udg_DB_FS_End[6] + 8 )] = 'I0BF'
    set udg_DB_FS_Item[( udg_DB_FS_End[6] + 9 )] = 'I00T'
    set udg_DB_FS_Item[( udg_DB_FS_End[6] + 10 )] = 'I00G'
    set udg_DB_FS_Item[( udg_DB_FS_End[6] + 11 )] = 'I0BA'
    set udg_DB_FS_Item[( udg_DB_FS_End[6] + 12 )] = 'I01T'
    set udg_DB_FS_Item[( udg_DB_FS_End[6] + 13 )] = 'I076'
    set udg_DB_FS_Item[( udg_DB_FS_End[6] + 14 )] = 'I04C'
    set udg_DB_FS_Item[( udg_DB_FS_End[6] + 15 )] = 'I06E'
    set udg_DB_FS_Item[( udg_DB_FS_End[6] + 16 )] = 'I0BD'
    set udg_DB_FS_Item[( udg_DB_FS_End[6] + 17 )] = 'I05Q'
    set udg_DB_FS_Item[( udg_DB_FS_End[6] + 18 )] = 'I08J'
    set udg_DB_FS_Item[( udg_DB_FS_End[6] + 19 )] = 'I0BB'
    set udg_DB_FS_Item[( udg_DB_FS_End[6] + 20 )] = 'I061'
    // Большие помощники
    set udg_DB_FS_Name[8] = "Great helpers"
    set udg_DB_FS_Start[8] = ( udg_DB_FS_End[7] + 1 )
    set udg_DB_FS_End[8] = ( udg_DB_FS_End[7] + 13 )
    set udg_DB_FS_Item[( udg_DB_FS_End[7] + 1 )] = 'I08J'
    set udg_DB_FS_Item[( udg_DB_FS_End[7] + 2 )] = 'I0AX'
    set udg_DB_FS_Item[( udg_DB_FS_End[7] + 3 )] = 'I06P'
    set udg_DB_FS_Item[( udg_DB_FS_End[7] + 4 )] = 'I09G'
    set udg_DB_FS_Item[( udg_DB_FS_End[7] + 5 )] = 'I04D'
    set udg_DB_FS_Item[( udg_DB_FS_End[7] + 6 )] = 'I02I'
    set udg_DB_FS_Item[( udg_DB_FS_End[7] + 7 )] = 'I06Q'
    set udg_DB_FS_Item[( udg_DB_FS_End[7] + 8 )] = 'I022'
    set udg_DB_FS_Item[( udg_DB_FS_End[7] + 9 )] = 'I0AO'
    set udg_DB_FS_Item[( udg_DB_FS_End[7] + 10 )] = 'I07S'
    set udg_DB_FS_Item[( udg_DB_FS_End[7] + 11 )] = 'I07O'
    set udg_DB_FS_Item[( udg_DB_FS_End[7] + 12 )] = 'I06C'
    // Заклинатель
    set udg_DB_FS_Name[9] = "Caster"
    set udg_DB_FS_Start[9] = ( udg_DB_FS_End[8] + 1 )
    set udg_DB_FS_End[9] = ( udg_DB_FS_End[8] + 21 )
    set udg_DB_FS_Item[( udg_DB_FS_End[8] + 1 )] = 'I07P'
    set udg_DB_FS_Item[( udg_DB_FS_End[8] + 2 )] = 'I023'
    set udg_DB_FS_Item[( udg_DB_FS_End[8] + 3 )] = 'I00L'
    set udg_DB_FS_Item[( udg_DB_FS_End[8] + 4 )] = 'I04B'
    set udg_DB_FS_Item[( udg_DB_FS_End[8] + 5 )] = 'I08B'
    set udg_DB_FS_Item[( udg_DB_FS_End[8] + 6 )] = 'I00D'
    set udg_DB_FS_Item[( udg_DB_FS_End[8] + 7 )] = 'I06F'
    set udg_DB_FS_Item[( udg_DB_FS_End[8] + 8 )] = 'I06H'
    set udg_DB_FS_Item[( udg_DB_FS_End[8] + 9 )] = 'I018'
    set udg_DB_FS_Item[( udg_DB_FS_End[8] + 10 )] = 'I04R'
    set udg_DB_FS_Item[( udg_DB_FS_End[8] + 11 )] = 'I00U'
    set udg_DB_FS_Item[( udg_DB_FS_End[8] + 12 )] = 'I04E'
    set udg_DB_FS_Item[( udg_DB_FS_End[8] + 13 )] = 'I040'
    set udg_DB_FS_Item[( udg_DB_FS_End[8] + 14 )] = 'I08K'
    set udg_DB_FS_Item[( udg_DB_FS_End[8] + 15 )] = 'I06J'
    set udg_DB_FS_Item[( udg_DB_FS_End[8] + 16 )] = 'I01X'
    set udg_DB_FS_Item[( udg_DB_FS_End[8] + 17 )] = 'I0B1'
    set udg_DB_FS_Item[( udg_DB_FS_End[8] + 18 )] = 'I01G'
    set udg_DB_FS_Item[( udg_DB_FS_End[8] + 19 )] = 'I00P'
    set udg_DB_FS_Item[( udg_DB_FS_End[8] + 20 )] = 'I07L'
    set udg_DB_FS_Item[( udg_DB_FS_End[8] + 21 )] = 'I031'
    // Поддержка
    set udg_DB_FS_Name[10] = "Support"
    set udg_DB_FS_Start[10] = ( udg_DB_FS_End[9] + 1 )
    set udg_DB_FS_End[10] = ( udg_DB_FS_End[9] + 18 )
    set udg_DB_FS_Item[( udg_DB_FS_End[9] + 1 )] = 'I0AJ'
    set udg_DB_FS_Item[( udg_DB_FS_End[9] + 2 )] = 'I09V'
    set udg_DB_FS_Item[( udg_DB_FS_End[9] + 3 )] = 'I06M'
    set udg_DB_FS_Item[( udg_DB_FS_End[9] + 4 )] = 'I048'
    set udg_DB_FS_Item[( udg_DB_FS_End[9] + 5 )] = 'I08O'
    set udg_DB_FS_Item[( udg_DB_FS_End[9] + 6 )] = 'I09M'
    set udg_DB_FS_Item[( udg_DB_FS_End[9] + 6 )] = 'I043'
    set udg_DB_FS_Item[( udg_DB_FS_End[9] + 7 )] = 'I018'
    set udg_DB_FS_Item[( udg_DB_FS_End[9] + 8 )] = 'I00L'
    set udg_DB_FS_Item[( udg_DB_FS_End[9] + 9 )] = 'I0AD'
    set udg_DB_FS_Item[( udg_DB_FS_End[9] + 10 )] = 'I08P'
    set udg_DB_FS_Item[( udg_DB_FS_End[9] + 11 )] = 'I02Y'
    set udg_DB_FS_Item[( udg_DB_FS_End[9] + 12 )] = 'I0B7'
    set udg_DB_FS_Item[( udg_DB_FS_End[9] + 13 )] = 'I00M'
    set udg_DB_FS_Item[( udg_DB_FS_End[9] + 14 )] = 'I078'
    set udg_DB_FS_Item[( udg_DB_FS_End[9] + 15 )] = 'I014'
    set udg_DB_FS_Item[( udg_DB_FS_End[9] + 16 )] = 'I06X'
    set udg_DB_FS_Item[( udg_DB_FS_End[9] + 17 )] = 'I0BC'
    set udg_DB_FS_Item[( udg_DB_FS_End[9] + 18 )] = 'I0B6'
    // Огромный удар
    set udg_DB_FS_Name[11] = "Huge punch"
    set udg_DB_FS_Start[11] = ( udg_DB_FS_End[10] + 1 )
    set udg_DB_FS_End[11] = ( udg_DB_FS_End[10] + 22 )
    set udg_DB_FS_Item[( udg_DB_FS_End[10] + 1 )] = 'I04E'
    set udg_DB_FS_Item[( udg_DB_FS_End[10] + 2 )] = 'I07P'
    set udg_DB_FS_Item[( udg_DB_FS_End[10] + 3 )] = 'I02X'
    set udg_DB_FS_Item[( udg_DB_FS_End[10] + 4 )] = 'I04W'
    set udg_DB_FS_Item[( udg_DB_FS_End[10] + 5 )] = 'I079'
    set udg_DB_FS_Item[( udg_DB_FS_End[10] + 6 )] = 'I000'
    set udg_DB_FS_Item[( udg_DB_FS_End[10] + 7 )] = 'I002'
    set udg_DB_FS_Item[( udg_DB_FS_End[10] + 8 )] = 'I001'
    set udg_DB_FS_Item[( udg_DB_FS_End[10] + 9 )] = 'I0A2'
    set udg_DB_FS_Item[( udg_DB_FS_End[10] + 10 )] = 'I00M'
    set udg_DB_FS_Item[( udg_DB_FS_End[10] + 11 )] = 'I09I'
    set udg_DB_FS_Item[( udg_DB_FS_End[10] + 12 )] = 'I07R'
    set udg_DB_FS_Item[( udg_DB_FS_End[10] + 13 )] = 'I0B8'
    set udg_DB_FS_Item[( udg_DB_FS_End[10] + 14 )] = 'I04R'
    set udg_DB_FS_Item[( udg_DB_FS_End[10] + 15 )] = 'I036'
    set udg_DB_FS_Item[( udg_DB_FS_End[10] + 16 )] = 'I00W'
    set udg_DB_FS_Item[( udg_DB_FS_End[10] + 17 )] = 'I0B2'
    set udg_DB_FS_Item[( udg_DB_FS_End[10] + 18 )] = 'I09H'
    set udg_DB_FS_Item[( udg_DB_FS_End[10] + 19 )] = 'I004'
    set udg_DB_FS_Item[( udg_DB_FS_End[10] + 19 )] = 'I0B1'
    set udg_DB_FS_Item[( udg_DB_FS_End[10] + 20 )] = 'I09K'
    set udg_DB_FS_Item[( udg_DB_FS_End[10] + 21 )] = 'I01G'
    set udg_DB_FS_Item[( udg_DB_FS_End[10] + 22 )] = 'I00P'
    // Умение
    set udg_DB_FS_Name[12] = "Uniques"
    set udg_DB_FS_Start[12] = ( udg_DB_FS_End[11] + 1 )
    set udg_DB_FS_End[12] = ( udg_DB_FS_End[11] + 16 )
    set udg_DB_FS_Item[( udg_DB_FS_End[11] + 1 )] = 'I00K'
    set udg_DB_FS_Item[( udg_DB_FS_End[11] + 2 )] = 'I00S'
    set udg_DB_FS_Item[( udg_DB_FS_End[11] + 3 )] = 'I07W'
    set udg_DB_FS_Item[( udg_DB_FS_End[11] + 4 )] = 'I06G'
    set udg_DB_FS_Item[( udg_DB_FS_End[11] + 5 )] = 'I07I'
    set udg_DB_FS_Item[( udg_DB_FS_End[11] + 6 )] = 'I0B7'
    set udg_DB_FS_Item[( udg_DB_FS_End[11] + 7 )] = 'I06R'
    set udg_DB_FS_Item[( udg_DB_FS_End[11] + 8 )] = 'I0A6'
    set udg_DB_FS_Item[( udg_DB_FS_End[11] + 9 )] = 'I01G'
    set udg_DB_FS_Item[( udg_DB_FS_End[11] + 10 )] = 'I03W'
    set udg_DB_FS_Item[( udg_DB_FS_End[11] + 11 )] = 'I04A'
    set udg_DB_FS_Item[( udg_DB_FS_End[11] + 12 )] = 'I017'
    set udg_DB_FS_Item[( udg_DB_FS_End[11] + 13 )] = 'I045'
    set udg_DB_FS_Item[( udg_DB_FS_End[11] + 14 )] = 'I0AP'
    set udg_DB_FS_Item[( udg_DB_FS_End[11] + 15 )] = 'I04N'
    set udg_DB_FS_Item[( udg_DB_FS_End[11] + 16 )] = 'I077'
    // Игра с маной
    set udg_DB_FS_Name[13] = "Play with mana"
    set udg_DB_FS_Start[13] = ( udg_DB_FS_End[12] + 1 )
    set udg_DB_FS_End[13] = ( udg_DB_FS_End[12] + 22 )
    set udg_DB_FS_Item[( udg_DB_FS_End[12] + 1 )] = 'I048'
    set udg_DB_FS_Item[( udg_DB_FS_End[12] + 2 )] = 'I0AB'
    set udg_DB_FS_Item[( udg_DB_FS_End[12] + 3 )] = 'I0A4'
    set udg_DB_FS_Item[( udg_DB_FS_End[12] + 4 )] = 'I01W'
    set udg_DB_FS_Item[( udg_DB_FS_End[12] + 5 )] = 'I0A2'
    set udg_DB_FS_Item[( udg_DB_FS_End[12] + 6 )] = 'I0AD'
    set udg_DB_FS_Item[( udg_DB_FS_End[12] + 7 )] = 'I07W'
    set udg_DB_FS_Item[( udg_DB_FS_End[12] + 8 )] = 'I015'
    set udg_DB_FS_Item[( udg_DB_FS_End[12] + 9 )] = 'I062'
    set udg_DB_FS_Item[( udg_DB_FS_End[12] + 10 )] = 'I08I'
    set udg_DB_FS_Item[( udg_DB_FS_End[12] + 11 )] = 'I07J'
    set udg_DB_FS_Item[( udg_DB_FS_End[12] + 12 )] = 'I040'
    set udg_DB_FS_Item[( udg_DB_FS_End[12] + 13 )] = 'I0A8'
    set udg_DB_FS_Item[( udg_DB_FS_End[12] + 14 )] = 'I09M'
    set udg_DB_FS_Item[( udg_DB_FS_End[12] + 15 )] = 'I07L'
    set udg_DB_FS_Item[( udg_DB_FS_End[12] + 16 )] = 'I00P'
    set udg_DB_FS_Item[( udg_DB_FS_End[12] + 17 )] = 'I06I'
    set udg_DB_FS_Item[( udg_DB_FS_End[12] + 18 )] = 'I09O'
    set udg_DB_FS_Item[( udg_DB_FS_End[12] + 19 )] = 'I0A9'
    set udg_DB_FS_Item[( udg_DB_FS_End[12] + 20 )] = 'I0AT'
    set udg_DB_FS_Item[( udg_DB_FS_End[12] + 21 )] = 'I0B0'
    set udg_DB_FS_Item[( udg_DB_FS_End[12] + 22 )] = 'I08K'
    // Механизм
    set udg_DB_FS_Name[14] = "Cyberpunk"
    set udg_DB_FS_Start[14] = ( udg_DB_FS_End[13] + 1 )
    set udg_DB_FS_End[14] = ( udg_DB_FS_End[13] + 17 )
    set udg_DB_FS_Item[( udg_DB_FS_End[13] + 1 )] = 'I08G'
    set udg_DB_FS_Item[( udg_DB_FS_End[13] + 2 )] = 'I0AX'
    set udg_DB_FS_Item[( udg_DB_FS_End[13] + 3 )] = 'I06M'
    set udg_DB_FS_Item[( udg_DB_FS_End[13] + 4 )] = 'I07X'
    set udg_DB_FS_Item[( udg_DB_FS_End[13] + 5 )] = 'I06Y'
    set udg_DB_FS_Item[( udg_DB_FS_End[13] + 6 )] = 'I07G'
    set udg_DB_FS_Item[( udg_DB_FS_End[13] + 7 )] = 'I040'
    set udg_DB_FS_Item[( udg_DB_FS_End[13] + 8 )] = 'I089'
    set udg_DB_FS_Item[( udg_DB_FS_End[13] + 9 )] = 'I02L'
    set udg_DB_FS_Item[( udg_DB_FS_End[13] + 10 )] = 'I02N'
    set udg_DB_FS_Item[( udg_DB_FS_End[13] + 11 )] = 'I08N'
    set udg_DB_FS_Item[( udg_DB_FS_End[13] + 12 )] = 'I028'
    set udg_DB_FS_Item[( udg_DB_FS_End[13] + 13 )] = 'I07V'
    set udg_DB_FS_Item[( udg_DB_FS_End[13] + 14 )] = 'I05K'
    set udg_DB_FS_Item[( udg_DB_FS_End[13] + 15 )] = 'I01V'
    set udg_DB_FS_Item[( udg_DB_FS_End[13] + 16 )] = 'I02I'
    set udg_DB_FS_Item[( udg_DB_FS_End[13] + 17 )] = 'I02V'
    // Игра со смертью
    set udg_DB_FS_Name[15] = "Play with life"
    set udg_DB_FS_Start[15] = ( udg_DB_FS_End[14] + 1 )
    set udg_DB_FS_End[15] = ( udg_DB_FS_End[14] + 15 )
    set udg_DB_FS_Item[( udg_DB_FS_End[14] + 1 )] = 'I074'
    set udg_DB_FS_Item[( udg_DB_FS_End[14] + 2 )] = 'I01A'
    set udg_DB_FS_Item[( udg_DB_FS_End[14] + 3 )] = 'I07K'
    set udg_DB_FS_Item[( udg_DB_FS_End[14] + 4 )] = 'I07E'
    set udg_DB_FS_Item[( udg_DB_FS_End[14] + 5 )] = 'I08C'
    set udg_DB_FS_Item[( udg_DB_FS_End[14] + 5 )] = 'I09N'
    set udg_DB_FS_Item[( udg_DB_FS_End[14] + 6 )] = 'I078'
    set udg_DB_FS_Item[( udg_DB_FS_End[14] + 7 )] = 'I0A6'
    set udg_DB_FS_Item[( udg_DB_FS_End[14] + 8 )] = 'I09Q'
    set udg_DB_FS_Item[( udg_DB_FS_End[14] + 9 )] = 'I043'
    set udg_DB_FS_Item[( udg_DB_FS_End[14] + 10 )] = 'I05U'
    set udg_DB_FS_Item[( udg_DB_FS_End[14] + 11 )] = 'I0AQ'
    set udg_DB_FS_Item[( udg_DB_FS_End[14] + 12 )] = 'I09R'
    set udg_DB_FS_Item[( udg_DB_FS_End[14] + 13 )] = 'I017'
    set udg_DB_FS_Item[( udg_DB_FS_End[14] + 14 )] = 'I073'
    set udg_DB_FS_Item[( udg_DB_FS_End[14] + 15 )] = 'I09K'
    // Рунный мастер
    set udg_DB_FS_Name[16] = "Runic Master"
    set udg_DB_FS_Start[16] = ( udg_DB_FS_End[15] + 1 )
    set udg_DB_FS_End[16] = ( udg_DB_FS_End[15] + 16 )
    set udg_DB_FS_Item[( udg_DB_FS_End[15] + 1 )] = 'I0AF'
    set udg_DB_FS_Item[( udg_DB_FS_End[15] + 2 )] = 'I02G'
    set udg_DB_FS_Item[( udg_DB_FS_End[15] + 3 )] = 'I00S'
    set udg_DB_FS_Item[( udg_DB_FS_End[15] + 4 )] = 'I00O'
    set udg_DB_FS_Item[( udg_DB_FS_End[15] + 5 )] = 'I02Z'
    set udg_DB_FS_Item[( udg_DB_FS_End[15] + 6 )] = 'I00M'
    set udg_DB_FS_Item[( udg_DB_FS_End[15] + 7 )] = 'I078'
    set udg_DB_FS_Item[( udg_DB_FS_End[15] + 8 )] = 'I09W'
    set udg_DB_FS_Item[( udg_DB_FS_End[15] + 9 )] = 'I0AJ'
    set udg_DB_FS_Item[( udg_DB_FS_End[15] + 10 )] = 'I00D'
    set udg_DB_FS_Item[( udg_DB_FS_End[15] + 11 )] = 'I00J'
    set udg_DB_FS_Item[( udg_DB_FS_End[15] + 12 )] = 'I00A'
    set udg_DB_FS_Item[( udg_DB_FS_End[15] + 13 )] = 'I06N'
    set udg_DB_FS_Item[( udg_DB_FS_End[15] + 14 )] = 'I00B'
    set udg_DB_FS_Item[( udg_DB_FS_End[15] + 15 )] = 'I00C'
    set udg_DB_FS_Item[( udg_DB_FS_End[15] + 16 )] = 'I09P'
    // Овцевод
    set udg_DB_FS_Name[17] = "Sheep farmer"
    set udg_DB_FS_Start[17] = ( udg_DB_FS_End[16] + 1 )
    set udg_DB_FS_End[17] = ( udg_DB_FS_End[16] + 20 )
    set udg_DB_FS_Item[( udg_DB_FS_End[16] + 1 )] = 'I023'
    set udg_DB_FS_Item[( udg_DB_FS_End[16] + 2 )] = 'I09G'
    set udg_DB_FS_Item[( udg_DB_FS_End[16] + 3 )] = 'I0AE'
    set udg_DB_FS_Item[( udg_DB_FS_End[16] + 4 )] = 'I06T'
    set udg_DB_FS_Item[( udg_DB_FS_End[16] + 5 )] = 'I00Y'
    set udg_DB_FS_Item[( udg_DB_FS_End[16] + 6 )] = 'I04Z'
    set udg_DB_FS_Item[( udg_DB_FS_End[16] + 7 )] = 'I01H'
    set udg_DB_FS_Item[( udg_DB_FS_End[16] + 8 )] = 'I0BE'
    set udg_DB_FS_Item[( udg_DB_FS_End[16] + 9 )] = 'I0BG'
    set udg_DB_FS_Item[( udg_DB_FS_End[16] + 10 )] = 'I0A5'
    set udg_DB_FS_Item[( udg_DB_FS_End[16] + 11 )] = 'I050'
    set udg_DB_FS_Item[( udg_DB_FS_End[16] + 12 )] = 'I0B3'
    set udg_DB_FS_Item[( udg_DB_FS_End[16] + 13 )] = 'I06X'
    set udg_DB_FS_Item[( udg_DB_FS_End[16] + 14 )] = 'I0A6'
    set udg_DB_FS_Item[( udg_DB_FS_End[16] + 15 )] = 'I017'
    set udg_DB_FS_Item[( udg_DB_FS_End[16] + 16 )] = 'I0B6'
    set udg_DB_FS_Item[( udg_DB_FS_End[16] + 17 )] = 'I01V'
    set udg_DB_FS_Item[( udg_DB_FS_End[16] + 18 )] = 'I00G'
    set udg_DB_FS_Item[( udg_DB_FS_End[16] + 19 )] = 'I04D'
    set udg_DB_FS_Item[( udg_DB_FS_End[16] + 20 )] = 'I026'
endfunction

//===========================================================================
function InitTrig_FastStart_Data takes nothing returns nothing
    set gg_trg_FastStart_Data = CreateTrigger(  )
    call TriggerAddAction( gg_trg_FastStart_Data, function Trig_FastStart_Data_Actions )
endfunction

