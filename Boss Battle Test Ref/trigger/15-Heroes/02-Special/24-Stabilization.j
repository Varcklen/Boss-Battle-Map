function Trig_Stabilization_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0GR' 
endfunction

function Trig_Stabilization_Actions takes nothing returns nothing
    local unit caster
    
    if CastLogic() then
        set caster = udg_Caster
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( udg_string[0] + GetObjectName('A0GR'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
    endif

    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Items\\AIim\\AIimTarget.mdl", GetUnitX( caster ), GetUnitY( caster ) ) )
    call UnitAddAbility(caster, 'A0GS')
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_Stabilization takes nothing returns nothing
    set gg_trg_Stabilization = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Stabilization, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Stabilization, Condition( function Trig_Stabilization_Conditions ) )
    call TriggerAddAction( gg_trg_Stabilization, function Trig_Stabilization_Actions )
endfunction

