function Trig_ModesChoosing_Conditions takes nothing returns boolean
    return udg_fightmod[0] == false
endfunction

function Trig_ModesChoosing_Actions takes nothing returns nothing
    //МОЖЕТ ВЫЗВАТЬ DESYNC! НУЖНО ПРОТЕСТИРОВАТЬ!
    if GetLocalPlayer() == GetTriggerPlayer() and BlzFrameIsVisible( modesback ) then
        call BlzFrameSetVisible( modesback, false )
    endif
endfunction

//===========================================================================
function InitTrig_ModesChoosing takes nothing returns nothing
    local integer i = 0
    set gg_trg_ModesChoosing = CreateTrigger()
    loop
        exitwhen i > 3
        call TriggerRegisterPlayerSelectionEventBJ( gg_trg_ModesChoosing, Player(i), true )
        set i = i + 1
    endloop
    call TriggerAddCondition( gg_trg_ModesChoosing, Condition( function Trig_ModesChoosing_Conditions ) )
    call TriggerAddAction( gg_trg_ModesChoosing, function Trig_ModesChoosing_Actions )
endfunction

