function Trig_Taro_Strength_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0OA'
endfunction

function Trig_Taro_Strength_Actions takes nothing returns nothing
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Demon\\DarkPortal\\DarkPortalTarget.mdl", GetSpellAbilityUnit(), "origin" ) )
    call UnitAddAbility( GetSpellAbilityUnit(), 'A0O9')
    call stazisst( GetSpellAbilityUnit(), GetItemOfTypeFromUnitBJ( GetSpellAbilityUnit(), 'I07R') )
endfunction

//===========================================================================
function InitTrig_Taro_Strength takes nothing returns nothing
    set gg_trg_Taro_Strength = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Taro_Strength, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Taro_Strength, Condition( function Trig_Taro_Strength_Conditions ) )
    call TriggerAddAction( gg_trg_Taro_Strength, function Trig_Taro_Strength_Actions )
endfunction

