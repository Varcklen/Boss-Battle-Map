function Trig_VampireSkill_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A00U'
endfunction

function Trig_VampireSkill_Actions takes nothing returns nothing
    local unit caster
    local unit target
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 600, "enemy", "", "", "", "" )
        call textst( udg_string[0] + GetObjectName('A00U'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
    endif
    
    call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl" , target, "origin" ) )
    call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\Undead\\VampiricAura\\VampiricAuraTarget.mdl" , caster, "origin" ) )
    call dummyspawn( caster, 1, 0, 0, 0 )
    call UnitDamageTarget( bj_lastCreatedUnit, target, 200, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
    call healst( GetSpellAbilityUnit(), null, 200 )
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_VampireSkill takes nothing returns nothing
    set gg_trg_VampireSkill = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_VampireSkill, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_VampireSkill, Condition( function Trig_VampireSkill_Conditions ) )
    call TriggerAddAction( gg_trg_VampireSkill, function Trig_VampireSkill_Actions )
endfunction

