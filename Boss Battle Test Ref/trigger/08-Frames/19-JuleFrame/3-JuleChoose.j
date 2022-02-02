function Trig_JuleChoose_Conditions takes nothing returns boolean
    return not(udg_fightmod[0])
endfunction

function Trig_JuleChoose_Actions takes nothing returns nothing
	local player pl = GetTriggerPlayer()

    if GetUnitTypeId(GetTriggerUnit()) == 'h01G' then
        if GetLocalPlayer() == pl then
            //call BlzFrameSetVisible( specback, false )
            call BlzFrameSetVisible( modesback, false )
            //call BlzFrameSetVisible( quartback, false )
            call BlzFrameSetVisible( juleback, true )
        endif
    else
        if GetLocalPlayer() == pl then
            call BlzFrameSetVisible( juleback, false )
        endif
    endif

	set pl = null
endfunction

//===========================================================================
function InitTrig_JuleChoose takes nothing returns nothing
    local integer i = 0
    set gg_trg_JuleChoose = CreateTrigger()
    loop
        exitwhen i > 3
        call TriggerRegisterPlayerSelectionEventBJ( gg_trg_JuleChoose, Player(i), true )
        set i = i + 1
    endloop
    call TriggerAddCondition( gg_trg_JuleChoose, Condition( function Trig_JuleChoose_Conditions ) )
    call TriggerAddAction( gg_trg_JuleChoose, function Trig_JuleChoose_Actions )
endfunction

