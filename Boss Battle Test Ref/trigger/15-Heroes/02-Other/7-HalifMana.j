function Trig_HalifMana_Conditions takes nothing returns boolean
    return GetUnitAbilityLevel( GetSpellAbilityUnit(), 'B062' ) > 0
endfunction

function Trig_HalifMana_Actions takes nothing returns nothing
    call manast( GetSpellAbilityUnit(), null, 12 )
    call DestroyEffect(AddSpecialEffect( "Abilities\\Spells\\Undead\\ReplenishMana\\SpiritTouchTarget.mdl", GetUnitX(GetSpellAbilityUnit()), GetUnitY(GetSpellAbilityUnit()) ) )
endfunction

//===========================================================================
function InitTrig_HalifMana takes nothing returns nothing
    set gg_trg_HalifMana = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_HalifMana, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_HalifMana, Condition( function Trig_HalifMana_Conditions ) )
    call TriggerAddAction( gg_trg_HalifMana, function Trig_HalifMana_Actions )
endfunction