function Trig_KillDagger_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A020'
endfunction

function Trig_KillDagger_Actions takes nothing returns nothing
    local unit caster
    local integer cyclA = 1
    local integer cyclAEnd
    
    if CastLogic() then
        set caster = udg_Caster
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( udg_string[0] + GetObjectName('A02H'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
    endif
    set cyclAEnd = eyest( caster )
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Undead\\RaiseSkeletonWarrior\\RaiseSkeleton.mdl", caster, "origin" ) )
    call dummyspawn( caster, 1, 0, 0, 0 )
    loop
        exitwhen cyclA > cyclAEnd
        if GetUnitState( caster, UNIT_STATE_LIFE) > 0.405 then
            call UnitDamageTarget( bj_lastCreatedUnit, caster, 150, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
            call manast( caster, null, 100 )
        endif
        set cyclA = cyclA + 1
    endloop
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_KillDagger takes nothing returns nothing
    set gg_trg_KillDagger = CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ( gg_trg_KillDagger, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_KillDagger, Condition( function Trig_KillDagger_Conditions ) )
    call TriggerAddAction( gg_trg_KillDagger, function Trig_KillDagger_Actions )
endfunction

