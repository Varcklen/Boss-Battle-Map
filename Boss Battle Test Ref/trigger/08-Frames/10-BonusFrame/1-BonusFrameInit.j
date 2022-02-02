function Trig_BonusFrameInit_Actions takes nothing returns nothing
    local integer cyclA = 1
    local integer cyclAEnd = udg_DB_BonusFrame_Number

    loop
        exitwhen cyclA > cyclAEnd
        call CreateIcon(cyclA)
        set cyclA = cyclA + 1
    endloop
endfunction

//===========================================================================
function InitTrig_BonusFrameInit takes nothing returns nothing
    set gg_trg_BonusFrameInit = CreateTrigger(  )
    call TriggerAddAction( gg_trg_BonusFrameInit, function Trig_BonusFrameInit_Actions )
endfunction

