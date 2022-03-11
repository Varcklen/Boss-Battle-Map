function Trig_Superbots_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0RF'
endfunction

function Trig_Superbots_Actions takes nothing returns nothing
    local unit caster
    local integer cyclA = 1
    
    if CastLogic() then
        set caster = udg_Caster
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( udg_string[0] + GetObjectName('A0RF'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
    endif

    loop
        exitwhen cyclA > 3
        set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( caster ), 'n00U', GetUnitX( caster ) + GetRandomReal( -200, 200 ), GetUnitY( caster ) + GetRandomReal( -200, 200 ), GetRandomReal( 0, 360 ) )
        call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Human\\FlakCannons\\FlakTarget.mdl", bj_lastCreatedUnit, "origin") )
        set cyclA = cyclA + 1
    endloop
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_Superbots takes nothing returns nothing
    set gg_trg_Superbots = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Superbots, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Superbots, Condition( function Trig_Superbots_Conditions ) )
    call TriggerAddAction( gg_trg_Superbots, function Trig_Superbots_Actions )
endfunction

