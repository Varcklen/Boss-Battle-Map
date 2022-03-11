function Trig_SirenaQ_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A08R'
endfunction

function Trig_SirenaQ_Actions takes nothing returns nothing
    local unit caster
    local unit target
    local integer lvl
    local real dmg
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
        set lvl = udg_Level
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 300, "enemy", "org", "", "", "" )
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A08R'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
    endif
    set dmg = GetHeroAgi(caster, true) * ( 3 + ( 1 * lvl ) )
    
    call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", target, "origin") )
    call dummyspawn( caster, 1, 0, 0, 0 )
    call UnitDamageTarget( bj_lastCreatedUnit, target, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)

    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_SirenaQ takes nothing returns nothing
    set gg_trg_SirenaQ = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_SirenaQ, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_SirenaQ, Condition( function Trig_SirenaQ_Conditions ) )
    call TriggerAddAction( gg_trg_SirenaQ, function Trig_SirenaQ_Actions )
endfunction

