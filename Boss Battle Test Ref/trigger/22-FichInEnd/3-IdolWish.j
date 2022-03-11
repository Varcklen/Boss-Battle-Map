function Trig_IdolWish_Conditions takes nothing returns boolean
    return inv( GetSpellAbilityUnit(), 'I09O') > 0
endfunction

function Trig_IdolWish_Actions takes nothing returns nothing
    call SetUnitState( GetSpellAbilityUnit(), UNIT_STATE_MANA, 0 )
endfunction

//===========================================================================
function InitTrig_IdolWish takes nothing returns nothing
    set gg_trg_IdolWish = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_IdolWish, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_IdolWish, Condition( function Trig_IdolWish_Conditions ) )
    call TriggerAddAction( gg_trg_IdolWish, function Trig_IdolWish_Actions )
endfunction

