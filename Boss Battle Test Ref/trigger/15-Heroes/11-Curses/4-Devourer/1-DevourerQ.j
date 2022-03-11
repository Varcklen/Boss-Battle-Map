function Trig_DevourerQ_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A10E'
endfunction

function Trig_DevourerQ_Actions takes nothing returns nothing
    local unit caster
    local integer lvl
    
    if CastLogic() then
        set caster = udg_Target
        set lvl = udg_Level
    elseif RandomLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A10E'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
    endif
    
    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Other\\HowlOfTerror\\HowlCaster.mdl", GetUnitX( caster ), GetUnitY( caster ) ) )
    call dummyspawn( caster, 1,'A1AJ', 0, 0 )
    call SetUnitAbilityLevel( bj_lastCreatedUnit, 'A1AJ', lvl )
    call IssueTargetOrder( bj_lastCreatedUnit, "invisibility", caster )
    call shadowst( caster )
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_DevourerQ takes nothing returns nothing
    set gg_trg_DevourerQ = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_DevourerQ, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_DevourerQ, Condition( function Trig_DevourerQ_Conditions ) )
    call TriggerAddAction( gg_trg_DevourerQ, function Trig_DevourerQ_Actions )
endfunction

