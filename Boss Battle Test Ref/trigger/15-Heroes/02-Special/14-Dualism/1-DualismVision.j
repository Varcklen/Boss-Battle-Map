function Trig_DualismVision_Actions takes nothing returns nothing
    if GetUnitAbilityLevel(GetTriggerUnit(), 'A1BK') > 0 and GetTriggerPlayer() == GetOwningPlayer(GetTriggerUnit()) then
        if GetLocalPlayer() == GetTriggerPlayer() then
            call BlzFrameSetVisible( dualtext, true )
            call BlzFrameSetText( dualtext, I2S(LoadInteger( udg_hash, GetHandleId( GetTriggerUnit() ), StringHash( "dualch" ) )) )
        endif
    else
        if GetLocalPlayer() == GetTriggerPlayer() then
            call BlzFrameSetVisible( dualtext, false )
        endif
    endif
endfunction

//===========================================================================
function InitTrig_DualismVision takes nothing returns nothing
    local integer i = 0
    set gg_trg_DualismVision = CreateTrigger()
    loop
        exitwhen i > 3
        call TriggerRegisterPlayerSelectionEventBJ( gg_trg_DualismVision, Player(i), true )
        set i = i + 1
    endloop
    call TriggerAddAction( gg_trg_DualismVision, function Trig_DualismVision_Actions )
endfunction

