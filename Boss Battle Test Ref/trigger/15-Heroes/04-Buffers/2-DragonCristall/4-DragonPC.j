function Trig_DragonPC_Conditions takes nothing returns boolean
    return GetUnitAbilityLevel( GetSpellAbilityUnit(), 'A08E' ) > 0 and combat( GetSpellAbilityUnit(), false, 0 ) and GetUnitTypeId(GetSpellAbilityUnit()) != 'u000' and luckylogic( GetSpellAbilityUnit(), 2 * GetUnitAbilityLevel( GetSpellAbilityUnit(), 'A08E'), 1, 100 ) and not(udg_fightmod[3])
endfunction

function Trig_DragonPC_Actions takes nothing returns nothing
    call crist( GetSpellAbilityUnit(), 1 )
    call healst( GetSpellAbilityUnit(), null, GetUnitState( GetSpellAbilityUnit(), UNIT_STATE_MAX_LIFE) * 0.02 )
    call manast( GetSpellAbilityUnit(), null, GetUnitState( GetSpellAbilityUnit(), UNIT_STATE_MAX_MANA) * 0.02 )
endfunction

//===========================================================================
function InitTrig_DragonPC takes nothing returns nothing
    set gg_trg_DragonPC = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_DragonPC, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_DragonPC, Condition( function Trig_DragonPC_Conditions ) )
    call TriggerAddAction( gg_trg_DragonPC, function Trig_DragonPC_Actions )
endfunction

