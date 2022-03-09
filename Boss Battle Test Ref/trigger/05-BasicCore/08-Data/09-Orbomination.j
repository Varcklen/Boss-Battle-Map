function Trig_Orbomination_Actions takes nothing returns nothing
    set udg_Database_NumberItems[1] = 7
    set DB_Items[1][1] = 'I08Y'
    set DB_Items[1][2] = 'I0EP'
    set DB_Items[1][3] = 'I08Z'
    set DB_Items[1][4] = 'I090'
    set DB_Items[1][5] = 'I0FJ'
    set DB_Items[1][6] = 'I0F0'
    set DB_Items[1][7] = 'I0FU'
    // a
    set udg_Database_NumberItems[2] = 7
    set DB_Items[2][1] = 'I08Y'
    set DB_Items[2][2] = 'I0EP'
    set DB_Items[2][3] = 'I08Z'
    set DB_Items[2][4] = 'I090'
    set DB_Items[2][5] = 'I0FJ'
    set DB_Items[2][6] = 'I0F0'
    set DB_Items[2][7] = 'I0FU'
    // a
    set udg_Database_NumberItems[3] = 7
    set DB_Items[3][1] = 'I08Y'
    set DB_Items[3][2] = 'I0EP'
    set DB_Items[3][3] = 'I08Z'
    set DB_Items[3][4] = 'I090'
    set DB_Items[3][5] = 'I0FJ'
    set DB_Items[3][6] = 'I0F0'
    set DB_Items[3][7] = 'I0FU'
endfunction

//===========================================================================
function InitTrig_Orbomination takes nothing returns nothing
    set gg_trg_Orbomination = CreateTrigger(  )
    call TriggerAddAction( gg_trg_Orbomination, function Trig_Orbomination_Actions )
endfunction

