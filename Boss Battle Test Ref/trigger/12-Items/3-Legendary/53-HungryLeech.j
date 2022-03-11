scope HungryLeech initializer init

    globals
        private constant integer ID_ITEM = 'I0DG'
        private boolean isLoop = false
    endglobals

    private function AfterHeal_Conditions takes nothing returns boolean
        return IsHeroHasItem( Event_AfterHeal_Target, ID_ITEM ) and Event_AfterHeal_Target != Event_AfterHeal_Caster and isLoop == false
    endfunction
    
    private function AfterHeal takes nothing returns nothing
        set isLoop = true
        call healst( Event_AfterHeal_Target, Event_AfterHeal_Caster, Event_AfterHeal_Heal )
        set isLoop = false
    endfunction

    //===========================================================================
    private function init takes nothing returns nothing
        call CreateEventTrigger("Event_AfterHeal_Real", function AfterHeal, function AfterHeal_Conditions )
    endfunction
endscope