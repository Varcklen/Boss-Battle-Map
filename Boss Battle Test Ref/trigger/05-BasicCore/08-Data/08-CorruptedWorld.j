function Trig_CorruptedWorld_Actions takes nothing returns nothing
    set udg_Database_NumberItems[1] = 26
    set DB_Items[1][1] = 'I0CE'
    set DB_Items[1][2] = 'I05X'
    set DB_Items[1][3] = 'I05Q'
    set DB_Items[1][4] = 'I02W'
    set DB_Items[1][5] = 'I065'
    set DB_Items[1][6] = 'I0B7'
    set DB_Items[1][7] = 'I0CS'
    set DB_Items[1][8] = 'I063'
    set DB_Items[1][9] = 'I0BO'
    set DB_Items[1][10] = 'I0EL'
    set DB_Items[1][11] = 'I0DD'
    set DB_Items[1][12] = 'I0BF'
    set DB_Items[1][13] = 'I08A'
    set DB_Items[1][14] = 'I0CB'
    set DB_Items[1][15] = 'I07R'
    set DB_Items[1][16] = 'I02C'
    set DB_Items[1][17] = 'I0BC'
    set DB_Items[1][18] = 'I0C1'
    set DB_Items[1][19] = 'I05Y'
    set DB_Items[1][20] = 'I0B8'
    set DB_Items[1][21] = 'I0EK'
    set DB_Items[1][22] = 'I0BE'
    set DB_Items[1][23] = 'I04G'
    set DB_Items[1][24] = 'I07R'
    set DB_Items[1][25] = 'I0B1'
    set DB_Items[1][26] = 'I0B6'
    // a
    set udg_Database_NumberItems[2] = 12
    set DB_Items[2][1] = 'I00H'
    set DB_Items[2][2] = 'I0CQ'
    set DB_Items[2][3] = 'I08N'
    set DB_Items[2][4] = 'I0BA'
    set DB_Items[2][5] = 'I0C7'
    set DB_Items[2][6] = 'I009'
    set DB_Items[2][7] = 'I0CA'
    set DB_Items[2][8] = 'I04C'
    set DB_Items[2][9] = 'I0BB'
    set DB_Items[2][10] = 'I0BD'
    set DB_Items[2][11] = 'I0AS'
    set DB_Items[2][12] = 'I0A7'
    // a
    set udg_Database_NumberItems[3] = 6
    set DB_Items[3][1] = 'I00T'
    set DB_Items[3][2] = 'I09S'
    set DB_Items[3][3] = 'I00G'
    set DB_Items[3][4] = 'I01U'
    set DB_Items[3][5] = 'I0E4'
    set DB_Items[3][6] = 'I07Z'
endfunction

//===========================================================================
function InitTrig_CorruptedWorld takes nothing returns nothing
    set gg_trg_CorruptedWorld = CreateTrigger(  )
    call TriggerAddAction( gg_trg_CorruptedWorld, function Trig_CorruptedWorld_Actions )
endfunction

