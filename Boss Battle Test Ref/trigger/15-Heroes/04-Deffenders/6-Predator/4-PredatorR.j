function Trig_PredatorR_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A15T'
endfunction

function Trig_PredatorR_Actions takes nothing returns nothing
    local unit caster
    local integer lvl
    local real x
    local real y
    local integer id
    
    if CastLogic() then
        set caster = udg_Target
        set lvl = udg_Level
        set x = GetLocationX( GetSpellTargetLoc() )
        set y = GetLocationY( GetSpellTargetLoc() )
    elseif RandomLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        set x = GetUnitX( caster ) + GetRandomReal( -650, 650 )
        set y = GetUnitY( caster ) + GetRandomReal( -650, 650 )
        call textst( udg_string[0] + GetObjectName('A15T'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
        set x = GetLocationX( GetSpellTargetLoc() )
        set y = GetLocationY( GetSpellTargetLoc() )
    endif
    
        set bj_lastCreatedUnit = CreateUnit(GetOwningPlayer(caster), 'u000', x, y, 270 )
	call UnitAddAbility( bj_lastCreatedUnit, 'A15U' ) 
    	call SetUnitAbilityLevel( bj_lastCreatedUnit, 'A15U', lvl )
	call UnitApplyTimedLife( bj_lastCreatedUnit, 'BTLF', 20 )

    set caster = null
endfunction

//===========================================================================
function InitTrig_PredatorR takes nothing returns nothing
    set gg_trg_PredatorR = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_PredatorR, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_PredatorR, Condition( function Trig_PredatorR_Conditions ) )
    call TriggerAddAction( gg_trg_PredatorR, function Trig_PredatorR_Actions )
endfunction

