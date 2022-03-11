function Trig_MerryCristmas_Actions takes nothing returns nothing
    set udg_Database_NumberItems[1] = 14
    set DB_Items[1][1] = 'I05N'
    set DB_Items[1][2] = 'I05G'
    set DB_Items[1][3] = 'I0CL'
    set DB_Items[1][4] = 'I06Y'
    set DB_Items[1][5] = 'I04V'
    set DB_Items[1][6] = 'I0A1'
    set DB_Items[1][7] = 'I03Q'
    set DB_Items[1][8] = 'I0BG'
    set DB_Items[1][9] = 'I04N'
    set DB_Items[1][10] = 'I04M'
    set DB_Items[1][11] = 'I03X'
    set DB_Items[1][12] = 'I065'
    set DB_Items[1][13] = 'I063'
    set DB_Items[1][14] = 'I02W'
    set udg_Database_NumberItems[2] = 14
    set DB_Items[2][1] = 'I05N'
    set DB_Items[2][2] = 'I05G'
    set DB_Items[2][3] = 'I0CL'
    set DB_Items[2][4] = 'I06Y'
    set DB_Items[2][5] = 'I04V'
    set DB_Items[2][6] = 'I0A1'
    set DB_Items[2][7] = 'I03Q'
    set DB_Items[2][8] = 'I0BG'
    set DB_Items[2][9] = 'I04N'
    set DB_Items[2][10] = 'I04M'
    set DB_Items[2][11] = 'I03X'
    set DB_Items[2][12] = 'I065'
    set DB_Items[2][13] = 'I063'
    set DB_Items[2][14] = 'I02W'
    set udg_Database_NumberItems[3] = 14
    set DB_Items[3][1] = 'I05N'
    set DB_Items[3][2] = 'I05G'
    set DB_Items[3][3] = 'I0CL'
    set DB_Items[3][4] = 'I06Y'
    set DB_Items[3][5] = 'I04V'
    set DB_Items[3][6] = 'I0A1'
    set DB_Items[3][7] = 'I03Q'
    set DB_Items[3][8] = 'I0BG'
    set DB_Items[3][9] = 'I04N'
    set DB_Items[3][10] = 'I04M'
    set DB_Items[3][11] = 'I03X'
    set DB_Items[3][12] = 'I065'
    set DB_Items[3][13] = 'I063'
    set DB_Items[3][14] = 'I02W'
endfunction

//===========================================================================
function InitTrig_MerryCristmas takes nothing returns nothing
    set gg_trg_MerryCristmas = CreateTrigger(  )
    call TriggerAddAction( gg_trg_MerryCristmas, function Trig_MerryCristmas_Actions )
endfunction

