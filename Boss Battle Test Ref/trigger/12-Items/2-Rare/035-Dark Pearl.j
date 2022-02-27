function Trig_Dark_Pearl_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0ZO'
endfunction

function Trig_Dark_Pearl_Actions takes nothing returns nothing
    local integer id
    local unit caster
    local integer x
    
    if CastLogic() then
        set caster = udg_Target
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( udg_string[0] + GetObjectName('A0ZO'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
    endif

    set x = eyest( caster )
    call manast( caster, null, GetUnitState( caster, UNIT_STATE_MAX_MANA) )
    call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\Items\\TomeOfRetraining\\TomeOfRetrainingCaster.mdl", caster, "origin" ) )

    set caster = null
endfunction

//===========================================================================
function InitTrig_Dark_Pearl takes nothing returns nothing
    set gg_trg_Dark_Pearl = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Dark_Pearl, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Dark_Pearl, Condition( function Trig_Dark_Pearl_Conditions ) )
    call TriggerAddAction( gg_trg_Dark_Pearl, function Trig_Dark_Pearl_Actions )
endfunction

