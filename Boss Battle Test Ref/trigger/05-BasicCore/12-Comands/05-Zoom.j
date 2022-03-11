function Trig_Zoom_Conditions takes nothing returns boolean
    return udg_hero[GetPlayerId(GetTriggerPlayer()) + 1] != null and SubString(GetEventPlayerChatString(), 0, 5) == "-zoom"
endfunction

function Trig_Zoom_Actions takes nothing returns nothing
    local integer i
    local real r = 1500
    
    if S2I(SubString(GetEventPlayerChatString(), 6, 7)) >= 1 and S2I(SubString(GetEventPlayerChatString(), 6, 7)) <= 5 then
        set i = S2I(SubString(GetEventPlayerChatString(), 6, 7))
        if i == 1 then
            set r = 2000
        elseif i == 2 then
            set r = 2225
        elseif i == 3 then
            set r = 2500
        elseif i == 4 then
            set r = 3000
        elseif i == 5 then
            set r = 3500
        endif
        if GetLocalPlayer() == GetTriggerPlayer() then
            call SetCameraField(CAMERA_FIELD_TARGET_DISTANCE, r, 0.25)
        endif
    endif
endfunction

//===========================================================================
function InitTrig_Zoom takes nothing returns nothing
    local integer cyclA = 0
    set gg_trg_Zoom = CreateTrigger(  )
    loop
        exitwhen cyclA > 3
        call TriggerRegisterPlayerChatEvent( gg_trg_Zoom, Player(cyclA), "-zoom ", false )
        set cyclA = cyclA + 1
    endloop
    call TriggerAddCondition( gg_trg_Zoom, Condition( function Trig_Zoom_Conditions ) )
    call TriggerAddAction( gg_trg_Zoom, function Trig_Zoom_Actions )
endfunction

