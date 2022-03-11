function Trig_KingE_Conditions takes nothing returns boolean
    return GetSpellAbilityId( ) == 'A0Q2'
endfunction

function Trig_KingE_Actions takes nothing returns nothing
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
        call textst( udg_string[0] + GetObjectName('A0Q2'), caster, 64, 90, 10, 1.5 )
        set x = GetUnitX( caster ) + GetRandomReal( -650, 650 )
        set y = GetUnitY( caster ) + GetRandomReal( -650, 650 )
    else
        set caster = GetSpellAbilityUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
        set x = GetLocationX( GetSpellTargetLoc() )
        set y = GetLocationY( GetSpellTargetLoc() )
    endif
    
    set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( caster ), 'h01O', x, y, 270 )
    call SaveInteger( udg_hash, GetHandleId(bj_lastCreatedUnit), StringHash( "temple" ), lvl ) 
    call UnitApplyTimedLife( bj_lastCreatedUnit , 'BTLF', 61 )
    call DestroyEffect( AddSpecialEffectTarget( "Objects\\Spawnmodels\\Undead\\UCancelDeath\\UCancelDeath.mdl", bj_lastCreatedUnit, "origin" ) )
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_KingE takes nothing returns nothing
    set gg_trg_KingE = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_KingE, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_KingE, Condition( function Trig_KingE_Conditions ) )
    call TriggerAddAction( gg_trg_KingE, function Trig_KingE_Actions )
endfunction