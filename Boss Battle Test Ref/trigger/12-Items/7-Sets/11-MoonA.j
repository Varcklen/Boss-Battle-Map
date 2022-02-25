function Trig_MoonA_Conditions takes nothing returns boolean
    return GetUnitAbilityLevel(GetSpellAbilityUnit(), 'B08W') > 0
endfunction

function Trig_MoonA_Actions takes nothing returns nothing
    call MoonTrigger(GetSpellAbilityUnit())
endfunction

//===========================================================================
function InitTrig_MoonA takes nothing returns nothing
    set gg_trg_MoonA = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_MoonA, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_MoonA, Condition( function Trig_MoonA_Conditions ) )
    call TriggerAddAction( gg_trg_MoonA, function Trig_MoonA_Actions )
endfunction

