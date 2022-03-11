function Trig_OrbLich_King_Conditions takes nothing returns boolean
    return inv(GetSpellAbilityUnit(), 'I0FY') > 0 and luckylogic( GetSpellAbilityUnit(), 25, 1, 100 )
endfunction

function Trig_OrbLich_King_Actions takes nothing returns nothing
    set bj_lastCreatedUnit = resst( GetOwningPlayer( GetSpellAbilityUnit() ), GetUnitX(GetSpellAbilityUnit()) + GetRandomReal(-200, 200), GetUnitY(GetSpellAbilityUnit()) + GetRandomReal(-200, 200), GetUnitFacing( GetSpellAbilityUnit() ) )
    call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\SoulRitual.mdx", bj_lastCreatedUnit, "origin"))
    call UnitApplyTimedLife( bj_lastCreatedUnit, 'BTLF', 20 )
endfunction

//===========================================================================
function InitTrig_OrbLich_King takes nothing returns nothing
    set gg_trg_OrbLich_King = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_OrbLich_King, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_OrbLich_King, Condition( function Trig_OrbLich_King_Conditions ) )
    call TriggerAddAction( gg_trg_OrbLich_King, function Trig_OrbLich_King_Actions )
endfunction

