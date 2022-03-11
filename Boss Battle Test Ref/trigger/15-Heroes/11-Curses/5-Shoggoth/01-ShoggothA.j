scope Shoggoth

    function Trig_ShoggothA_Conditions takes nothing returns boolean
        return GetUnitTypeId(udg_DamageEventSource) == 'O016'
    endfunction

    function Trig_ShoggothA_Actions takes nothing returns nothing
        call DestroyEffect( AddSpecialEffect( "Units\\Creeps\\ForgottenOne\\ForgottenOneTent", GetUnitX(udg_DamageEventTarget), GetUnitY(udg_DamageEventTarget) ) )
    endfunction
    
    //When choose hero
    private function HeroChoose_Conditions takes nothing returns boolean
        return GetUnitTypeId(Event_HeroChoose_Hero) == 'O016'
    endfunction
    
    private function HeroChoose takes nothing returns nothing
        set udg_panel[3] = CreateLeaderboardBJ( GetForceOfPlayer(GetOwningPlayer(Event_HeroChoose_Hero)), "" )
        call LeaderboardSetLabelColor(udg_panel[3], 250, 200, 50, 250 )
        call LeaderboardAddItemBJ( Player(4), udg_panel[3], "Entropies: ", udg_entropy[GetPlayerId(GetOwningPlayer(Event_HeroChoose_Hero)) + 1] )
    endfunction
    
    
    //When hero repicked
    private function HeroRepick_Conditions takes nothing returns boolean
        return GetUnitTypeId(Event_HeroRepick_Hero) == 'O016'
    endfunction
    
    private function HeroRepick takes nothing returns nothing
        call DestroyLeaderboard( udg_panel[3] )
    endfunction
    
    //===========================================================================
    function InitTrig_ShoggothA takes nothing returns nothing
        set gg_trg_ShoggothA = CreateTrigger(  )
        call TriggerRegisterVariableEvent( gg_trg_ShoggothA, "udg_DamageModifierEvent", EQUAL, 1.00 )
        call TriggerAddCondition( gg_trg_ShoggothA, Condition( function Trig_ShoggothA_Conditions ) )
        call TriggerAddAction( gg_trg_ShoggothA, function Trig_ShoggothA_Actions )
        
        call CreateEventTrigger( "Event_HeroChoose_Real", function HeroChoose, function HeroChoose_Conditions )
        call CreateEventTrigger( "Event_HeroRepick_Real", function HeroRepick, function HeroRepick_Conditions )
    endfunction

endscope