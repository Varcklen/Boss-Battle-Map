function Trig_NinjaR_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0MB'
endfunction

function Trig_NinjaR_Actions takes nothing returns nothing
    local unit caster
    local integer lvl
    local real x
    local real y
    
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
        call textst( udg_string[0] + GetObjectName('A0MB'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
        set x = GetLocationX( GetSpellTargetLoc() )
        set y = GetLocationY( GetSpellTargetLoc() )
    endif

        set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( caster ), 'u000', x, y, 270 ) 
        call UnitAddAbility( bj_lastCreatedUnit, 'A0ME')
        call UnitApplyTimedLife( bj_lastCreatedUnit, 'BTLF', 8+(2*lvl))
    	call DestroyEffect( AddSpecialEffect("Abilities\\Spells\\Human\\FlakCannons\\FlakTarget.mdl", x, y ) )

    set caster = null
endfunction

//===========================================================================
function InitTrig_NinjaR takes nothing returns nothing
    set gg_trg_NinjaR = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_NinjaR, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_NinjaR, Condition( function Trig_NinjaR_Conditions ) )
    call TriggerAddAction( gg_trg_NinjaR, function Trig_NinjaR_Actions )
endfunction

