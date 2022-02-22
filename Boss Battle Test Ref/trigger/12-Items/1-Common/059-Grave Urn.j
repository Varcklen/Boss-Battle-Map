function Trig_Grave_Urn_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0WI'
endfunction

function Trig_Grave_Urn_Actions takes nothing returns nothing
    local integer cyclA = 1
    local integer cyclAEnd
    local unit caster
    
    if CastLogic() then
        set caster = udg_Caster
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( udg_string[0] + GetObjectName('A0WI'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
    endif
    
    set cyclAEnd = eyest( caster ) * 5

    loop
        exitwhen cyclA > cyclAEnd
        set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer(caster), udg_Database_RandomUnit[GetRandomInt(1, udg_Database_NumberItems[5])], GetUnitX( caster ) + GetRandomReal( -200, 200 ), GetUnitY( caster ) + GetRandomReal( -200, 200 ), GetRandomReal( 0, 360 ) )
        call SetUnitState( bj_lastCreatedUnit, UNIT_STATE_LIFE, 1. )
        call UnitApplyTimedLife( bj_lastCreatedUnit, 'BTLF', 20.)
        call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Orc\\FeralSpirit\\feralspirittarget.mdl", GetUnitX( bj_lastCreatedUnit ), GetUnitY( bj_lastCreatedUnit ) ) )
        set cyclA = cyclA + 1
    endloop
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_Grave_Urn takes nothing returns nothing
    set gg_trg_Grave_Urn = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Grave_Urn, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Grave_Urn, Condition( function Trig_Grave_Urn_Conditions ) )
    call TriggerAddAction( gg_trg_Grave_Urn, function Trig_Grave_Urn_Actions )
endfunction

