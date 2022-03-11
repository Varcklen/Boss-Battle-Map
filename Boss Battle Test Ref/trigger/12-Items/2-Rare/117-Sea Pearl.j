function Trig_Sea_Pearl_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A02P'
endfunction

function Trig_Sea_Pearl_Actions takes nothing returns nothing
    local integer x
    local integer cyclA = 1
    local unit caster
    
    if CastLogic() then
        set caster = udg_Caster
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( udg_string[0] + GetObjectName('A02P'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
    endif
    
    set x = eyest( caster )
    loop
        exitwhen cyclA > 4
        if GetUnitState( udg_hero[cyclA], UNIT_STATE_LIFE) > 0.405 and unitst( udg_hero[cyclA], caster, "ally" ) then
            call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Items\\TomeOfRetraining\\TomeOfRetrainingCaster.mdl", GetUnitX( udg_hero[cyclA] ), GetUnitY( udg_hero[cyclA] ) ) )
            call UnitAddAbility( udg_hero[cyclA], 'A054' )
        endif
        set cyclA = cyclA + 1
    endloop
        
    set caster = null
endfunction

//===========================================================================
function InitTrig_Sea_Pearl takes nothing returns nothing
    set gg_trg_Sea_Pearl = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Sea_Pearl, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Sea_Pearl, Condition( function Trig_Sea_Pearl_Conditions ) )
    call TriggerAddAction( gg_trg_Sea_Pearl, function Trig_Sea_Pearl_Actions )
endfunction

