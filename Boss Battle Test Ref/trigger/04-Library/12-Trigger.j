library Trigger

    globals
        private trigger trig = null
    endglobals

    function CreateEventTrigger takes string eventReal, code action, code condition returns trigger
        set trig = CreateTrigger()
        call TriggerRegisterVariableEvent( trig, eventReal, EQUAL, 1.00 )
        if condition != null then
            call TriggerAddCondition( trig, Condition( condition ) )
        endif
        if action != null then
            call TriggerAddAction( trig, action )
        endif
        return trig
    endfunction

endlibrary