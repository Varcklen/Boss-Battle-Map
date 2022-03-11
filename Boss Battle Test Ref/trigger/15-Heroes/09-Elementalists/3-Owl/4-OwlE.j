scope OwlE initializer init

    globals
        private constant integer ID_ABILITY = 'A07T'
        
        private constant integer DURATION = 6
        private constant real SPELL_POWER_BONUS_FIRST_LEVEL = 0
        private constant real SPELL_POWER_BONUS_LEVEL_BONUS = 0.5
        
        private constant integer EFFECT = 'A07U'
        private constant integer BUFF = 'B002'
        
        private constant string ANIMATION = "DarkSwirl.mdx"
    endglobals

    function Trig_OwlE_Conditions takes nothing returns boolean
        return IsUnitHasAbility(GetSpellAbilityUnit(), ID_ABILITY)
    endfunction

    function OwlPData takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer( ) )
        local unit hero = LoadUnitHandle( udg_hash, id, StringHash( "owlp" ) )
        local integer heroId = GetHandleId( hero )

        call spdst( hero, -LoadReal( udg_hash, heroId, StringHash( "owlp" ) ) )
        call RemoveSavedReal( udg_hash, heroId, StringHash( "owlp" ) )
        call UnitRemoveAbility( hero, EFFECT )
        call UnitRemoveAbility( hero, BUFF )
        call FlushChildHashtable( udg_hash, id )
        
        set hero = null
    endfunction

    function Trig_OwlE_Actions takes nothing returns nothing
        local unit caster = GetSpellAbilityUnit()
        local integer lvl = GetUnitAbilityLevel(caster, ID_ABILITY)
        local real spellPowerAdded = SPELL_POWER_BONUS_FIRST_LEVEL + (lvl*SPELL_POWER_BONUS_LEVEL_BONUS)
        local real isum
        local real duration = timebonus(caster, DURATION)
        local integer casterId = GetHandleId( caster )

        call spdst( caster, spellPowerAdded )
        call UnitAddAbility( caster, EFFECT )
        set isum = LoadReal( udg_hash, casterId, StringHash( "owlp" ) ) + spellPowerAdded
        call DestroyEffect(AddSpecialEffectTarget( ANIMATION, caster, "overhead") )
        
        call InvokeTimerWithUnit(caster, "owlp", duration, false, function OwlPData )
        call SaveReal( udg_hash, casterId, StringHash( "owlp" ), isum )
        
        call effst( caster, caster, null, lvl, duration )
        
        set caster = null
    endfunction
    
    private function DeleteBuff_Conditions takes nothing returns boolean
        return IsUnitHasAbility( Event_DeleteBuff_Unit, EFFECT)
    endfunction
    
    private function DeleteBuff takes nothing returns nothing
        local unit hero = Event_DeleteBuff_Unit
        local integer heroId = GetHandleId( hero )

        call spdst( hero, -LoadReal( udg_hash, heroId, StringHash( "owlp" ) ) )
        call RemoveSavedReal( udg_hash, heroId, StringHash( "owlp" ) )
        call UnitRemoveAbility( hero, EFFECT )
        call UnitRemoveAbility( hero, BUFF )
        
        set hero = null
    endfunction

    //===========================================================================
    private function init takes nothing returns nothing
        set gg_trg_OwlE = CreateTrigger(  )
        call TriggerRegisterAnyUnitEventBJ( gg_trg_OwlE, EVENT_PLAYER_UNIT_SPELL_EFFECT )
        call TriggerAddCondition( gg_trg_OwlE, Condition( function Trig_OwlE_Conditions ) )
        call TriggerAddAction( gg_trg_OwlE, function Trig_OwlE_Actions )
        
        call CreateEventTrigger( "Event_DeleteBuff_Real", function DeleteBuff, function DeleteBuff_Conditions )
    endfunction

endscope

