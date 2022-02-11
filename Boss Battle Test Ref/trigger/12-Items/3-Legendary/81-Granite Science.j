function Trig_Granite_Science_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0PO'
endfunction

function Trig_Granite_Science_Actions takes nothing returns nothing
    local integer x
    local unit caster
    
    if CastLogic() then
        set caster = udg_Caster
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( udg_string[0] + GetObjectName('A0PO'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
    endif
    
    set x = eyest( caster )
    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Items\\TomeOfRetraining\\TomeOfRetrainingCaster.mdl", GetUnitX( caster ), GetUnitY( caster ) ) )
    call UnitAddAbility( caster, 'A0PN' )
        
    set caster = null
endfunction

//===========================================================================
function InitTrig_Granite_Science takes nothing returns nothing
    set gg_trg_Granite_Science = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Granite_Science, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Granite_Science, Condition( function Trig_Granite_Science_Conditions ) )
    call TriggerAddAction( gg_trg_Granite_Science, function Trig_Granite_Science_Actions )
endfunction

