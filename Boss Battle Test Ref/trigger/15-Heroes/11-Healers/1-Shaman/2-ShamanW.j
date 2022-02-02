function Trig_ShamanW_Conditions takes nothing returns boolean
    return GetSpellAbilityId( ) == 'A0W5'
endfunction

function Trig_ShamanW_Actions takes nothing returns nothing
    local integer id 
    local unit caster
    local integer lvl
    local real x
    local real y
    local integer hp
    local integer dmg

    if CastLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        set x = GetLocationX( GetSpellTargetLoc() )
        set y = GetLocationY( GetSpellTargetLoc() )
    elseif RandomLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A0W5'), caster, 64, 90, 10, 1.5 )
        set x = GetUnitX( caster ) + GetRandomReal( -650, 650 )
        set y = GetUnitY( caster ) + GetRandomReal( -650, 650 )
    else
        set caster = GetSpellAbilityUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
        set x = GetLocationX( GetSpellTargetLoc() )
        set y = GetLocationY( GetSpellTargetLoc() )
    endif
    set hp = 500+(500*lvl)
    set dmg = 1 + ( 2 * lvl )
    
    set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer(caster), 'h01V', x, y, 270 )//Player( 10 )
    call BlzSetUnitMaxHP( bj_lastCreatedUnit, hp )
    call SetUnitState( bj_lastCreatedUnit, UNIT_STATE_LIFE, GetUnitState( bj_lastCreatedUnit, UNIT_STATE_LIFE) + hp )
    call UnitApplyTimedLife( bj_lastCreatedUnit , 'BTLF', 30 )
    call SaveInteger( udg_hash, GetHandleId(bj_lastCreatedUnit), StringHash( "ches" ), dmg )
    call SaveUnitHandle( udg_hash, GetHandleId(bj_lastCreatedUnit), StringHash( "ches" ), caster )
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_ShamanW takes nothing returns nothing
    set gg_trg_ShamanW = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_ShamanW, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_ShamanW, Condition( function Trig_ShamanW_Conditions ) )
    call TriggerAddAction( gg_trg_ShamanW, function Trig_ShamanW_Actions )
endfunction