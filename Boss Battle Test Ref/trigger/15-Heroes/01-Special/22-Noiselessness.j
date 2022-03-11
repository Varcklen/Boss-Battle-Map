globals
    constant integer NOISELESSNESS_HEAL = 100
    constant integer NOISELESSNESS_DURATION = 4
endglobals

function Trig_Noiselessness_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0G7'
endfunction

function Trig_Noiselessness_Actions takes nothing returns nothing
    local integer id 
    local integer r
    local integer rsum
    local real b
    local unit caster
    local real t
    
    if CastLogic() then
        set caster = udg_Caster
        set t = udg_Time
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( udg_string[0] + GetObjectName('A0G7'), caster, 64, 90, 10, 1.5 )
        set t = 4
    else
        set caster = GetSpellAbilityUnit()
        set t = 4
    endif
    set t = timebonus(caster, t)
    
    call DestroyEffect( AddSpecialEffect("Abilities\\Spells\\Human\\Invisibility\\InvisibilityTarget.mdl", GetUnitX(caster), GetUnitY(caster) ) )
    call healst(caster, null, NOISELESSNESS_HEAL)
    
    call shadowst( caster )
    call bufallst( caster, null, 'A0GK', 0, 0, 0, 0, 0, "nsll", NOISELESSNESS_DURATION )
    call effst( caster, caster, null, 1, t )
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_Noiselessness takes nothing returns nothing
    set gg_trg_Noiselessness = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Noiselessness, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Noiselessness, Condition( function Trig_Noiselessness_Conditions ) )
    call TriggerAddAction( gg_trg_Noiselessness, function Trig_Noiselessness_Actions )
endfunction

scope Noiselessness initializer Triggs
    private function Use takes nothing returns nothing
        call UnitRemoveAbility(Event_DeleteBuff_Unit, 'A0GK')
    endfunction
    
    private function Triggs takes nothing returns nothing
        local trigger trig = CreateTrigger()
        call TriggerRegisterVariableEvent( trig, "Event_DeleteBuff_Real", EQUAL, 1.00 )
        call TriggerAddAction( trig, function Use)
        
        set trig = null
    endfunction
endscope

