function Trig_SkeletonLordW_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0CM'
endfunction

function Trig_SkeletonLordW_Actions takes nothing returns nothing
    local integer cyclA
    local integer cyclAEnd
    local integer rand
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
        set target = randomtarget( caster, 900, "enemy", "notundead", "", "", "" )
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A0CM'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
    endif
    set dmg = 20 + ( 40 * lvl )

    call dummyspawn( caster, 1, 0, 0, 0 )
    call UnitDamageTarget( bj_lastCreatedUnit, target, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
    call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Undead\\AnimateDead\\AnimateDeadTarget.mdl", target, "origin"))
    set cyclA = 1
    set cyclAEnd = GetRandomInt( 1, 4 )
    loop
        exitwhen cyclA > cyclAEnd
        call skeletsp( caster, target )
        set cyclA = cyclA + 1
    endloop
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_SkeletonLordW takes nothing returns nothing
    set gg_trg_SkeletonLordW = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_SkeletonLordW, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_SkeletonLordW, Condition( function Trig_SkeletonLordW_Conditions ) )
    call TriggerAddAction( gg_trg_SkeletonLordW, function Trig_SkeletonLordW_Actions )
endfunction

