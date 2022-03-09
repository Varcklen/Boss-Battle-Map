function Trig_Load_Conditions takes nothing returns boolean
    return SubString(GetEventPlayerChatString(), 0, 5) == "-load" and not( udg_logic[43] ) and not(udg_logic[1])
endfunction

function Trig_Load_Actions takes nothing returns nothing
    local integer i = GetPlayerId(GetTriggerPlayer()) + 1

    if (GetEventPlayerChatString() == "-load") then
        call Trig_Autoload_Actions()
    else
        call LoadProgress( i, GetEventPlayerChatString() )
        call BonusLoad(i)
    endif
endfunction

//===========================================================================
function InitTrig_Load takes nothing returns nothing
    local integer cyclA = 0
    set gg_trg_Load = CreateTrigger(  )
    loop
        exitwhen cyclA > 3
        call TriggerRegisterPlayerChatEvent( gg_trg_Load, Player(cyclA), "-load", false )
        set cyclA = cyclA + 1
    endloop
    call TriggerAddCondition( gg_trg_Load, Condition( function Trig_Load_Conditions ) )
    call TriggerAddAction( gg_trg_Load, function Trig_Load_Actions )
endfunction