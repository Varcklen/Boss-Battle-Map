function Trig_Equivalent_exchange_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A1B2'
endfunction

function Trig_Equivalent_exchange_Actions takes nothing returns nothing
    local unit caster
    
    if CastLogic() then
        set caster = udg_Caster
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( udg_string[0] + GetObjectName('A1B2'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
    endif
    
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Undead\\RaiseSkeletonWarrior\\RaiseSkeleton.mdl", caster, "origin" ) )
    call dummyspawn( caster, 1, 0, 0, 0 )
    if GetUnitState( caster, UNIT_STATE_LIFE) > 0.405 then
        call UnitDamageTarget( bj_lastCreatedUnit, caster, 100, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
        call manast( caster, null, 60 )
    endif

    set caster = null
endfunction

//===========================================================================
function InitTrig_Equivalent_exchange takes nothing returns nothing
    set gg_trg_Equivalent_exchange = CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Equivalent_exchange, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Equivalent_exchange, Condition( function Trig_Equivalent_exchange_Conditions ) )
    call TriggerAddAction( gg_trg_Equivalent_exchange, function Trig_Equivalent_exchange_Actions )
endfunction

