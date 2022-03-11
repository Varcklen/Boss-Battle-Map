function Trig_Freedom_of_Choice_Actions takes nothing returns nothing
    set udg_Database_NumberItems[2] = 1
    set DB_Items[2][1] = 'I02W'
    // a
    set udg_Database_NumberItems[3] = 1
    set DB_Items[3][1] = 'I02W'
endfunction

//===========================================================================
function InitTrig_Freedom_of_Choice takes nothing returns nothing
    set gg_trg_Freedom_of_Choice = CreateTrigger(  )
    call TriggerAddAction( gg_trg_Freedom_of_Choice, function Trig_Freedom_of_Choice_Actions )
endfunction

