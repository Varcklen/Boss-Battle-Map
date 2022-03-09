function Trig_DryadEC_Conditions takes nothing returns boolean
    return luckylogic( GetSpellAbilityUnit(), 1+GetUnitAbilityLevel( GetSpellAbilityUnit(), 'A0I9'), 1, 100 ) and not( udg_fightmod[3] ) and GetUnitAbilityLevel( GetSpellAbilityUnit(), 'A0I9') > 0 and combat( GetSpellAbilityUnit(), false, 0 )
endfunction

function Trig_DryadEC_Actions takes nothing returns nothing
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Items\\AIem\\AIemTarget.mdl", GetSpellAbilityUnit(), "origin") )
    call statst( GetSpellAbilityUnit(), 0, 0, 1, 208, true )
    call textst( "|c002020FF +1 intelligence", GetSpellAbilityUnit(), 64, 90, 10, 1 )
endfunction

//===========================================================================
function InitTrig_DryadEC takes nothing returns nothing
    set gg_trg_DryadEC = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_DryadEC, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_DryadEC, Condition( function Trig_DryadEC_Conditions ) )
    call TriggerAddAction( gg_trg_DryadEC, function Trig_DryadEC_Actions )
endfunction

