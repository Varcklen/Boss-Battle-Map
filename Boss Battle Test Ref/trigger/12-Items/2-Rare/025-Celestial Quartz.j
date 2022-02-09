function Trig_Celestial_Quartz_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0XN' and not( udg_fightmod[3] ) and combat( GetSpellAbilityUnit(), true, GetSpellAbilityId() )
endfunction

function Trig_Celestial_Quartz_Actions takes nothing returns nothing
    local integer cyclA = 1
    local integer cyclAEnd
    local unit caster
    
    if CastLogic() then
        set caster = udg_Caster
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( udg_string[0] + GetObjectName('A0XN'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
    endif
    
    set cyclAEnd = eyest( caster )

    loop
        exitwhen cyclA > cyclAEnd
        call BlzSetUnitMaxMana( caster, BlzGetUnitMaxMana(caster) + 20 )
        call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Items\\AIma\\AImaTarget.mdl", GetUnitX( caster ), GetUnitY( caster ) ) )
        set cyclA = cyclA + 1
    endloop
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_Celestial_Quartz takes nothing returns nothing
    set gg_trg_Celestial_Quartz = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Celestial_Quartz, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Celestial_Quartz, Condition( function Trig_Celestial_Quartz_Conditions ) )
    call TriggerAddAction( gg_trg_Celestial_Quartz, function Trig_Celestial_Quartz_Actions )
endfunction

