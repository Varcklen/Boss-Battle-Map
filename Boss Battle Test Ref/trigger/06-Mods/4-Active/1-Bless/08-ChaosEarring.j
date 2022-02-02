scope ChaosEarring initializer Triggs
    globals 
        private integer count = 0
    endglobals 

    private function ChaosEarring_Conditions takes nothing returns boolean
        return udg_modgood[16] and not( udg_fightmod[3] )
    endfunction

    private function UniqueChange takes integer k returns nothing
        local integer i = 1
        loop
            exitwhen i > 4
            if udg_hero[i] != null then
                call skillst( i, k )
            endif
            set i = i + 1
        endloop
    endfunction

    private function ChaosEarring_Actions takes nothing returns nothing
        set count = count + 1
        if count >= 3 then
            call UniqueChange(1)
        endif
    endfunction

    private function ChaosEarringEnd_Conditions takes nothing returns boolean
        return udg_modgood[16] and count >= 3
    endfunction

    private function ChaosEarringEnd_Actions takes nothing returns nothing
        call UniqueChange(-1)
        set count = 0
    endfunction

    private function Triggs takes nothing returns nothing
        local trigger trig = CreateTrigger()
        call TriggerRegisterVariableEvent( trig, "udg_FightStartGlobal_Real", EQUAL, 1.00 )
        call TriggerAddCondition( trig, Condition( function ChaosEarring_Conditions ) )
        call TriggerAddAction( trig, function ChaosEarring_Actions )
        
        set trig = CreateTrigger()
        call TriggerRegisterVariableEvent( trig, "udg_FightEndGlobal_Real", EQUAL, 1.00 )
        call TriggerAddCondition( trig, Condition( function ChaosEarringEnd_Conditions ) )
        call TriggerAddAction( trig, function ChaosEarringEnd_Actions )
        
        set trig = null
    endfunction
endscope