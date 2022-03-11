function Trig_QuestChoose_Conditions takes nothing returns boolean
    return not(udg_fightmod[0])
endfunction

function Trig_QuestChoose_Actions takes nothing returns nothing
    local player p = GetTriggerPlayer()

    if GetUnitTypeId(GetTriggerUnit()) == 'h00P' then
        if udg_QuestLimit[GetPlayerId( p ) + 1] then
            call DisplayTimedTextToPlayer( p, 0, 0, 5, "You have already chosen the quest. You can't take another one.")
        else
            if GetLocalPlayer() == p then
                call BlzFrameSetVisible( modesback, false )
                call BlzFrameSetVisible( quartback, true )
            endif
        endif
    else
        if GetLocalPlayer() == p then
            call BlzFrameSetVisible( quartback, false )
        endif
    endif
    
    set p = null
endfunction

//===========================================================================
function InitTrig_QuestChoose takes nothing returns nothing
    local integer i = 0
    set gg_trg_QuestChoose = CreateTrigger()
    loop
        exitwhen i > 3
        call TriggerRegisterPlayerSelectionEventBJ( gg_trg_QuestChoose, Player(i), true )
        set i = i + 1
    endloop
    call TriggerAddCondition( gg_trg_QuestChoose, Condition( function Trig_QuestChoose_Conditions ) )
    call TriggerAddAction( gg_trg_QuestChoose, function Trig_QuestChoose_Actions )
endfunction

