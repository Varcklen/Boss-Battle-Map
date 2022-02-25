function Trig_Star_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A142' and not( udg_fightmod[3] ) and combat( GetSpellAbilityUnit(), true, 'A0EU' )
endfunction

function Trig_Star_Actions takes nothing returns nothing
    call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\Human\\HolyBolt\\HolyBoltSpecialArt.mdl", GetSpellTargetUnit(), "origin" ) )
    call healst( GetSpellAbilityUnit(), GetSpellTargetUnit(), GetUnitState( GetSpellTargetUnit(), UNIT_STATE_MAX_LIFE) )
    call manast( GetSpellAbilityUnit(), GetSpellTargetUnit(), GetUnitState( GetSpellTargetUnit(), UNIT_STATE_MAX_MANA) )
    call stazisst( GetSpellAbilityUnit(), GetItemOfTypeFromUnitBJ( GetSpellAbilityUnit(), 'I04G') )
endfunction

//===========================================================================
function InitTrig_Star takes nothing returns nothing
    set gg_trg_Star = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Star, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Star, Condition( function Trig_Star_Conditions ) )
    call TriggerAddAction( gg_trg_Star, function Trig_Star_Actions )
endfunction

