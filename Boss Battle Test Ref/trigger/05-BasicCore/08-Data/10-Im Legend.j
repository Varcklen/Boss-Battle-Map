function Trig_Im_Legend_Actions takes nothing returns nothing
    set udg_base = 0
    set DB_Items[1][BaseNum()] = 'I04L'
    set DB_Items[1][BaseNum()] = 'I00T'
    set DB_Items[1][BaseNum()] = 'I040'
    set DB_Items[1][BaseNum()] = 'I04T'
    set DB_Items[1][BaseNum()] = 'I020'
    set DB_Items[1][BaseNum()] = 'I0BL'
    set DB_Items[1][BaseNum()] = 'I05U'
    set DB_Items[1][BaseNum()] = 'I00G'
    set DB_Items[1][BaseNum()] = 'I00W'
    set DB_Items[1][BaseNum()] = 'I06S'
    set DB_Items[1][BaseNum()] = 'I01L'
    set DB_Items[1][BaseNum()] = 'I070'
    set DB_Items[1][BaseNum()] = 'I02S'
    set DB_Items[1][BaseNum()] = 'I05I'
    set DB_Items[1][BaseNum()] = 'I089'
    set DB_Items[1][BaseNum()] = 'I0AR'
    set DB_Items[1][BaseNum()] = 'I06C'
    set DB_Items[1][BaseNum()] = 'I07Z'
    set DB_Items[1][BaseNum()] = 'I0D3'
    set DB_Items[1][BaseNum()] = 'I0A5'
    set DB_Items[1][BaseNum()] = 'I0E3'
    set DB_Items[1][BaseNum()] = 'I08T'
    set DB_Items[1][BaseNum()] = 'I052'
    set DB_Items[1][BaseNum()] = 'I0DG'
    set DB_Items[1][BaseNum()] = 'I01J'
    set DB_Items[1][BaseNum()] = 'I0C6'
    set DB_Items[1][BaseNum()] = 'I0DV'
    set DB_Items[1][BaseNum()] = 'I0C2'
    set DB_Items[1][BaseNum()] = 'I0D7'
    set DB_Items[1][BaseNum()] = 'I012'
    set DB_Items[1][BaseNum()] = 'I083'
    set DB_Items[1][BaseNum()] = 'I0FI'
    set DB_Items[1][BaseNum()] = 'I09S'
    set DB_Items[1][BaseNum()] = 'I0D9'
    set DB_Items[1][BaseNum()] = 'I0E4'
    set DB_Items[1][BaseNum()] = 'I0DI'
    set DB_Items[1][BaseNum()] = 'I01U'
    set DB_Items[1][BaseNum()] = 'I0D2'
    set DB_Items[1][BaseNum()] = 'I0D6'
    set DB_Items[1][BaseNum()] = 'I0EN'
    set DB_Items[1][BaseNum()] = 'I0FB'
    set DB_Items[1][BaseNum()] = 'I0FG'
    set udg_Database_NumberItems[1] = udg_base
    
    // a
    set udg_base = 0
    set DB_Items[2][BaseNum()] = 'I06K'
    set DB_Items[2][BaseNum()] = 'I0F8'
    set DB_Items[2][BaseNum()] = 'I003'
    set DB_Items[2][BaseNum()] = 'I02R'
    set DB_Items[2][BaseNum()] = 'I0F2'
    set DB_Items[2][BaseNum()] = 'I0ES'
    set DB_Items[2][BaseNum()] = 'I0EQ'
    set DB_Items[2][BaseNum()] = 'I0F1'
    set DB_Items[2][BaseNum()] = 'I0FO'
    set DB_Items[2][BaseNum()] = 'I0FL'
    set DB_Items[2][BaseNum()] = 'I0G1'
    set DB_Items[2][BaseNum()] = 'I0AH'
    set DB_Items[2][BaseNum()] = 'I0G0'
    set DB_Items[2][BaseNum()] = 'I0FN'
    set DB_Items[2][BaseNum()] = 'I0DF'
    set DB_Items[2][BaseNum()] = 'I0DK'
    set DB_Items[2][BaseNum()] = 'I0AN'
    set DB_Items[2][BaseNum()] = 'I0FV'
    set DB_Items[2][BaseNum()] = 'I0FM'
    set DB_Items[2][BaseNum()] = 'I091'
    set DB_Items[2][BaseNum()] = 'I0FK'
    set DB_Items[2][BaseNum()] = 'I0FW'
    set DB_Items[2][BaseNum()] = 'I0ER'
    set DB_Items[2][BaseNum()] = 'I0F4'
    set DB_Items[2][BaseNum()] = 'I0FX'
    set DB_Items[2][BaseNum()] = 'I0F3'
    set DB_Items[2][BaseNum()] = 'I0FZ'
    set DB_Items[2][BaseNum()] = 'I0DJ'
    set DB_Items[2][BaseNum()] = 'I0F5'
    set DB_Items[2][BaseNum()] = 'I0FY'
    set DB_Items[2][BaseNum()] = 'I0ET'
    set DB_Items[2][BaseNum()] = 'I0FP'
    set udg_Database_NumberItems[2] = udg_base
    // a
    set udg_base = 0
    set DB_Items[3][BaseNum()] = 'I03G'
    set DB_Items[3][BaseNum()] = 'I03D'
    set DB_Items[3][BaseNum()] = 'I0BY'
    set DB_Items[3][BaseNum()] = 'I08X'
    set DB_Items[3][BaseNum()] = 'I092'
    set DB_Items[3][BaseNum()] = 'I03I'
    set DB_Items[3][BaseNum()] = 'I094'
    set DB_Items[3][BaseNum()] = 'I0C0'
    set DB_Items[3][BaseNum()] = 'I03F'
    set DB_Items[3][BaseNum()] = 'I0BZ'
    set DB_Items[3][BaseNum()] = 'I03E'
    set DB_Items[3][BaseNum()] = 'I093'
    set DB_Items[3][BaseNum()] = 'I03H'
    set DB_Items[3][BaseNum()] = 'I0EV'
    set DB_Items[3][BaseNum()] = 'I08S'
    set DB_Items[3][BaseNum()] = 'I0EZ'
    set DB_Items[3][BaseNum()] = 'I0EJ'
    set udg_Database_NumberItems[3] = udg_base
endfunction

//===========================================================================
function InitTrig_Im_Legend takes nothing returns nothing
    set gg_trg_Im_Legend = CreateTrigger(  )
    call TriggerAddAction( gg_trg_Im_Legend, function Trig_Im_Legend_Actions )
endfunction

