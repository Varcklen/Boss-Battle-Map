function Trig_Plush_doll_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A16W'
endfunction

function Trig_Plush_doll_Actions takes nothing returns nothing
    local integer x
    local unit caster
    local unit target
    local real hp
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "ally", "", "", "", "" )
        call textst( udg_string[0] + GetObjectName('A16W'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
    endif

    set x = eyest( caster )
    set hp = GetUnitState(target, UNIT_STATE_LIFE)/GetUnitState(target, UNIT_STATE_MAX_LIFE)
    
    call SetUnitState( caster, UNIT_STATE_LIFE, GetUnitState( caster, UNIT_STATE_MAX_LIFE) * hp )
    call DestroyEffect( AddSpecialEffectTarget( "Blood Explosion.mdx", target, "origin" ) )
    call DestroyEffect( AddSpecialEffectTarget( "Blood Explosion.mdx", caster, "origin" ) )    
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_Plush_doll takes nothing returns nothing
    set gg_trg_Plush_doll = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Plush_doll, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Plush_doll, Condition( function Trig_Plush_doll_Conditions ) )
    call TriggerAddAction( gg_trg_Plush_doll, function Trig_Plush_doll_Actions )
endfunction

