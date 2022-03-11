function Trig_GrayGuard_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A08N' and combat( GetSpellAbilityUnit(), true, GetSpellAbilityId() ) and not( udg_fightmod[3] )
endfunction

function Trig_GrayGuard_Actions takes nothing returns nothing
    local integer cyclA = 1
    local integer cyclAEnd
    local unit caster
    
    if CastLogic() then
        set caster = udg_Caster
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( udg_string[0] + GetObjectName('A08N'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
    endif

    set bj_lastCreatedUnit = CreateUnit( Player( PLAYER_NEUTRAL_PASSIVE ), 'u000', GetUnitX( caster ), GetUnitY( caster ), 270 )
    call UnitApplyTimedLife( bj_lastCreatedUnit, 'BTLF', 3 )
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Human\\Resurrect\\ResurrectCaster.mdl",  bj_lastCreatedUnit, "origin" ) )
    
    set cyclAEnd = eyest( caster )
    loop
        exitwhen cyclA > cyclAEnd
        call SetHeroLevel( caster, GetHeroLevel(caster) + 1, false )
        set cyclA = cyclA + 1
    endloop
      
    set caster = null
endfunction

//===========================================================================
function InitTrig_GrayGuard takes nothing returns nothing
    set gg_trg_GrayGuard = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_GrayGuard, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_GrayGuard, Condition( function Trig_GrayGuard_Conditions ) )
    call TriggerAddAction( gg_trg_GrayGuard, function Trig_GrayGuard_Actions )
endfunction

