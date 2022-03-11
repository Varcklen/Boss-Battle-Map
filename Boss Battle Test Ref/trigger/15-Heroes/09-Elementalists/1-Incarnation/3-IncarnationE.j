scope IncarnationE initializer init

    globals
        private constant integer ID_ABILITY = 'A0UJ'
        private constant real DAMAGE_BONUS_FIRST_LEVEL = 0.25
        private constant real DAMAGE_BONUS_LEVEL_BONUS = 0.15
    endglobals

    private function OnDamageChange_Conditions takes nothing returns boolean
        return udg_IsDamageSpell and IsUnitHasAbility(udg_hero[GetPlayerId( GetOwningPlayer(udg_DamageEventSource) ) + 1], ID_ABILITY)
    endfunction
    
    private function OnDamageChange takes nothing returns nothing
        local unit hero = udg_hero[GetPlayerId( GetOwningPlayer(udg_DamageEventSource) ) + 1]
        local integer level = GetUnitAbilityLevel(hero, ID_ABILITY)
        local real extraDamage = DAMAGE_BONUS_FIRST_LEVEL + (DAMAGE_BONUS_LEVEL_BONUS*level)
        local real reverseHealth = 1 - (GetHealthPercent(hero)/100)
    
        set udg_DamageEventAmount = udg_DamageEventAmount + ( Event_OnDamageChange_StaticDamage * extraDamage * reverseHealth )
        
        set hero = null
    endfunction

    //===========================================================================
    private function init takes nothing returns nothing
        call CreateEventTrigger("Event_OnDamageChange_Real", function OnDamageChange, function OnDamageChange_Conditions)
    endfunction

endscope