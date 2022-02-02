function Trig_RikGreed_Conditions takes nothing returns boolean
    return inv(GetSpellAbilityUnit(), 'I03W') > 0 and Uniques_Logic(GetSpellAbilityId())
endfunction

function Trig_RikGreed_Actions takes nothing returns nothing
    local unit target = randomtarget( GetSpellAbilityUnit(), 600, "ally", "notfull", "", "", "" ) 
    
    if target != null then
        call healst( GetSpellAbilityUnit(), target, 100 )
        call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\Other\\Incinerate\\FireLordDeathExplode.mdl", target, "origin") )
    endif
    
    set target = randomtarget( GetSpellAbilityUnit(), 600, "enemy", "", "", "", "" )
    if target != null then
        call dummyspawn( GetSpellAbilityUnit(), 1, 0, 0, 0 )
        call DestroyEffect( AddSpecialEffect("Abilities\\Spells\\Other\\Incinerate\\FireLordDeathExplode.mdl", GetUnitX( target ), GetUnitY( target ) ) )
        call UnitDamageTarget( bj_lastCreatedUnit, target, 100, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )
    endif
    
    set target = null
endfunction

//===========================================================================
function InitTrig_RikGreed takes nothing returns nothing
    set gg_trg_RikGreed = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_RikGreed, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_RikGreed, Condition( function Trig_RikGreed_Conditions ) )
    call TriggerAddAction( gg_trg_RikGreed, function Trig_RikGreed_Actions )
endfunction

