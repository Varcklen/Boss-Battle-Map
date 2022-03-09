function Trig_Cam_Conditions takes nothing returns boolean
    return udg_hero[GetPlayerId(GetTriggerPlayer()) + 1] != null and SubString(GetEventPlayerChatString(), 0, 4) == "-cam"
endfunction

function Trig_Cam_Actions takes nothing returns nothing
    local integer i
    local real r = 1500
    
    if S2I(SubString(GetEventPlayerChatString(), 5, 6)) >= 1 and S2I(SubString(GetEventPlayerChatString(), 5, 6)) <= 5 then
        set i = S2I(SubString(GetEventPlayerChatString(), 5, 6))
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
function InitTrig_Cam takes nothing returns nothing
    local integer cyclA = 0
    set gg_trg_Cam = CreateTrigger(  )
    loop
        exitwhen cyclA > 3
        call TriggerRegisterPlayerChatEvent( gg_trg_Cam, Player(cyclA), "-cam ", false )
        set cyclA = cyclA + 1
    endloop
    call TriggerAddCondition( gg_trg_Cam, Condition( function Trig_Cam_Conditions ) )
    call TriggerAddAction( gg_trg_Cam, function Trig_Cam_Actions )
endfunction

