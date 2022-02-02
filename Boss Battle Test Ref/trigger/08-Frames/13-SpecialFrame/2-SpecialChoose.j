function Trig_SpecialChoose_Conditions takes nothing returns boolean
    return not(udg_fightmod[0])
endfunction

function Trig_SpecialChoose_Actions takes nothing returns nothing
	local player pl = GetTriggerPlayer()

    if GetUnitTypeId(GetTriggerUnit()) == 'h027' then
        if GetLocalPlayer() == pl then
            //call BlzFrameSetVisible( quartback, false )
            call BlzFrameSetVisible( modesback, false )
            //call BlzFrameSetVisible( juleback, false )
            call BlzFrameSetVisible( specback, true )
        endif
    else
        if GetLocalPlayer() == pl then
            call BlzFrameSetVisible( specback, false )
        endif
    endif

	set pl = null
endfunction

//===========================================================================
function InitTrig_SpecialChoose takes nothing returns nothing
    local integer i = 0
    set gg_trg_SpecialChoose = CreateTrigger()
    loop
        exitwhen i > 3
        call TriggerRegisterPlayerSelectionEventBJ( gg_trg_SpecialChoose, Player(i), true )
        set i = i + 1
    endloop
    call TriggerAddCondition( gg_trg_SpecialChoose, Condition( function Trig_SpecialChoose_Conditions ) )
    call TriggerAddAction( gg_trg_SpecialChoose, function Trig_SpecialChoose_Actions )
endfunction

