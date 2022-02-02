function Trig_Malice_Conditions takes nothing returns boolean
    return combat( GetSpellAbilityUnit(), false, 0 ) and not( udg_fightmod[3] ) and IsUnitInGroup(GetSpellAbilityUnit(), udg_heroinfo)
endfunction

function Trig_Malice_Actions takes nothing returns nothing
    call spdst( GetSpellAbilityUnit(), 0.1 )
    call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\Undead\\DeathPact\\DeathPactTarget.mdl", GetSpellAbilityUnit(), "origin" ) )
endfunction

//===========================================================================
function InitTrig_Malice takes nothing returns nothing
    set gg_trg_Malice = CreateTrigger(  )
    call DisableTrigger( gg_trg_Malice )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Malice, EVENT_PLAYER_UNIT_SPELL_FINISH )
    call TriggerAddCondition( gg_trg_Malice, Condition( function Trig_Malice_Conditions ) )
    call TriggerAddAction( gg_trg_Malice, function Trig_Malice_Actions )
endfunction

