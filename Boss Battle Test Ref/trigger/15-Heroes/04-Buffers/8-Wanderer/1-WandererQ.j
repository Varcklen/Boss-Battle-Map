function Trig_WandererQ_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0JF'
endfunction

function Trig_WandererQ_Actions takes nothing returns nothing
    local unit caster
    local unit target
    local unit n
    local integer lvl
    local real dmg
    local real sh
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
        set lvl = udg_Level
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "enemy", "", "", "", "" )
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A0JF'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
    endif
    set dmg = 30 + ( 20 * lvl )
    set sh = 50 + ( 30 * lvl )
    
    set n = randomtarget( target, 300, "enemy", "hero", "", "", "" )
    if n != null then
        call shield( caster, n, sh, 60 )
    endif
    call DestroyEffect( AddSpecialEffectTarget("DarkSwirl.mdx", target, "overhead") )
    call UnitStun(caster, target, 0.25 )
    call dummyspawn( caster, 1, 0, 0, 0 )
    call UnitDamageTarget(bj_lastCreatedUnit, target, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_WandererQ takes nothing returns nothing
    set gg_trg_WandererQ = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_WandererQ, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_WandererQ, Condition( function Trig_WandererQ_Conditions ) )
    call TriggerAddAction( gg_trg_WandererQ, function Trig_WandererQ_Actions )
endfunction

