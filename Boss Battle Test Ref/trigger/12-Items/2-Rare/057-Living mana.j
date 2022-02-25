function Trig_Living_mana_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0NX'
endfunction

function Trig_Living_mana_Actions takes nothing returns nothing
    local integer cyclA = 1
    local integer cyclAEnd
    local unit caster
    local real r
    
    if CastLogic() then
        set caster = udg_Caster
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( udg_string[0] + GetObjectName('A0NX'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
    endif

    set cyclAEnd = 3*eyest( caster )
    set r = GetUnitState(caster, UNIT_STATE_MANA)

    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Items\\TomeOfRetraining\\TomeOfRetrainingCaster.mdl",  caster, "origin" ) )
    call SetUnitState( caster, UNIT_STATE_MANA, RMaxBJ(0,GetUnitState( caster, UNIT_STATE_MANA) - r ) )

    loop
        exitwhen cyclA > cyclAEnd
        set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer(caster), 'h00I', GetUnitX( caster ) + GetRandomReal( -200, 200 ), GetUnitY( caster ) + GetRandomReal( -200, 200 ), GetRandomReal( 0, 360 ) )
        call UnitApplyTimedLife( bj_lastCreatedUnit, 'BTLF', 25)
        call BlzSetUnitMaxHP( bj_lastCreatedUnit, R2I(r) )
        if r > 10 then
            call BlzSetUnitBaseDamage( bj_lastCreatedUnit, R2I(r/10)-1, 0 )
        endif
        call SetUnitState( bj_lastCreatedUnit, UNIT_STATE_LIFE, GetUnitState( bj_lastCreatedUnit, UNIT_STATE_MAX_LIFE))
        call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Items\\TomeOfRetraining\\TomeOfRetrainingCaster.mdl", bj_lastCreatedUnit, "origin" ) )
	set cyclA = cyclA + 1
    endloop
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_Living_mana takes nothing returns nothing
    set gg_trg_Living_mana = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Living_mana, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Living_mana, Condition( function Trig_Living_mana_Conditions ) )
    call TriggerAddAction( gg_trg_Living_mana, function Trig_Living_mana_Actions )
endfunction

