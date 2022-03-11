function Trig_Mutation_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A13S'
endfunction

function Trig_Mutation_Actions takes nothing returns nothing
    local unit caster
    local unit target
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "ally", "pris", "", "", "" )
        call textst( udg_string[0] + GetObjectName('A13S'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
    endif
    
    call KillUnit( target )
    call ShowUnit(target, false)
    set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( target ), udg_Database_RandomUnit[GetRandomInt(1, udg_Database_NumberItems[5])], GetUnitX( target ), GetUnitY( target ), GetUnitFacing(target) )
    call UnitApplyTimedLife( bj_lastCreatedUnit, 'BTLF', 15)
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Orc\\FeralSpirit\\feralspirittarget.mdl", bj_lastCreatedUnit, "origin" ) )
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_Mutation takes nothing returns nothing
    set gg_trg_Mutation = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Mutation, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Mutation, Condition( function Trig_Mutation_Conditions ) )
    call TriggerAddAction( gg_trg_Mutation, function Trig_Mutation_Actions )
endfunction

