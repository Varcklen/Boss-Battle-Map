function Trig_Reflection_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A1B4'
endfunction

function Trig_Reflection_Actions takes nothing returns nothing
    local unit caster
    local unit target
    local real hpc
    local real mpc
    local real hpt
    local real mpt
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "ally", "notcaster", "hero", "", "" )
        call textst( udg_string[0] + GetObjectName('A1B4'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
    endif
    
    set hpc = GetUnitState(caster, UNIT_STATE_LIFE)/RMaxBJ(1,GetUnitState(caster, UNIT_STATE_MAX_LIFE))
    set mpc = GetUnitState(caster, UNIT_STATE_MANA)/RMaxBJ(1,GetUnitState(caster, UNIT_STATE_MAX_MANA))
    set hpt = GetUnitState(target, UNIT_STATE_LIFE)/RMaxBJ(1,GetUnitState(target, UNIT_STATE_MAX_LIFE))
    set mpt = GetUnitState(target, UNIT_STATE_MANA)/RMaxBJ(1,GetUnitState(target, UNIT_STATE_MAX_MANA))
    
    call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageCaster.mdl" , caster, "origin" ) )
    call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageCaster.mdl" , target, "origin" ) )
    
    call SetUnitState( caster, UNIT_STATE_LIFE, GetUnitState( caster, UNIT_STATE_MAX_LIFE) * hpt )
    call SetUnitState( caster, UNIT_STATE_MANA, GetUnitState( caster, UNIT_STATE_MAX_MANA) * mpt )
    call SetUnitState( target, UNIT_STATE_LIFE, GetUnitState( target, UNIT_STATE_MAX_LIFE) * hpc )
    call SetUnitState( target, UNIT_STATE_MANA, GetUnitState( target, UNIT_STATE_MAX_MANA) * mpc )
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_Reflection takes nothing returns nothing
    set gg_trg_Reflection = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Reflection, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Reflection, Condition( function Trig_Reflection_Conditions ) )
    call TriggerAddAction( gg_trg_Reflection, function Trig_Reflection_Actions )
endfunction

