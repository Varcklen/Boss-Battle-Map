function Trig_OrbTreantHeal_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A190' or GetSpellAbilityId() == 'A192'
endfunction

function Trig_OrbTreantHeal_Actions takes nothing returns nothing
    local unit caster = GetSpellAbilityUnit()
    local unit target = GetSpellTargetUnit()
    local real heal

    if GetSpellAbilityId() == 'A190' then
        call healst( caster, target, 75 )    
        call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\Human\\HolyBolt\\HolyBoltSpecialArt.mdl" , target, "origin" ) )
    else
        call manast( caster, target, 30 )
        call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\Items\\AIma\\AImaTarget.mdl" , target, "origin" ) )
    endif
    call KillUnit(caster)
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_OrbTreantHeal takes nothing returns nothing
    set gg_trg_OrbTreantHeal = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_OrbTreantHeal, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_OrbTreantHeal, Condition( function Trig_OrbTreantHeal_Conditions ) )
    call TriggerAddAction( gg_trg_OrbTreantHeal, function Trig_OrbTreantHeal_Actions )
endfunction

