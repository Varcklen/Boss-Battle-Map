function Trig_DruidP_Conditions takes nothing returns boolean
    return GetUnitAbilityLevel(GetSpellAbilityUnit(), 'A00F') > 0 and luckylogic( GetSpellAbilityUnit(), 10 + ( 8 * GetUnitAbilityLevel(GetSpellAbilityUnit(), 'A00F') ), 1, 100 )
endfunction

function Trig_DruidP_Actions takes nothing returns nothing
    call healst( GetSpellAbilityUnit(), null, 50 )
    call manast( GetSpellAbilityUnit(), null, 50 )
    call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\Items\\AIil\\AIilTarget.mdl", GetSpellAbilityUnit(), "origin" ) )
endfunction

//===========================================================================
function InitTrig_DruidP takes nothing returns nothing
    set gg_trg_DruidP = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_DruidP, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_DruidP, Condition( function Trig_DruidP_Conditions ) )
    call TriggerAddAction( gg_trg_DruidP, function Trig_DruidP_Actions )
endfunction

