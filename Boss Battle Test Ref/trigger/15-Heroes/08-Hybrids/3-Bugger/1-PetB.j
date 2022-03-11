function Trig_PetB_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0ND'
endfunction

function Trig_PetB_Actions takes nothing returns nothing
    local real dmg = 100. + ( 40. * GetUnitAbilityLevel( LoadUnitHandle( udg_hash, GetHandleId( GetSpellAbilityUnit() ), StringHash( "bggrac" ) ), 'A105') )

    call dummyspawn( GetSpellAbilityUnit(), 1, 0, 0, 0 )
    call UnitDamageTarget( bj_lastCreatedUnit, GetSpellTargetUnit(), dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", GetSpellTargetUnit(), "origin" ) )
endfunction

//===========================================================================
function InitTrig_PetB takes nothing returns nothing
    set gg_trg_PetB = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_PetB, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_PetB, Condition( function Trig_PetB_Conditions ) )
    call TriggerAddAction( gg_trg_PetB, function Trig_PetB_Actions )
endfunction

