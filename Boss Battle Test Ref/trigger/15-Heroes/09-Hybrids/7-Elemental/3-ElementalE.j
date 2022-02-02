scope ElementalE initializer init

    globals
        private constant integer ID_ABILITY = 'A0LP'
        
        private constant real BONUS_DAMAGE_FIRST_LEVEL = 0.05
        private constant real BONUS_DAMAGE_LEVEL_BONUS = 0.1
        private constant real BONUS_HEAL_FIRST_LEVEL = 0.05
        private constant real BONUS_HEAL_LEVEL_BONUS = 0.1
        
        private constant integer EXTRA_BONUS_DAMAGE_ALTERNATIVE = 2
        private constant integer EXTRA_BONUS_HEAL_ALTERNATIVE = 2
    endglobals

    private function OnDamageChange_Conditions takes nothing returns boolean
        return udg_IsDamageSpell == false and GetUnitAbilityLevel( udg_DamageEventSource, ID_ABILITY ) > 0
    endfunction

    private function Alternative takes real bonusDamage returns nothing 
        set bonusDamage = bonusDamage * EXTRA_BONUS_DAMAGE_ALTERNATIVE
        set udg_DamageEventAmount = udg_DamageEventAmount + (Event_OnDamageChange_StaticDamage*bonusDamage)
    endfunction
    
    private function Main takes real bonusDamage returns nothing 
        set udg_DamageEventAmount = udg_DamageEventAmount + (Event_OnDamageChange_StaticDamage*bonusDamage)
    endfunction

    private function OnDamageChange takes nothing returns nothing
        local unit hero = udg_DamageEventSource
        local integer level = GetUnitAbilityLevel( hero, ID_ABILITY )
        local real bonusDamage = BONUS_DAMAGE_FIRST_LEVEL + ( level * BONUS_DAMAGE_LEVEL_BONUS )
        
        if Aspects_IsHeroAspectActive( hero, ASPECT_02 ) then
            call Alternative( bonusDamage )
        else
            call Main( bonusDamage )
        endif
        
        set hero = null
    endfunction
    
    private function OnHealChange_Conditions takes nothing returns boolean
        return IsUnitHasAbility( Event_OnHealChange_Target, ID_ABILITY ) and Event_OnHealChange_Caster != Event_OnHealChange_Target
    endfunction
    
    private function Alternative_Heal takes real bonusHeal returns nothing 
        set bonusHeal = bonusHeal * EXTRA_BONUS_HEAL_ALTERNATIVE
        set Event_OnHealChange_Heal = Event_OnHealChange_Heal - (Event_OnHealChange_StaticHeal*bonusHeal)
    endfunction
    
    private function Main_Heal takes real bonusHeal returns nothing 
        set Event_OnHealChange_Heal = Event_OnHealChange_Heal - (Event_OnHealChange_StaticHeal*bonusHeal)
    endfunction
    
    private function OnHealChange takes nothing returns nothing
        local unit hero = Event_OnHealChange_Target
        local integer level = GetUnitAbilityLevel( hero, ID_ABILITY )
        local real bonusHeal = BONUS_HEAL_FIRST_LEVEL + ( level * BONUS_HEAL_LEVEL_BONUS )
        
        if Aspects_IsHeroAspectActive( hero, ASPECT_02 ) then
            call Alternative_Heal( bonusHeal )
        else
            call Main_Heal( bonusHeal )
        endif
        
        set hero = null
    endfunction
    
    //===========================================================================
    private function init takes nothing returns nothing
        call CreateEventTrigger( "Event_OnDamageChange_Real", function OnDamageChange, function OnDamageChange_Conditions )
        call CreateEventTrigger( "Event_OnHealChange_Real", function OnHealChange, function OnHealChange_Conditions )
    endfunction
endscope
