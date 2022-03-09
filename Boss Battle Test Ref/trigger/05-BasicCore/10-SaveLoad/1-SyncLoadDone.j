function Trig_SyncLoadDone_Actions takes nothing returns nothing
    local string prefix = BlzGetTriggerSyncPrefix()
    local string value = BlzGetTriggerSyncData()
    local integer i = GetPlayerId(GetTriggerPlayer()) + 1
    
    if prefix == "myprefix" then
        set udg_LoadCode[i] = value
    endif
endfunction

//===========================================================================
function InitTrig_SyncLoadDone takes nothing returns nothing
    local integer i = 0
    set gg_trg_SyncLoadDone = CreateTrigger(  )

    loop
        call BlzTriggerRegisterPlayerSyncEvent(gg_trg_SyncLoadDone, Player(i), "myprefix", false)
        //call BlzTriggerRegisterPlayerSyncEvent(gg_trg_SyncLoadDone, Player(i), "lvl", false)
        set i = i + 1
        exitwhen i == 4
    endloop
    call TriggerAddAction(gg_trg_SyncLoadDone, function Trig_SyncLoadDone_Actions)
endfunction

