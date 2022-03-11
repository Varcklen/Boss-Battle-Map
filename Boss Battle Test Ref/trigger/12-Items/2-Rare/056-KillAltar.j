function Trig_KillAltar_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A02Q' and combat( GetSpellAbilityUnit(), true, 'A02Q' )
endfunction

function Trig_KillAltar_Actions takes nothing returns nothing
    local unit caster
    local integer x
    
    if CastLogic() then
        set caster = udg_Caster
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( udg_string[0] + GetObjectName('A02Q'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
    endif

    set x = eyest( caster )
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Items\\AIso\\AIsoTarget.mdl", caster, "origin") )
    call dummyspawn( caster, 0, 'A02R', 'A02S', 0 )
    call KillUnit( caster )
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_KillAltar takes nothing returns nothing
    set gg_trg_KillAltar = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_KillAltar, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_KillAltar, Condition( function Trig_KillAltar_Conditions ) )
    call TriggerAddAction( gg_trg_KillAltar, function Trig_KillAltar_Actions )
endfunction

