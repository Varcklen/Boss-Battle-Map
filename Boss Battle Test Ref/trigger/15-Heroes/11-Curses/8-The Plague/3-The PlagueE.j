scope ThePlagueE initializer init

    globals
        private constant integer ID_ABILITY = 'A1CW'
        public constant integer BUFF = 'B0A8'
        
        private constant integer CAST_CHANCE_FIRST_LEVEL = 10
        private constant integer CAST_CHANCE_LEVEL_BONUS = 5
        
        private constant integer LIFE_TIME = 5
        private constant real STUN_DURATION = 0.5
        
        private constant integer DAMAGE_CHANCE_FIRST_LEVEL = 5
        private constant integer DAMAGE_CHANCE_LEVEL_BONUS = 5
        private constant real DAMAGE_BONUS = 0.35
        
        private integer Level = 0
    endglobals

    function Trig_The_PlagueE_Conditions takes nothing returns boolean
        local integer level = GetUnitAbilityLevel(GetSpellAbilityUnit(), ID_ABILITY)
        return GetUnitAbilityLevel(GetSpellAbilityUnit(),ID_ABILITY) > 0 and LuckChance( GetSpellAbilityUnit(), CAST_CHANCE_FIRST_LEVEL + ( CAST_CHANCE_LEVEL_BONUS * level ) )
    endfunction

    function Trig_The_PlagueE_Actions takes nothing returns nothing
        local unit caster = GetSpellAbilityUnit()
        local integer level = GetUnitAbilityLevel(caster, ID_ABILITY)
        local real damage = ThePlagueQ_DAMAGE_FIRST_LEVEL + (ThePlagueQ_DAMAGE_LEVEL_BONUS * level)
        
        call ThePlagueQ_CreatePoisonousFog( caster, damage, level, GetUnitX(caster), GetUnitY(caster), LIFE_TIME )
        
        set caster = null
    endfunction
    
    
    private function LearnSkill_Conditions takes nothing returns boolean
        return GetLearnedSkill() == ID_ABILITY
    endfunction

    private function LearnSkill takes nothing returns nothing
        set Level = GetUnitAbilityLevel(GetLearningUnit(), ID_ABILITY)
    endfunction
    
    
    private function NullingAbility_Conditions takes nothing returns boolean
        return IsUnitHasAbility(udg_Event_NullingAbility_Unit, ID_ABILITY)
    endfunction
    
    private function NullingAbility takes nothing returns nothing
        set Level = 0
    endfunction
    
    
    private function OnDamageChange_Conditions takes nothing returns boolean
        return IsUnitHasAbility(udg_DamageEventTarget, BUFF) and Level > 0 and LuckChance( GetSpellAbilityUnit(), DAMAGE_CHANCE_FIRST_LEVEL + ( DAMAGE_CHANCE_LEVEL_BONUS * Level ) )
    endfunction
    
    private function Stun takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer() )
        local unit target = LoadUnitHandle(udg_hash, id, StringHash("tple"))
        local unit dealer = LoadUnitHandle(udg_hash, id, StringHash("tpled"))

        call UnitStun( dealer, target, STUN_DURATION )
        call FlushChildHashtable( udg_hash, id )

        set dealer = null
        set target = null
    endfunction
    
    private function OnDamageChange takes nothing returns nothing
        local integer id
        
        set udg_DamageEventAmount = udg_DamageEventAmount + (Event_OnDamageChange_StaticDamage*DAMAGE_BONUS)
        
        set id = InvokeTimerWithUnit(udg_DamageEventTarget, "tple", 0.01, false, function Stun )
        call SaveUnitHandle(udg_hash, id, StringHash("tpled"), udg_DamageEventSource )
    endfunction

    //===========================================================================
    private function init takes nothing returns nothing
        local trigger trig
    
        set gg_trg_The_PlagueE = CreateTrigger(  )
        call TriggerRegisterAnyUnitEventBJ( gg_trg_The_PlagueE, EVENT_PLAYER_UNIT_SPELL_EFFECT )
        call TriggerAddCondition( gg_trg_The_PlagueE, Condition( function Trig_The_PlagueE_Conditions ) )
        call TriggerAddAction( gg_trg_The_PlagueE, function Trig_The_PlagueE_Actions )
        
        set trig = CreateTrigger(  )
        call TriggerRegisterAnyUnitEventBJ( trig, EVENT_PLAYER_HERO_SKILL )
        call TriggerAddCondition( trig, Condition( function LearnSkill_Conditions ) )
        call TriggerAddAction( trig, function LearnSkill )
        
        call CreateEventTrigger( "udg_Event_NullingAbility_Real", function NullingAbility, function NullingAbility_Conditions )
        call CreateEventTrigger( "Event_OnDamageChange_Real", function OnDamageChange, function OnDamageChange_Conditions )
        
        set trig = null
    endfunction

endscope