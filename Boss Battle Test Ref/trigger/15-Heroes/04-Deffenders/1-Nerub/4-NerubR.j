function Trig_NerubR_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0B8'
endfunction

function Trig_NerubR_Actions takes nothing returns nothing
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
        call textst( udg_string[0] + GetObjectName('A0B8'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
    endif
    set dmg = 60. + ( 40. * lvl )
    
    call dummyspawn( caster, 1, 0, 0, 0 )
    call UnitDamageTarget( bj_lastCreatedUnit, target, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)

    if (GetUnitState( caster, UNIT_STATE_LIFE) >= GetUnitState( target, UNIT_STATE_LIFE) and luckylogic( caster, 20 * lvl, 1, 100 )) or (not(IsUnitType( target, UNIT_TYPE_HERO)) and not(IsUnitType( target, UNIT_TYPE_ANCIENT)) ) then
        call KillUnit( target )
        call DestroyEffect(AddSpecialEffect("Objects\\Spawnmodels\\Human\\HumanLargeDeathExplode\\HumanLargeDeathExplode.mdl", GetUnitX( target ), GetUnitY( target ) ))
    else
        call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", GetUnitX( target ), GetUnitY( target ) ) )
    endif
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_NerubR takes nothing returns nothing
    set gg_trg_NerubR = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_NerubR, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_NerubR, Condition( function Trig_NerubR_Conditions ) )
    call TriggerAddAction( gg_trg_NerubR, function Trig_NerubR_Actions )
endfunction

