function Trig_Exile_skull_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A15L'
endfunction

function Trig_Exile_skull_Actions takes nothing returns nothing
    local integer cyclA = 1
    local integer cyclAEnd
    local unit caster
    
    if CastLogic() then
        set caster = udg_Caster
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( udg_string[0] + GetObjectName('A15L'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
    endif
    
    set cyclAEnd = eyest( caster ) * 5

    loop
        exitwhen cyclA > cyclAEnd
        set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer(caster), 'u01I', GetUnitX( caster ) + GetRandomReal( -200, 200 ), GetUnitY( caster ) + GetRandomReal( -200, 200 ), GetRandomReal( 0, 360 ) )
        call UnitApplyTimedLife( bj_lastCreatedUnit, 'BTLF', 40)
        call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Orc\\FeralSpirit\\feralspirittarget.mdl", GetUnitX( bj_lastCreatedUnit ), GetUnitY( bj_lastCreatedUnit ) ) )
        set cyclA = cyclA + 1
    endloop
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_Exile_skull takes nothing returns nothing
    set gg_trg_Exile_skull = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Exile_skull, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Exile_skull, Condition( function Trig_Exile_skull_Conditions ) )
    call TriggerAddAction( gg_trg_Exile_skull, function Trig_Exile_skull_Actions )
endfunction

