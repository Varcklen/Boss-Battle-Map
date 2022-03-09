function Trig_PriestessR_Conditions takes nothing returns boolean
    return GetSpellAbilityId( ) == 'A056'
endfunction

function Trig_PriestessR_Actions takes nothing returns nothing
    local integer id 
    local unit caster
    local integer lvl
    local real x
    local real y

    if CastLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        set x = GetLocationX( GetSpellTargetLoc() )
        set y = GetLocationY( GetSpellTargetLoc() )
    elseif RandomLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A056'), caster, 64, 90, 10, 1.5 )
        set x = GetUnitX( caster ) + GetRandomReal( -650, 650 )
        set y = GetUnitY( caster ) + GetRandomReal( -650, 650 )
    else
        set caster = GetSpellAbilityUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
        set x = GetLocationX( GetSpellTargetLoc() )
        set y = GetLocationY( GetSpellTargetLoc() )
    endif
    
    set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( caster ), 'h018', x, y, 270 )
    call UnitApplyTimedLife( bj_lastCreatedUnit, 'BTLF', 40 )
    call DestroyEffect( AddSpecialEffectTarget( "Objects\\Spawnmodels\\Undead\\UCancelDeath\\UCancelDeath.mdl", bj_lastCreatedUnit, "origin" ) )
    //call UnitAddAbility( bj_lastCreatedUnit, 'A055' )
    call SetUnitAbilityLevel( bj_lastCreatedUnit, 'A055', lvl )
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_PriestessR takes nothing returns nothing
    set gg_trg_PriestessR = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_PriestessR, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_PriestessR, Condition( function Trig_PriestessR_Conditions ) )
    call TriggerAddAction( gg_trg_PriestessR, function Trig_PriestessR_Actions )
endfunction