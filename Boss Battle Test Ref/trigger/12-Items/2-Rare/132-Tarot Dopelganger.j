function Trig_Tarot_Dopelganger_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A060'
endfunction

function Trig_Tarot_Dopelganger_Actions takes nothing returns nothing
    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Items\\AIsm\\AIsmTarget.mdl", GetUnitX( GetSpellAbilityUnit() ), GetUnitY( GetSpellAbilityUnit() ) ) )
    call SetHeroAgi( GetSpellAbilityUnit(), GetHeroAgi( GetSpellTargetUnit(), false), true)
    call stazisst( GetSpellAbilityUnit(), GetItemOfTypeFromUnitBJ( GetSpellAbilityUnit(), 'I0FE') )
endfunction

//===========================================================================
function InitTrig_Tarot_Dopelganger takes nothing returns nothing
    set gg_trg_Tarot_Dopelganger = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Tarot_Dopelganger, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Tarot_Dopelganger, Condition( function Trig_Tarot_Dopelganger_Conditions ) )
    call TriggerAddAction( gg_trg_Tarot_Dopelganger, function Trig_Tarot_Dopelganger_Actions )
endfunction

