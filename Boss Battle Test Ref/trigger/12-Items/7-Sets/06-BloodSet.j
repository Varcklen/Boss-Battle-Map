scope BloodSet initializer init

    globals
        private constant integer ID_ABILITY = 'A03T'
        private constant real VAMPIRISM_BONUS = 0.4
        
        private constant string ANIMATION = "Abilities\\Spells\\Undead\\VampiricAura\\VampiricAuraTarget.mdl"
    endglobals

    private function AfterDamageEvent_Conditions takes nothing returns boolean
        return IsUnitHasAbility( udg_DamageEventSource, ID_ABILITY ) and udg_IsDamageSpell == false
    endfunction

    private function AfterDamageEvent takes nothing returns nothing
        local real heal = udg_DamageEventAmount * VAMPIRISM_BONUS
        call healst( udg_DamageEventSource, null, heal )
        call PlaySpecialEffect(ANIMATION, udg_DamageEventSource)
    endfunction

    //===========================================================================
    private function init takes nothing returns nothing
        //По какой-то причине при udg_AfterDamageEvent другие модификаторы переставали работать?udg_DamageEventAfterArmor
        call CreateEventTrigger( "udg_AfterDamageEvent", function AfterDamageEvent, function AfterDamageEvent_Conditions )
    endfunction

endscope

