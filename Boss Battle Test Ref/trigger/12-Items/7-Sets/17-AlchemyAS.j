function Trig_AlchemyAS_Conditions takes nothing returns boolean
    return GetUnitAbilityLevel(GetSpellAbilityUnit(), 'B08X') > 0 and luckylogic( GetSpellAbilityUnit(), 8, 1, 100 )
endfunction

function Trig_AlchemyAS_Actions takes nothing returns nothing
    local integer rand = GetRandomInt(1, 10)

    set udg_Caster = GetSpellAbilityUnit()
    set udg_RandomLogic = true
    call TriggerExecute( udg_DB_Trigger_Pot[rand] )
endfunction

//===========================================================================
function InitTrig_AlchemyAS takes nothing returns nothing
    set gg_trg_AlchemyAS = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_AlchemyAS, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_AlchemyAS, Condition( function Trig_AlchemyAS_Conditions ) )
    call TriggerAddAction( gg_trg_AlchemyAS, function Trig_AlchemyAS_Actions )
endfunction

