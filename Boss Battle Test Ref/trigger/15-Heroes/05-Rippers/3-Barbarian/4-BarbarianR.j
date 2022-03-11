function Trig_BarbarianR_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0TC'
endfunction

function Trig_BarbarianR_Actions takes nothing returns nothing
    local real dmg
    local unit caster
    local unit target
    local integer lvl
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
        set lvl = udg_Level
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 300, "enemy", "", "", "", "" )
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A0TC'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
    endif
    
    set dmg = 150 + ( 50 * lvl )
    
    call DestroyEffect( AddSpecialEffect("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", GetUnitX(target), GetUnitY(target) ) )
    call dummyspawn( caster, 1, 0, 0, 0 )
    call UnitDamageTarget( bj_lastCreatedUnit, target, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_BarbarianR takes nothing returns nothing
    set gg_trg_BarbarianR = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_BarbarianR, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_BarbarianR, Condition( function Trig_BarbarianR_Conditions ) )
    call TriggerAddAction( gg_trg_BarbarianR, function Trig_BarbarianR_Actions )
endfunction

