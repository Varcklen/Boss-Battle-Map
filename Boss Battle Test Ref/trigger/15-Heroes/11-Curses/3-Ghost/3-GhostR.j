function Trig_GhostR_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A08V'
endfunction

function Trig_GhostR_Actions takes nothing returns nothing
    local unit caster
    local unit target
    local integer lvl
    local real dmg
    local real dmgend = 0
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
        set lvl = udg_Level
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "enemy", "org", "", "", "" )
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A08V'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
    endif
    set dmg = 60 + ( 40 * lvl )
    set dmgend = dmg
    
    call DestroyEffect( AddSpecialEffectTarget("DarkSwirl.mdx", target, "overhead" ) )
    if GetUnitAbilityLevel( target, 'B01L') > 0 then
        set dmgend = dmgend + dmg
    endif
    call dummyspawn( caster, 1, 0, 0, 0 )
    call UnitDamageTarget( bj_lastCreatedUnit, target, dmgend, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )

    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_GhostR takes nothing returns nothing
    set gg_trg_GhostR = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_GhostR, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_GhostR, Condition( function Trig_GhostR_Conditions ) )
    call TriggerAddAction( gg_trg_GhostR, function Trig_GhostR_Actions )
endfunction

