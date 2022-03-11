function Trig_Totem_of_Energy_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A11X'
endfunction

function Trig_Totem_of_Energy_Actions takes nothing returns nothing
    local integer cyclA = 1
    local integer cyclAEnd
    local unit caster
    local real x
    local real y
    
    if CastLogic() then
        set caster = udg_Caster
        set x = GetLocationX( GetSpellTargetLoc() )
        set y = GetLocationY( GetSpellTargetLoc() )
    elseif RandomLogic() then
        set caster = udg_Caster
        set x = GetUnitX( caster ) + GetRandomReal( -650, 650 )
        set y = GetUnitY( caster ) + GetRandomReal( -650, 650 )
        call textst( udg_string[0] + GetObjectName('A11X'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
        set x = GetLocationX( GetSpellTargetLoc() )
        set y = GetLocationY( GetSpellTargetLoc() )
    endif
    
    set cyclAEnd = eyest( caster )
 
    loop
        exitwhen cyclA > cyclAEnd
        set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( caster ), 'o00Y', x, y, 270 )
        call UnitApplyTimedLife( bj_lastCreatedUnit, 'BTLF', 30 )
        set cyclA = cyclA + 1
    endloop
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_Totem_of_Energy takes nothing returns nothing
    set gg_trg_Totem_of_Energy = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Totem_of_Energy, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Totem_of_Energy, Condition( function Trig_Totem_of_Energy_Conditions ) )
    call TriggerAddAction( gg_trg_Totem_of_Energy, function Trig_Totem_of_Energy_Actions )
endfunction

