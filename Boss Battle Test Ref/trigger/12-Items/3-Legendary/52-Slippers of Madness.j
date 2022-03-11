scope SlippersOfMadness initializer init
    
    globals
        private constant integer ID_ITEM = 'I01L'
        private constant integer BONUS_MIN = -10
        private constant integer BONUS_MAX = 10
    endglobals
    
    private function Trig_Slippers_of_Madness_Conditions takes nothing returns boolean
        return IsHeroHasItem(udg_FightEnd_Unit, ID_ITEM) and udg_fightmod[3] == false
    endfunction
    
    private function GetExtraText takes integer rand returns string
        if rand >= 0 then
            return "+"
        else
            return ""
        endif
    endfunction

    private function Trig_Slippers_of_Madness_Actions takes nothing returns nothing
        local unit hero = udg_FightEnd_Unit
        local integer rand
        local integer i
        local string str
        
        set i = 1
        loop
            exitwhen i > 3
            set rand = IMinBJ( GetRandomInt( BONUS_MIN + GetUnitLuck(hero), BONUS_MAX), BONUS_MAX )
            if i == 1 then
                call statst( hero, rand, 0, 0, 68, true )
                call textst( "|c00FF2020 " + GetExtraText(rand) + I2S(rand) + " strength", hero, 64, 30, 10, 2.5 )
            elseif i == 2 then
                call statst( hero, 0, rand, 0, 72, true )
                call textst( "|c0020FF20 " + GetExtraText(rand) + I2S(rand) + " agility", hero, 64, 150, 10, 2.5 )
            elseif i == 3 then
                call statst( hero, 0, 0, rand, 76, true )
                call textst( "|c002020FF " + GetExtraText(rand) + I2S(rand) + " intelligence", hero, 64, 270, 10, 2.5 )
            endif
            set i = i + 1
        endloop
        
        set hero = null
    endfunction

    //===========================================================================
    private function init takes nothing returns nothing
        set gg_trg_Slippers_of_Madness = CreateTrigger(  )
        call TriggerRegisterVariableEvent( gg_trg_Slippers_of_Madness, "udg_FightEnd_Real", EQUAL, 1.00 )
        call TriggerAddCondition( gg_trg_Slippers_of_Madness, Condition( function Trig_Slippers_of_Madness_Conditions ) )
        call TriggerAddAction( gg_trg_Slippers_of_Madness, function Trig_Slippers_of_Madness_Actions )
    endfunction

endscope