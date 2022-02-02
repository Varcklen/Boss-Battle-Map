function Trig_ShoggothEC_Conditions takes nothing returns boolean
    return GetUnitAbilityLevel( GetSpellAbilityUnit(), 'A198' ) > 0 and GetUnitTypeId(GetSpellAbilityUnit()) != 'u000' and luckylogic( GetSpellAbilityUnit(), 1 + GetUnitAbilityLevel( GetSpellAbilityUnit(), 'A198'), 1, 100 )
endfunction

function Trig_ShoggothEC_Actions takes nothing returns nothing
    call ShoggothTent( GetSpellAbilityUnit() )
endfunction

//===========================================================================
function InitTrig_ShoggothEC takes nothing returns nothing
    set gg_trg_ShoggothEC = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_ShoggothEC, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_ShoggothEC, Condition( function Trig_ShoggothEC_Conditions ) )
    call TriggerAddAction( gg_trg_ShoggothEC, function Trig_ShoggothEC_Actions )
endfunction

