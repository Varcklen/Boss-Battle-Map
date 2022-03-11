function Trig_Taunt_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A19P'
endfunction

function Trig_Taunt_Actions takes nothing returns nothing
    local unit caster
    local unit target
    local real t
    local integer x
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
        set t = udg_Time
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 600, "enemy", "org", "", "", "" )
        call textst( udg_string[0] + GetObjectName('A19P'), caster, 64, 90, 10, 1.5 )
        set t = 6
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set t = 6
    endif
    set t = timebonus(caster, t)

    if GetUnitAbilityLevel(target, 'B059') > 0 then
        call dummyspawn( caster, 1, 0, 0, 0 )
        call UnitDamageTarget( bj_lastCreatedUnit, target, 150, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
    endif
    if GetUnitState( target, UNIT_STATE_LIFE) > 0.405 then
        call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\NightElf\\Taunt\\TauntCaster.mdl" , caster, "origin" ) )
        call taunt( caster, target, t )
    endif
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_Taunt takes nothing returns nothing
    set gg_trg_Taunt = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Taunt, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Taunt, Condition( function Trig_Taunt_Conditions ) )
    call TriggerAddAction( gg_trg_Taunt, function Trig_Taunt_Actions )
endfunction

