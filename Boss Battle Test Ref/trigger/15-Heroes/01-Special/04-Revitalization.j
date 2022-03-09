function Trig_Revitalization_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A19R'
endfunction

function Trig_Revitalization_Actions takes nothing returns nothing
    local integer id
    local unit caster
    local real x
    local real y

    if CastLogic() then
        set caster = udg_Caster
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( udg_string[0] + GetObjectName('A19R'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
    endif
    
    set x = GetUnitX( caster ) + 200 * Cos( 0.017 * GetUnitFacing( caster ) )
    set y = GetUnitY( caster ) + 200 * Sin( 0.017 * GetUnitFacing( caster ) )

    set bj_lastCreatedUnit = resst( GetOwningPlayer( GetSpellAbilityUnit() ), x, y, GetUnitFacing( GetSpellAbilityUnit() ) )
    call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Undead\\AnimateDead\\AnimateDeadTarget.mdl", bj_lastCreatedUnit, "origin"))
    call UnitApplyTimedLife( bj_lastCreatedUnit, 'BTLF', 25 )
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_Revitalization takes nothing returns nothing
    set gg_trg_Revitalization = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Revitalization, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Revitalization, Condition( function Trig_Revitalization_Conditions ) )
    call TriggerAddAction( gg_trg_Revitalization, function Trig_Revitalization_Actions )
endfunction

