scope LadybugR initializer init

    globals
        private constant integer ID_ABILITY = 'A0TK'
        
        private constant integer LUCK_BONUS = 100
        private constant integer DURATION = 15

        private constant integer EFFECT = 'A0TM'
        private constant integer BUFF = 'B051'
        
        private constant string ANIMATION = "Abilities\\Spells\\Human\\Slow\\SlowCaster.mdl"
    endglobals

    function Trig_Ladybug_Conditions takes nothing returns boolean
        return GetSpellAbilityId() == ID_ABILITY
    endfunction

    function LadybugRCast takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer( ) )
        local unit u = LoadUnitHandle( udg_hash, id, StringHash( "ldbg" ) )
        local integer luckBonus = LoadInteger( udg_hash, GetHandleId( u ), StringHash( "ldbg" ) )
        
        call luckyst( u, -luckBonus )
        call UnitRemoveAbility( u, EFFECT )
        call UnitRemoveAbility( u, BUFF )
        
        call RemoveSavedInteger( udg_hash, GetHandleId( u ), StringHash( "ldbg" ) )
        call FlushChildHashtable( udg_hash, id )

        set u = null
    endfunction

    function Trig_Ladybug_Actions takes nothing returns nothing
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
            set t = DURATION
        else
            set caster = GetSpellAbilityUnit()
            set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId() )
            set t = DURATION
        endif
        set t = timebonus(caster, t)

        if IsUnitType( caster, UNIT_TYPE_HERO) then
            call luckyst( caster, LUCK_BONUS )
            set isum = LoadInteger( udg_hash, GetHandleId( caster ), StringHash( "ldbg" ) ) + LUCK_BONUS
            
            call UnitAddAbility( caster, EFFECT)
            call DestroyEffect( AddSpecialEffectTarget( ANIMATION, caster, "overhead") )
            
            call InvokeTimerWithUnit(caster, "ldbg", t, false, function LadybugRCast)
            call SaveInteger( udg_hash, GetHandleId( caster ), StringHash( "ldbg" ), isum )
            
            call effst( caster, caster, null, 1, t )
        endif
        
        set caster = null
    endfunction
    
    private function DeleteBuff_Conditions takes nothing returns boolean
        return GetUnitAbilityLevel( Event_DeleteBuff_Unit, EFFECT) > 0
    endfunction
    
    private function DeleteBuff takes nothing returns nothing
        local unit hero = Event_DeleteBuff_Unit
        local integer luckBonus = LoadInteger( udg_hash, GetHandleId( hero ), StringHash( "ldbg" ) )

        call luckyst( hero, -luckBonus )
        call UnitRemoveAbility( hero, EFFECT )
        call UnitRemoveAbility( hero, BUFF )
        call RemoveSavedInteger( udg_hash, GetHandleId( hero ), StringHash( "ldbg" ) )
        
        set hero = null
    endfunction

    //===========================================================================
    private function init takes nothing returns nothing
        set gg_trg_Ladybug = CreateTrigger(  )
        call TriggerRegisterAnyUnitEventBJ( gg_trg_Ladybug, EVENT_PLAYER_UNIT_SPELL_EFFECT )
        call TriggerAddCondition( gg_trg_Ladybug, Condition( function Trig_Ladybug_Conditions ) )
        call TriggerAddAction( gg_trg_Ladybug, function Trig_Ladybug_Actions )
        
        call CreateEventTrigger( "Event_DeleteBuff_Real", function DeleteBuff, function DeleteBuff_Conditions )
    endfunction

endscope

