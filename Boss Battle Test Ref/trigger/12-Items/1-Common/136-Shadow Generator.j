scope ShadowGenerator initializer init

    globals
        private constant integer ID_ITEM = 'I06H'
        
        private constant integer DAMAGE = 10
        private constant string ANIMATION = "Abilities\\Spells\\Undead\\DeathandDecay\\DeathandDecayDamage.mdl"
    endglobals

    function Trig_Shadow_Generator_Conditions takes nothing returns boolean
        return IsHeroHasItem(GetSpellAbilityUnit(), ID_ITEM)
    endfunction

    function Trig_Shadow_Generator_Actions takes nothing returns nothing
        call DestroyEffect( AddSpecialEffectTarget( ANIMATION, GetSpellAbilityUnit(), "origin") )
        call UnitTakeDamage(GetSpellAbilityUnit(), GetSpellAbilityUnit(), DAMAGE, DAMAGE_TYPE_MAGIC)
    endfunction

    //===========================================================================
    private function init takes nothing returns nothing
        set gg_trg_Shadow_Generator = CreateTrigger(  )
        call TriggerRegisterAnyUnitEventBJ( gg_trg_Shadow_Generator, EVENT_PLAYER_UNIT_SPELL_EFFECT )
        call TriggerAddCondition( gg_trg_Shadow_Generator, Condition( function Trig_Shadow_Generator_Conditions ) )
        call TriggerAddAction( gg_trg_Shadow_Generator, function Trig_Shadow_Generator_Actions )
    endfunction

endscope
