scope LegionerE initializer init

    globals
        private constant integer ID_ABILITY = 'A08E'
        
        private constant integer CHANCE_FIRST_LEVEL = 0
        private constant integer CHANCE_LEVEL_BONUS = 2
        
        private constant integer RUBY_GETTED = 1
        private constant real HEAL_PERCENT_LEVEL_BONUS = 0.02
        private constant real MANA_PERCENT_LEVEL_BONUS = 0.02
    endglobals
    
    private function Conditions takes unit caster returns boolean
        local boolean isTrue = true
        
        if IsUnitHasAbility( caster, ID_ABILITY ) == false then
            set isTrue = false
        elseif combat( caster, false, 0 ) == false then 
            set isTrue = false
        elseif udg_fightmod[3] then
            set isTrue = false
        elseif LuckChance( caster, CHANCE_FIRST_LEVEL + (CHANCE_LEVEL_BONUS * GetUnitAbilityLevel( caster, ID_ABILITY) ) ) == false then
            set isTrue = false
        endif
        
        set caster = null
        return isTrue
    endfunction
    
    private function Action takes unit caster returns nothing
        call crist( caster, RUBY_GETTED )
        call healst( caster, null, GetUnitState( caster, UNIT_STATE_MAX_LIFE) * HEAL_PERCENT_LEVEL_BONUS )
        call manast( caster, null, GetUnitState( caster, UNIT_STATE_MAX_MANA) * MANA_PERCENT_LEVEL_BONUS )
    
        set caster = null
    endfunction

    //When attack
    private function AfterDamageEvent_Conditions takes nothing returns boolean
        return Conditions(udg_DamageEventSource) and IsUnitEnemy(udg_DamageEventSource, GetOwningPlayer(udg_DamageEventTarget)) and udg_IsDamageSpell == false
    endfunction
    
    private function AfterDamageEvent takes nothing returns nothing
        call Action(udg_DamageEventSource)
    endfunction
    
    //When cast
    private function Cast_Conditions takes nothing returns boolean
        return Conditions(GetSpellAbilityUnit())
    endfunction
    
    private function Cast takes nothing returns nothing
        call Action(GetSpellAbilityUnit())
    endfunction


    //When choose hero
    private function HeroChoose_Conditions takes nothing returns boolean
        return GetUnitTypeId(Event_HeroChoose_Hero) == 'O00C'
    endfunction
    
    private function HeroChoose takes nothing returns nothing
        set udg_panel[1] = CreateLeaderboardBJ( GetForceOfPlayer(GetOwningPlayer(Event_HeroChoose_Hero)), "" )
        call LeaderboardSetLabelColor(udg_panel[1], 250, 200, 50, 250 )
        call LeaderboardAddItemBJ( Player(4), udg_panel[1], "Rubies: ", udg_cristal )
    endfunction
    
    //When hero repicked
    private function HeroRepick_Conditions takes nothing returns boolean
        return GetUnitTypeId(Event_HeroRepick_Hero) == 'O00C'
    endfunction
    
    private function HeroRepick takes nothing returns nothing
        call DestroyLeaderboard( udg_panel[1] )
    endfunction
    
    //===========================================================================
    private function init takes nothing returns nothing
        local trigger trig = CreateTrigger()
        
        call TriggerRegisterAnyUnitEventBJ( trig, EVENT_PLAYER_UNIT_SPELL_EFFECT )
        call TriggerAddCondition( trig, Condition( function Cast_Conditions ) )
        call TriggerAddAction( trig, function Cast )
        
        call CreateEventTrigger( "udg_AfterDamageEvent", function AfterDamageEvent, function AfterDamageEvent_Conditions )
        call CreateEventTrigger( "Event_HeroChoose_Real", function HeroChoose, function HeroChoose_Conditions )
        call CreateEventTrigger( "Event_HeroRepick_Real", function HeroRepick, function HeroRepick_Conditions )
        
        set trig = null
    endfunction
endscope