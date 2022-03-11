function Trig_MiracleBrewR_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0RT'
endfunction

function Trig_MiracleBrewR_Actions takes nothing returns nothing
    local unit caster
    local integer lvl
    local integer cyclA
    local real dmg
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
        set x = GetUnitX( caster ) + GetRandomReal( -650, 650 )
        set y = GetUnitY( caster ) + GetRandomReal( -650, 650 )
        call textst( udg_string[0] + GetObjectName('A0RT'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
        set x = GetLocationX( GetSpellTargetLoc() )
        set y = GetLocationY( GetSpellTargetLoc() )
    endif
    
    set dmg = 75 + ( 50 * lvl )
    
    set cyclA = 1
    loop
        exitwhen cyclA > 3
        call dummyspawn( caster, 3, 'A087', 0, 0 )
        if cyclA > 1 then
            set x = GetUnitX( caster ) + GetRandomReal( -650, 650 )
            set y = GetUnitY( caster ) + GetRandomReal( -650, 650 )
        endif
        call IssuePointOrder( bj_lastCreatedUnit, "move", x, y )
        call SetUnitMoveSpeed( bj_lastCreatedUnit, 400. )
        call SaveUnitHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "mrbr" ), caster )
        call SaveReal( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "mrbr" ), dmg )
        set cyclA = cyclA + 1
    endloop
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_MiracleBrewR takes nothing returns nothing
    set gg_trg_MiracleBrewR = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_MiracleBrewR, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_MiracleBrewR, Condition( function Trig_MiracleBrewR_Conditions ) )
    call TriggerAddAction( gg_trg_MiracleBrewR, function Trig_MiracleBrewR_Actions )
endfunction

