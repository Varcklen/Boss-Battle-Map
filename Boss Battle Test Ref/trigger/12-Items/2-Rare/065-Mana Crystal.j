scope ManaCrystal initializer init

    globals
        private constant integer ID_ABILITY = 'A14B'
        
        private constant integer DAMAGE = 100
        
        private constant string ANIMATION_CASTER = "Abilities\\Spells\\Human\\Slow\\SlowCaster.mdl"
        private constant string ANIMATION_TARGET = "Abilities\\Spells\\Human\\Invisibility\\InvisibilityTarget.mdl"
        
        private boolean isManaCrystal = false
    endglobals

    function Trig_Mana_Crystal_Conditions takes nothing returns boolean
        return GetSpellAbilityId() == ID_ABILITY
    endfunction

    function Trig_Mana_Crystal_Actions takes nothing returns nothing
        local integer i = 1
        local integer iEnd
        local unit caster
        local unit target
        
        if CastLogic() then
            set caster = udg_Caster
            set target = udg_Target
        elseif RandomLogic() then
            set caster = udg_Caster
            set target = randomtarget( caster, 900, TARGET_ENEMY, "", "", "", "" )
            call textst( udg_string[0] + GetObjectName(ID_ABILITY), caster, 64, 90, 10, 1.5 )
            if target == null then
                set caster = null
                return
            endif
        else
            set caster = GetSpellAbilityUnit()
            set target = GetSpellTargetUnit()
        endif
        
        call PlaySpecialEffect(ANIMATION_CASTER, caster )
        call PlaySpecialEffect(ANIMATION_TARGET, target )
        
        set isManaCrystal = true
        set iEnd = eyest( caster )
        loop
            exitwhen i > iEnd
            call UnitTakeDamage(caster, target, DAMAGE, DAMAGE_TYPE_MAGIC)
            set i = i + 1
        endloop
        set isManaCrystal = false
        
        set caster = null
        set target = null
    endfunction
    
    private function AfterDamageEvent_Conditions takes nothing returns boolean
        return isManaCrystal
    endfunction
    
    private function AfterDamageEvent takes nothing returns nothing
        call manast( udg_DamageEventSource, null, udg_DamageEventAmount )
    endfunction
    
    //===========================================================================
    private function init takes nothing returns nothing
        set gg_trg_Mana_Crystal = CreateTrigger(  )
        call TriggerRegisterAnyUnitEventBJ( gg_trg_Mana_Crystal, EVENT_PLAYER_UNIT_SPELL_EFFECT )
        call TriggerAddCondition( gg_trg_Mana_Crystal, Condition( function Trig_Mana_Crystal_Conditions ) )
        call TriggerAddAction( gg_trg_Mana_Crystal, function Trig_Mana_Crystal_Actions )
        
        call CreateEventTrigger( "udg_AfterDamageEvent", function AfterDamageEvent, function AfterDamageEvent_Conditions )
    endfunction

endscope