scope GamblerR initializer init

    globals
        private constant integer ID_ABILITY = 'A11J'
        
        private constant integer LUCK_BONUS = 100
        private constant integer DURATION_FIRST_LEVEL = 8
        private constant integer DURATION_LEVEL_BONUS = 2
        
        private constant integer EFFECT = 'A11Q'
        private constant integer BUFF = 'B06S'
        
        private constant string ANIMATION = "Abilities\\Spells\\Human\\Slow\\SlowCaster.mdl"
    endglobals

    function Trig_GamblerR_Conditions takes nothing returns boolean
        return GetSpellAbilityId() == ID_ABILITY and combat( GetSpellAbilityUnit(), true, GetSpellAbilityId() ) and not( udg_fightmod[3] )
    endfunction

    function GamblerRCast takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer( ) )
        local unit u = LoadUnitHandle( udg_hash, id, StringHash( "gmbr" ) )
        local integer luckBonus = LoadInteger( udg_hash, GetHandleId( u ), StringHash( "gmbr" ) )
        
        call luckyst( u, -luckBonus )
        call UnitRemoveAbility( u, EFFECT )
        call UnitRemoveAbility( u, BUFF )
        
        call RemoveSavedInteger( udg_hash, GetHandleId( u ), StringHash( "gmbr" ) )
        call FlushChildHashtable( udg_hash, id )

        set u = null
    endfunction

    function Trig_GamblerR_Actions takes nothing returns nothing
        local integer isum
        local unit caster
        local real t
        local integer lvl
        
        if CastLogic() then
            set caster = udg_Caster
            set lvl = udg_Level
            set t = udg_Time
        elseif RandomLogic() then
            set caster = udg_Caster
            set lvl = udg_Level
            call textst( udg_string[0] + GetObjectName(ID_ABILITY), caster, 64, 90, 10, 1.5 )
            set t = DURATION_FIRST_LEVEL + (DURATION_LEVEL_BONUS*lvl)
        else
            set caster = GetSpellAbilityUnit()
            set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId() )
            set t = DURATION_FIRST_LEVEL + (DURATION_LEVEL_BONUS*lvl)
        endif
        set t = timebonus(caster, t)

        if IsUnitType( caster, UNIT_TYPE_HERO) then
            call luckyst( caster, LUCK_BONUS )
            set isum = LoadInteger( udg_hash, GetHandleId( caster ), StringHash( "gmbr" ) ) + LUCK_BONUS
            
            call UnitAddAbility( caster, EFFECT)
            call DestroyEffect( AddSpecialEffectTarget( ANIMATION, caster, "overhead") )
            
            call InvokeTimerWithUnit(caster, "gmbr", t, false, function GamblerRCast)
            call SaveInteger( udg_hash, GetHandleId( caster ), StringHash( "gmbr" ), isum )
            
            call effst( caster, caster, null, 1, t )
        endif
        
        set caster = null
    endfunction
    
    private function DeleteBuff_Conditions takes nothing returns boolean
        return GetUnitAbilityLevel( Event_DeleteBuff_Unit, EFFECT) > 0
    endfunction
    
    private function DeleteBuff takes nothing returns nothing
        local unit hero = Event_DeleteBuff_Unit
        local integer luckBonus = LoadInteger( udg_hash, GetHandleId( hero ), StringHash( "gmbr" ) )

        call luckyst( hero, -luckBonus )
        call UnitRemoveAbility( hero, EFFECT )
        call UnitRemoveAbility( hero, BUFF )
        call RemoveSavedInteger( udg_hash, GetHandleId( hero ), StringHash( "gmbr" ) )
        
        set hero = null
    endfunction

    //===========================================================================
    private function init takes nothing returns nothing
        set gg_trg_GamblerR = CreateTrigger(  )
        call TriggerRegisterAnyUnitEventBJ( gg_trg_GamblerR, EVENT_PLAYER_UNIT_SPELL_EFFECT )
        call TriggerAddCondition( gg_trg_GamblerR, Condition( function Trig_GamblerR_Conditions ) )
        call TriggerAddAction( gg_trg_GamblerR, function Trig_GamblerR_Actions )
        
        call CreateEventTrigger( "Event_DeleteBuff_Real", function DeleteBuff, function DeleteBuff_Conditions )
    endfunction

endscope

