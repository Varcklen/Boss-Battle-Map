function Trig_Poof_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A11L'
endfunction

function Trig_Poof_Actions takes nothing returns nothing
    local unit caster
    local unit target
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "all", "pris", "", "", "" )
        call textst( udg_string[0] + GetObjectName('A11L'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
    endif
    
    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\Polymorph\\PolyMorphDoneGround.mdl", GetUnitX( caster ), GetUnitY( caster ) ) )
    //call ReplaceUnitBJ( caster, GetUnitTypeId(target), bj_UNIT_STATE_METHOD_RELATIVE )
    call ShowUnit( caster, false)
    set bj_lastCreatedUnit = CreateUnitCopy( target, GetUnitX( caster ), GetUnitY( caster ), GetUnitFacing(caster) )
    call UnitAddAbility( bj_lastCreatedUnit, 'A11L' )
    call UnitApplyTimedLife( bj_lastReplacedUnit, 'BTLF', 60)
    call KillUnit(caster)

    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_Poof takes nothing returns nothing
    set gg_trg_Poof = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Poof, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Poof, Condition( function Trig_Poof_Conditions ) )
    call TriggerAddAction( gg_trg_Poof, function Trig_Poof_Actions )
endfunction

