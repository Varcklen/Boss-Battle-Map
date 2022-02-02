globals
    integer array Revent_Bonus_Reduction

    constant integer MODE_REVERT_BONUS_COUNT = 2
    constant integer MODE_REVERT_REDUCTION = 150
endglobals

function Trig_Revert_Conditions takes nothing returns boolean
    return udg_modgood[35]
endfunction

function Trig_Revert_Actions takes nothing returns nothing
    local integer i

    set i = 1
    loop
        exitwhen i > PLAYERS_LIMIT
        if udg_hero[i] != null then
            set Revent_Bonus_Reduction[i] = MODE_REVERT_BONUS_COUNT
            call BookOfOblivion_Change_Cost(Player(i-1), Book_Of_Oblivion_Cost[i] - MODE_REVERT_REDUCTION)
        endif
        set i = i + 1
    endloop
endfunction

//===========================================================================
function InitTrig_Revert takes nothing returns nothing
    set gg_trg_Revert = CreateTrigger(  )
    call TriggerRegisterVariableEvent( gg_trg_Revert, "Event_Mode_Awake_Real", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Revert, Condition( function Trig_Revert_Conditions ) )
    call TriggerAddAction( gg_trg_Revert, function Trig_Revert_Actions )
endfunction

scope Revert initializer Triggs
    private function Use takes nothing returns nothing
        local integer index = GetUnitUserData(Event_Book_Of_Oblivion_Used_Unit)
        local player ownPlayer = Player(IMaxBJ(index-1, 0))

        if index > 0 and Revent_Bonus_Reduction[index] > 0 then
            set Revent_Bonus_Reduction[index] = Revent_Bonus_Reduction[index] - 1
            if Revent_Bonus_Reduction[index] <= 0 then
                call BookOfOblivion_Change_Cost(ownPlayer, Book_Of_Oblivion_Cost[index] + MODE_REVERT_REDUCTION)
            endif
        endif

        set ownPlayer = null
    endfunction

    private function Triggs takes nothing returns nothing
        local trigger trig = CreateTrigger()
        
        call TriggerRegisterVariableEvent( trig, "Event_Book_Of_Oblivion_Used_Real", EQUAL, 1.00 )
        call TriggerAddAction( trig, function Use)
        
        set trig = null
    endfunction
endscope

