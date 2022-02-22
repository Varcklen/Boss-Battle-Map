scope BarbarianE initializer init

    globals
        private constant integer ID_ABILITY = 'A08F'
        private constant real RESOURCE_BONUS_FIRST_LEVEL = 0
        private constant real RESOURCE_BONUS_LEVEL_BONUS = 0.01
        private constant integer MINIMUM_RESOURCE_ADDED = 1
        
        private constant string ANIMATION_HEALTH = "Abilities\\Spells\\Human\\Heal\\HealTarget.mdl"
        private constant string ANIMATION_MANA = "Abilities\\Spells\\Undead\\ReplenishMana\\ReplenishManaCaster.mdl"
    endglobals

    private function Trig_BarbarianE_Conditions takes nothing returns boolean
         return udg_IsDamageSpell == false and IsUnitHasAbility( udg_DamageEventSource, ID_ABILITY) and IsUnitEnemy(udg_DamageEventSource, GetOwningPlayer(udg_DamageEventTarget))
    endfunction
    
    private function Trig_BarbarianE_Actions takes nothing returns nothing
        local real percent = RESOURCE_BONUS_FIRST_LEVEL + ( GetUnitAbilityLevel( udg_DamageEventSource, ID_ABILITY) * RESOURCE_BONUS_LEVEL_BONUS )
        local real heal 
        
        if IsUnitManaIsFull( udg_DamageEventSource ) then
            set heal = RMaxBJ(MINIMUM_RESOURCE_ADDED, GetUnitState( udg_DamageEventSource, UNIT_STATE_MAX_LIFE) * percent )
            call healst( udg_DamageEventSource, null, heal )
            call spectimeunit( udg_DamageEventSource, ANIMATION_HEALTH, "origin", 2 )
        else
            set heal = RMaxBJ(MINIMUM_RESOURCE_ADDED, GetUnitState( udg_DamageEventSource, UNIT_STATE_MAX_MANA) * percent )
            call manast( udg_DamageEventSource, null, heal )
            call spectimeunit( udg_DamageEventSource, ANIMATION_MANA, "origin", 2 )
        endif
    endfunction

    //===========================================================================
    private function init takes nothing returns nothing
         call CreateEventTrigger( "udg_AfterDamageEvent", function Trig_BarbarianE_Actions, function Trig_BarbarianE_Conditions )
    endfunction
endscope