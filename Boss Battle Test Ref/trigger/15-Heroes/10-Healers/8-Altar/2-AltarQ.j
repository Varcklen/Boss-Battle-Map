function Trig_AltarQ_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A122'
endfunction

function Trig_AltarQ_Actions takes nothing returns nothing
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
        set target = randomtarget( caster, 900, "all", "notcaster", "notfull", "", "" )
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A122'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
    endif
    set dmg = 160 + ( 40 * lvl )

    if GetUnitAbilityLevel( caster, 'A12W') > 0 then
        call DestroyEffect( AddSpecialEffect( "Blood Whirl.mdx", GetUnitX( target ), GetUnitY( target ) ) )
        call dummyspawn( caster, 1, 0, 0, 0 )
        call UnitDamageTarget( bj_lastCreatedUnit, target, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
        call healst( caster, null, dmg*1.5)
    else
        call DestroyEffect( AddSpecialEffect( "Blood Whirl.mdx", GetUnitX( target ), GetUnitY( target ) ) )
        call healst( caster, target, dmg)
        call SetUnitState( caster, UNIT_STATE_LIFE, RMaxBJ(0,GetUnitState( caster, UNIT_STATE_LIFE) - (95+(5*lvl)) ))
    endif
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_AltarQ takes nothing returns nothing
    set gg_trg_AltarQ = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_AltarQ, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_AltarQ, Condition( function Trig_AltarQ_Conditions ) )
    call TriggerAddAction( gg_trg_AltarQ, function Trig_AltarQ_Actions )
endfunction

