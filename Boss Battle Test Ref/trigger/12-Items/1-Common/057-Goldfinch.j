function Trig_Goldfinch_Conditions takes nothing returns boolean
    return not( udg_fightmod[3] ) and inv(GetSpellAbilityUnit(), 'I06A') > 0 and luckylogic( GetSpellAbilityUnit(), 1, 1, 100 ) and combat( GetSpellAbilityUnit(), false, 0 )
endfunction

function Trig_Goldfinch_Actions takes nothing returns nothing
    local integer i = GetPlayerId( GetOwningPlayer( GetSpellAbilityUnit() ) ) + 1
    
    call luckyst( GetSpellAbilityUnit(), 1 )
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Items\\ResourceItems\\ResourceEffectTarget.mdl", GetSpellAbilityUnit(), "origin") )
    call textst( "|c00FFFF00 +1 to luck", GetSpellAbilityUnit(), 64, 90, 10, 1.5 )
    set udg_Data[i + 60] = udg_Data[i + 60] + 1
endfunction

//===========================================================================
function InitTrig_Goldfinch takes nothing returns nothing
    set gg_trg_Goldfinch = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Goldfinch, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Goldfinch, Condition( function Trig_Goldfinch_Conditions ) )
    call TriggerAddAction( gg_trg_Goldfinch, function Trig_Goldfinch_Actions )
endfunction

