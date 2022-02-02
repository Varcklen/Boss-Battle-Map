function Trig_BalanceSub_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A050'
endfunction

function Trig_BalanceSub_Actions takes nothing returns nothing
    local integer x
    local unit caster
    
    if CastLogic() then
        set caster = udg_Caster
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( udg_string[0] + GetObjectName('A050'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
    endif
    
    set x = eyest( caster )
    call DestroyEffect( AddSpecialEffectTarget( "war3mapImported\\HolyAwakening.mdx", caster, "origin") )
    call SetUnitState( caster, UNIT_STATE_LIFE, GetUnitState( caster, UNIT_STATE_MAX_LIFE) * 0.5 )
    call SetUnitState( caster, UNIT_STATE_MANA, GetUnitState( caster, UNIT_STATE_MAX_MANA) * 0.5 )
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_BalanceSub takes nothing returns nothing
    set gg_trg_BalanceSub = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_BalanceSub, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_BalanceSub, Condition( function Trig_BalanceSub_Conditions ) )
    call TriggerAddAction( gg_trg_BalanceSub, function Trig_BalanceSub_Actions )
endfunction

