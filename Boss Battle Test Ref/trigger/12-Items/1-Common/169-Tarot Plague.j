function Trig_Tarot_Plague_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A13H'
endfunction

function Trig_Tarot_Plague_Actions takes nothing returns nothing
    local integer cyclA = 0
    local integer cyclAEnd
    local integer i = GetPlayerId(GetOwningPlayer(GetSpellAbilityUnit())) + 1
    
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Undead\\AnimateDead\\AnimateDeadTarget.mdl", GetSpellAbilityUnit(), "origin") )
    call UnitAddAbility( GetSpellAbilityUnit(), 'A13V')

    call NewUniques( GetSpellAbilityUnit(), 0 )
    //call UnitRemoveAbility( GetSpellAbilityUnit(), udg_Ability_Uniq[i] )
    //set udg_Ability_Uniq[i] = 0
    
    call stazisst( GetSpellAbilityUnit(), GetItemOfTypeFromUnitBJ( GetSpellAbilityUnit(), 'I0B8') )
endfunction

//===========================================================================
function InitTrig_Tarot_Plague takes nothing returns nothing
    set gg_trg_Tarot_Plague = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Tarot_Plague, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Tarot_Plague, Condition( function Trig_Tarot_Plague_Conditions ) )
    call TriggerAddAction( gg_trg_Tarot_Plague, function Trig_Tarot_Plague_Actions )
endfunction

