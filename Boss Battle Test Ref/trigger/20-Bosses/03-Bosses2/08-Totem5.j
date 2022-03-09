scope Totem5 initializer init

    globals
        private constant integer DAMAGE = 10
    
        private constant string ANIMATION = "Abilities\\Spells\\Undead\\DeathandDecay\\DeathandDecayDamage.mdl"
    endglobals

    private function Trig_Totem5_Conditions takes nothing returns boolean
        return GetUnitTypeId(udg_DamageEventTarget) == 'o007' and GetUnitTypeId(udg_DamageEventSource) != 'u000' and udg_IsDamageSpell == false
    endfunction
    
    private function DealDamage takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer( ) )
        local unit damager = LoadUnitHandle( udg_hash, id, StringHash( "bstm4b" ) )
        local unit target = LoadUnitHandle( udg_hash, id, StringHash( "bstm4" ) )
        
        if IsUnitAlive(target) then
            call DestroyEffect(AddSpecialEffectTarget( ANIMATION, target, "chest") )
            call UnitTakeDamage( damager, target, DAMAGE, DAMAGE_TYPE_MAGIC )
        endif
        call FlushChildHashtable( udg_hash, id )

        set damager = null
        set target = null
    endfunction

    private function Trig_Totem5_Actions takes nothing returns nothing
        local integer id = InvokeTimerWithUnit(udg_DamageEventSource, "bstm4", 0.01, false, function DealDamage )
        call SaveUnitHandle( udg_hash, id, StringHash( "bstm4b" ), udg_DamageEventTarget )
    endfunction

    //===========================================================================
    private function init takes nothing returns nothing
        set gg_trg_Totem5 = CreateEventTrigger( "udg_AfterDamageEvent", function Trig_Totem5_Actions, function Trig_Totem5_Conditions )
        call DisableTrigger( gg_trg_Totem5 )
    endfunction

endscope