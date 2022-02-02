function Trig_OwlWC_Conditions takes nothing returns boolean
    return GetUnitAbilityLevel(GetSpellAbilityUnit(), 'B003') > 0 and GetSpellAbilityId() != 'A0E2'
endfunction

function Trig_OwlWC_Actions takes nothing returns nothing
    local real mana = LoadInteger( udg_hash, GetHandleId( GetSpellAbilityUnit() ), StringHash( "owlw" ) )

    call manast( GetSpellAbilityUnit(), null, mana )
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Undead\\ReplenishMana\\SpiritTouchTarget.mdl", GetSpellAbilityUnit(), "origin" ) )
endfunction

//===========================================================================
function InitTrig_OwlWC takes nothing returns nothing
    set gg_trg_OwlWC = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_OwlWC, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_OwlWC, Condition( function Trig_OwlWC_Conditions ) )
    call TriggerAddAction( gg_trg_OwlWC, function Trig_OwlWC_Actions )
endfunction

