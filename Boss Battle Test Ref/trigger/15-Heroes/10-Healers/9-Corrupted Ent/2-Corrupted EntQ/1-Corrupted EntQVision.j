function Trig_Corrupted_EntQVision_Actions takes nothing returns nothing
    if GetUnitAbilityLevel(GetTriggerUnit(), 'A0OE') > 0 and GetTriggerPlayer() == GetOwningPlayer(GetTriggerUnit()) then
        if GetLocalPlayer() == GetTriggerPlayer() then
            call BlzFrameSetVisible( entQBackdrop, true )
            call BlzFrameSetText( entQText, I2S(LoadInteger( udg_hash, GetHandleId( GetTriggerUnit() ), StringHash( "entqch" ) )) )
        endif
    else
        if GetLocalPlayer() == GetTriggerPlayer() then
            call BlzFrameSetVisible( entQBackdrop, false )
        endif
    endif
endfunction

//===========================================================================
function InitTrig_Corrupted_EntQVision takes nothing returns nothing
    local integer i = 0
    set gg_trg_Corrupted_EntQVision = CreateTrigger()
    loop
        exitwhen i > 3
        call TriggerRegisterPlayerSelectionEventBJ( gg_trg_Corrupted_EntQVision, Player(i), true )
        set i = i + 1
    endloop
    call TriggerAddAction( gg_trg_Corrupted_EntQVision, function Trig_Corrupted_EntQVision_Actions )
endfunction

