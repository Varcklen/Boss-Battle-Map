function Trig_SheepIsGood_Actions takes nothing returns nothing
    set udg_Database_NumberItems[1] = 14
    set DB_Items[1][1] = 'I0AE'
    set DB_Items[1][2] = 'I06T'
    set DB_Items[1][3] = 'I064'
    set DB_Items[1][4] = 'I01H'
    set DB_Items[1][5] = 'I04Z'
    set DB_Items[1][6] = 'I00Y'
    set DB_Items[1][7] = 'I00V'
    set DB_Items[1][8] = 'I0BO'
    set DB_Items[1][9] = 'I06X'
    set DB_Items[1][10] = 'I0BE'
    set DB_Items[1][11] = 'I08V'
    set DB_Items[1][12] = 'I0EW'
    set DB_Items[1][13] = 'I0BG'
    set DB_Items[1][14] = 'I0EY'
    // a
    set udg_Database_NumberItems[2] = 3
    set DB_Items[2][1] = 'I0EX'
    set DB_Items[2][2] = 'I0B3'
    set DB_Items[2][3] = 'I0DE'
    // a
    set udg_Database_NumberItems[3] = 3
    set DB_Items[3][1] = 'I04L'
    set DB_Items[3][2] = 'I0A5'
    set DB_Items[3][3] = 'I06S'
endfunction

//===========================================================================
function InitTrig_SheepIsGood takes nothing returns nothing
    set gg_trg_SheepIsGood = CreateTrigger(  )
    call TriggerAddAction( gg_trg_SheepIsGood, function Trig_SheepIsGood_Actions )
endfunction

