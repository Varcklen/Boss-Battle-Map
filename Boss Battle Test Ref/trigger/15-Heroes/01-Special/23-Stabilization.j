scope Stabilization initializer init

    globals
        private constant integer ID_ABILITY = 'A0GR' 
        
        private constant integer EFFECT = 'A0GS'
        private constant integer BUFF = 'B06C'
        
        private constant string ANIMATION = "Abilities\\Spells\\Items\\AIim\\AIimTarget.mdl"
    endglobals

    function Trig_Stabilization_Conditions takes nothing returns boolean
        return GetSpellAbilityId() == ID_ABILITY
    endfunction

    function Trig_Stabilization_Actions takes nothing returns nothing
        local unit caster
        
        if CastLogic() then
            set caster = udg_Caster
        elseif RandomLogic() then
            set caster = udg_Caster
            call textst( udg_string[0] + GetObjectName(ID_ABILITY), caster, 64, 90, 10, 1.5 )
        else
            set caster = GetSpellAbilityUnit()
        endif

        call PlaySpecialEffect(ANIMATION, caster )
        call UnitAddAbility(caster, EFFECT)
        
        set caster = null
    endfunction
    
    
    //Cast effect
    private function Cast_Conditions takes nothing returns boolean
        return IsUnitHasAbility(GetSpellAbilityUnit(), EFFECT) and GetSpellAbilityId() != ID_ABILITY
    endfunction

    private function StabilizationEnd takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer( ) )
        local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "stblst" ) )
        local integer cost = LoadInteger( udg_hash, id, StringHash( "stblst" ) )
        local integer spell = LoadInteger( udg_hash, id, StringHash( "stblstsp" ) )
        local integer lvl = LoadInteger( udg_hash, id, StringHash( "stblstlvl" ) )
        
        if spell != 0 and IsUnitHasAbility(caster, spell) then
            call BlzSetUnitAbilityManaCost( caster, spell, lvl, cost )
        endif
        call FlushChildHashtable( udg_hash, id )
        
        set caster = null
    endfunction

    private function Cast_Actions takes nothing returns nothing
        local unit caster = GetSpellAbilityUnit()
        local integer id = GetHandleId( caster )
        local integer spell = GetSpellAbilityId()
        local integer lvl = GetUnitAbilityLevel(caster, spell ) - 1
        local integer cost = BlzGetAbilityManaCost( spell, lvl )

        call RemoveEffect(caster, EFFECT, BUFF)
        call BlzSetUnitAbilityManaCost( caster, spell, lvl, 0 )
        call PlaySpecialEffect(ANIMATION, caster)

        set id = InvokeTimerWithUnit( caster, "stblst", 0.01, false, function StabilizationEnd )
        call SaveInteger( udg_hash, id, StringHash( "stblst" ), cost )
        call SaveInteger( udg_hash, id, StringHash( "stblstlvl" ), lvl )
        call SaveInteger( udg_hash, id, StringHash( "stblstsp" ), spell )

        set caster = null
    endfunction
    
    
    //Delete Buff
    private function DeleteBuff_Conditions takes nothing returns boolean
        return IsUnitHasAbility( Event_DeleteBuff_Unit, EFFECT)
    endfunction
    
    private function DeleteBuff takes nothing returns nothing
        call RemoveEffect( Event_DeleteBuff_Unit, EFFECT, BUFF )
    endfunction

    //===========================================================================
    private function init takes nothing returns nothing
        local trigger trig 
    
        set trig = CreateTrigger()
        call TriggerRegisterAnyUnitEventBJ( trig, EVENT_PLAYER_UNIT_SPELL_EFFECT )
        call TriggerAddCondition( trig, Condition( function Trig_Stabilization_Conditions ) )
        call TriggerAddAction( trig, function Trig_Stabilization_Actions )
        
        set trig = CreateTrigger()
        call TriggerRegisterAnyUnitEventBJ( trig, EVENT_PLAYER_UNIT_SPELL_EFFECT )
        call TriggerAddCondition( trig, Condition( function Cast_Conditions ) )
        call TriggerAddAction( trig, function Cast_Actions )
        
        call CreateEventTrigger( "Event_DeleteBuff_Real", function DeleteBuff, function DeleteBuff_Conditions )
        
        set trig = null
    endfunction

endscope