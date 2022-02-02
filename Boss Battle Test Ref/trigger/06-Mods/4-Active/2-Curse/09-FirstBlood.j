scope FirstBlood initializer init

    globals
        private constant integer EFFECT = 'A1D0'
        private constant integer BUFF = 'B0AA'
    endglobals

    private function FightStart_Conditions takes nothing returns boolean
        return udg_modbad[30]
    endfunction

    private function FightStart takes nothing returns nothing
        call UnitAddAbility(udg_FightStart_Unit, EFFECT)
    endfunction
    
    
    private function FightEnd_Conditions takes nothing returns boolean
        return IsUnitHasAbility(udg_FightEnd_Unit, EFFECT)
    endfunction
    
    private function FightEnd takes nothing returns nothing
        call UnitRemoveAbility(udg_FightEnd_Unit, EFFECT)
    endfunction
    
    
    private function AfterHealChange_Conditions takes nothing returns boolean
        return IsUnitHasAbility(Event_AfterHealChange_Target, EFFECT) and Event_AfterHealChange_Heal > 0 and IsUnitHealthIsFull(Event_AfterHealChange_Target) == false
    endfunction
    
    private function AfterHealChange takes nothing returns nothing
        set Event_AfterHealChange_Heal = 0
        call UnitRemoveAbility(Event_AfterHealChange_Target, EFFECT)
        call UnitRemoveAbility(Event_AfterHealChange_Target, BUFF)
    endfunction

    //===========================================================================
    private function init takes nothing returns nothing
        call CreateEventTrigger( "udg_FightStart_Real", function FightStart, function FightStart_Conditions )
        call CreateEventTrigger( "udg_FightEnd_Real", function FightEnd, function FightEnd_Conditions )
        call CreateEventTrigger( "Event_AfterHealChange_Real", function AfterHealChange, function AfterHealChange_Conditions )
    endfunction

endscope
