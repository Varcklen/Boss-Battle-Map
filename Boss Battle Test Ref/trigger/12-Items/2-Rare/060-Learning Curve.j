scope LearningCurve initializer init

    globals
        private constant integer ID_ITEM = 'I03V'
        
        private constant integer LEVEL_BONUS = 2
    endglobals
                
    private function EndOfLostBattle_Conditions takes nothing returns boolean
        return IsHeroHasItem(Event_EndOfLostBattle_Hero, ID_ITEM)
    endfunction
    
    private function EndOfLostBattle takes nothing returns nothing
        call SetHeroLevel(Event_EndOfLostBattle_Hero, GetHeroLevel(Event_EndOfLostBattle_Hero) + LEVEL_BONUS, false)
    endfunction

    private function init takes nothing returns nothing
        call CreateEventTrigger( "Event_EndOfLostBattle_Real", function EndOfLostBattle, function EndOfLostBattle_Conditions )
    endfunction

endscope