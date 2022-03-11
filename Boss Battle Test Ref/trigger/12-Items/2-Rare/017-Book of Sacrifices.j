scope BookofSacrifices initializer init

    globals
        private constant integer ID_ITEM = 'I02V'
        private constant real HEAL_PERCENT = 0.2
        
        private constant string ANIMATION = "Abilities\\Spells\\Undead\\VampiricAura\\VampiricAuraTarget.mdl"
        
        private boolean Loop = false
    endglobals
    
    private function AfterDamageEvent_Conditions takes nothing returns boolean
        return udg_IsDamageSpell and IsHeroHasItem(ChoosedHero[GetPlayerId( GetOwningPlayer(udg_DamageEventSource) ) + 1], ID_ITEM ) and Loop == false
    endfunction
        
    private function AfterDamageEvent takes nothing returns nothing
        local unit caster = ChoosedHero[GetPlayerId( GetOwningPlayer(udg_DamageEventSource) ) + 1]
        
        set Loop = true
        call healst( caster, null, udg_DamageEventAmount * HEAL_PERCENT )
        call PlaySpecialEffect(ANIMATION, caster )
        set Loop = false
        
        set caster = null
    endfunction

    //===========================================================================
    private function init takes nothing returns nothing
        call CreateEventTrigger( "udg_AfterDamageEvent", function AfterDamageEvent, function AfterDamageEvent_Conditions )
    endfunction
endscope

