function Trig_Ring_of_Addiction_Conditions takes nothing returns boolean
    return inv(GetSpellAbilityUnit(), 'I0G4') > 0 and Uniques_Logic(GetSpellAbilityId()) and LuckChance( GetSpellAbilityUnit(), 40 )
endfunction

function Trig_Ring_of_Addiction_Actions takes nothing returns nothing
    set udg_Caster = GetSpellAbilityUnit()
    set udg_RandomLogic = true
    call TriggerExecute( udg_DB_Trigger_Pot[GetRandomInt( 1, 10 )] )
endfunction

//===========================================================================
function InitTrig_Ring_of_Addiction takes nothing returns nothing
    set gg_trg_Ring_of_Addiction = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Ring_of_Addiction, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Ring_of_Addiction, Condition( function Trig_Ring_of_Addiction_Conditions ) )
    call TriggerAddAction( gg_trg_Ring_of_Addiction, function Trig_Ring_of_Addiction_Actions )
endfunction

