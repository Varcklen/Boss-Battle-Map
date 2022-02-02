globals
    constant integer MODE_TRIAD_SETS = 3
    constant integer MODE_TRIAD_PIECES_TO_ADD = 1
endglobals

function Trig_Triad_Conditions takes nothing returns boolean
    return udg_modgood[34]
endfunction

function Trig_Triad_Actions takes nothing returns nothing
    local integer i
    local integer k
    local integer rand
    local integer array numberArray
    local integer numberMaxSize
    local integer array sets
    local string extraText = ""
    local integer iconPosition
    
    set numberMaxSize = SETS_COUNT
    set i = 1
    loop
        exitwhen i > SETS_COUNT
        set numberArray[i] = i
        set sets[i] = 0
        set i = i + 1
    endloop
    
    set i = 1
    loop
        exitwhen i > MODE_TRIAD_SETS
        set rand = GetRandomInt(1, numberMaxSize)
        set sets[i] = numberArray[rand]
        
        set numberArray[rand] = numberArray[numberMaxSize]
        set numberMaxSize = numberMaxSize - 1
        set i = i + 1
    endloop
    
    if sets[1] == 0 or sets[2] == 0 or sets[3] == 0 then
        call BJDebugMsg("\"Triad\" blessing is not working correctly. Please report this to the developer. (" + I2S(sets[1]) + " " + I2S(sets[2]) + " " + I2S(sets[3]) + ").")
        return
    endif
    
    set i = 1
    loop
        exitwhen i > MODE_TRIAD_SETS
        set k = 1
        loop
            exitwhen k > PLAYERS_LIMIT
            if udg_hero[k] != null then
                call SetCount_AddPiece( udg_hero[k], sets[i], MODE_TRIAD_PIECES_TO_ADD )
            endif
            set k = k + 1
        endloop
        set extraText = extraText + " " + SetCount_GetSetName( sets[i] )
        set i = i + 1
    endloop
    
    set iconPosition = GetIconFrameNumberByKey("ModGood34")
    
    if iconPosition != -1 then
        call IconFrameReplaceDescription("ModGood34", BlzFrameGetText(bonustxt[iconPosition]) + extraText )
    endif
endfunction

//===========================================================================
function InitTrig_Triad takes nothing returns nothing
    set gg_trg_Triad = CreateTrigger(  )
    call TriggerRegisterVariableEvent( gg_trg_Triad, "Event_Mode_Awake_Real", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Triad, Condition( function Trig_Triad_Conditions ) )
    call TriggerAddAction( gg_trg_Triad, function Trig_Triad_Actions )
endfunction

