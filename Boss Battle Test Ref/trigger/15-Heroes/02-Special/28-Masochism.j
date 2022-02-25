scope Masochism

    globals
        private constant integer ID_MASOCHISM_ABILITY = 'AZ00'
    endglobals

    function Trig_Masochism_Conditions takes nothing returns boolean
        return GetSpellAbilityId() == ID_MASOCHISM_ABILITY
    endfunction

    function Trig_Masochism_Actions takes nothing returns nothing
        local unit caster
        
        if CastLogic() then
            set caster = udg_Caster
        elseif RandomLogic() then
            set caster = udg_Caster
            call textst( udg_string[0] + GetObjectName(ID_MASOCHISM_ABILITY), caster, 64, 90, 10, 1.5 )
        else
            set caster = GetSpellAbilityUnit()
        endif
        call UnitAddAbility( caster, 'AZ02')
        set caster = null
    endfunction

    private function OnDamageChange_Conditions takes nothing returns boolean
        return GetUnitAbilityLevel(udg_DamageEventTarget, 'BZ02') > 0 and udg_DamageEventAmount > 0
    endfunction
    
    private function OnDamageChange takes nothing returns nothing
        local unit hero = udg_DamageEventTarget

        call healst(hero, null, udg_DamageEventAmount)
        call UnitRemoveAbility( hero, 'AZ02' )
        call UnitRemoveAbility( hero, 'BZ02' )
        set udg_DamageEventAmount = 0
        
        set hero = null
    endfunction
    
    
    //Delete Buff
    private function DeleteBuff_Conditions takes nothing returns boolean
        return GetUnitAbilityLevel( Event_DeleteBuff_Unit, 'AZ02') > 0
    endfunction
    
    private function DeleteBuff takes nothing returns nothing
        local unit hero = Event_DeleteBuff_Unit

        call UnitRemoveAbility( hero, 'AZ02' )
        call UnitRemoveAbility( hero, 'BZ02' )
        
        set hero = null
    endfunction

    //===========================================================================
    function InitTrig_Masochism takes nothing returns nothing
        set gg_trg_Masochism = CreateTrigger(  )
        call TriggerRegisterAnyUnitEventBJ( gg_trg_Masochism, EVENT_PLAYER_UNIT_SPELL_EFFECT )
        call TriggerAddCondition( gg_trg_Masochism, Condition( function Trig_Masochism_Conditions ) )
        call TriggerAddAction( gg_trg_Masochism, function Trig_Masochism_Actions )
        
        call CreateEventTrigger( "Event_OnDamageChange_Real", function OnDamageChange, function OnDamageChange_Conditions )
        call CreateEventTrigger( "Event_DeleteBuff_Real", function DeleteBuff, function DeleteBuff_Conditions )
    endfunction

endscope
