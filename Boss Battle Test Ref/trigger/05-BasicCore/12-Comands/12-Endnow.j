function Trig_Endnow_Conditions takes nothing returns boolean
    return (udg_fightmod[2] or udg_fightmod[4]) and GetTriggerPlayer() == udg_Host
endfunction

function Trig_Endnow_Actions takes nothing returns nothing
    if udg_fightmod[2] then
            call Between( "end_IA" )
    elseif udg_fightmod[4] then
        call Between( "end_AL" )
    endif
endfunction

//===========================================================================
function InitTrig_Endnow takes nothing returns nothing
    local integer cyclA = 0
    set gg_trg_Endnow = CreateTrigger()
    loop
        exitwhen cyclA > 3
        call TriggerRegisterPlayerChatEvent( gg_trg_Endnow, Player(cyclA), "-endnow", true )
        set cyclA = cyclA + 1
    endloop
    call TriggerAddCondition( gg_trg_Endnow, Condition( function Trig_Endnow_Conditions ) )
    call TriggerAddAction( gg_trg_Endnow, function Trig_Endnow_Actions )
endfunction