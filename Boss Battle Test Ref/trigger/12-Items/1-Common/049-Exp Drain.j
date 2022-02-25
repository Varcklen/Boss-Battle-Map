function Trig_Exp_Drain_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0FR'
endfunction

function Trig_Exp_Drain_Actions takes nothing returns nothing
    call statst( GetSpellTargetUnit(), 2, 2, 2, 0, true )
    call SetHeroLevel( GetSpellTargetUnit(), GetHeroLevel(GetSpellTargetUnit()) + 1, true)

    set udg_logic[GetPlayerId(GetOwningPlayer(GetSpellAbilityUnit())) + 1 + 43] = true
    call stazisst( GetSpellAbilityUnit(), GetItemOfTypeFromUnitBJ( GetSpellAbilityUnit(), 'I08A') )
endfunction

//===========================================================================
function InitTrig_Exp_Drain takes nothing returns nothing
    set gg_trg_Exp_Drain = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Exp_Drain, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Exp_Drain, Condition( function Trig_Exp_Drain_Conditions ) )
    call TriggerAddAction( gg_trg_Exp_Drain, function Trig_Exp_Drain_Actions )
endfunction

