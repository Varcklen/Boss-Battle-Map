function Trig_Gaze_Burning_Totem_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0SN'
endfunction

function Trig_Gaze_Burning_Totem_Actions takes nothing returns nothing
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
        call textst( udg_string[0] + GetObjectName('A0SN'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
        set x = GetLocationX( GetSpellTargetLoc() )
        set y = GetLocationY( GetSpellTargetLoc() )
    endif
    
    set cyclAEnd = eyest( caster )
    loop
        exitwhen cyclA > cyclAEnd
        set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer(caster), 'o01C', x, y, 270 )
        call UnitApplyTimedLife( bj_lastCreatedUnit, 'BTLF', 20.5 )
        set cyclA = cyclA + 1
    endloop
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_Gaze_Burning_Totem takes nothing returns nothing
    set gg_trg_Gaze_Burning_Totem = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Gaze_Burning_Totem, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Gaze_Burning_Totem, Condition( function Trig_Gaze_Burning_Totem_Conditions ) )
    call TriggerAddAction( gg_trg_Gaze_Burning_Totem, function Trig_Gaze_Burning_Totem_Actions )
endfunction

