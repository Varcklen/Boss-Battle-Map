function Trig_MasterDisguise_Actions takes nothing returns nothing
    set udg_Database_NumberItems[1] = 1
    set DB_Items[1][1] = 'I023'
    set udg_Database_NumberItems[2] = 1
    set DB_Items[2][1] = 'I023'
    set udg_Database_NumberItems[3] = 1
    set DB_Items[3][1] = 'I023'
endfunction

//===========================================================================
function InitTrig_MasterDisguise takes nothing returns nothing
    set gg_trg_MasterDisguise = CreateTrigger(  )
    call TriggerAddAction( gg_trg_MasterDisguise, function Trig_MasterDisguise_Actions )
endfunction

