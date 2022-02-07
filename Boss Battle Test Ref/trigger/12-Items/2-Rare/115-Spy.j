function Trig_Spy_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0W6'
endfunction

function Trig_Spy_Actions takes nothing returns nothing
    local integer cyclA = 1
    local integer cyclAEnd 
    local unit caster
    
    if CastLogic() then
        set caster = udg_Caster
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( udg_string[0] + GetObjectName('A0W6'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
    endif
    
    set cyclAEnd  = eyest( caster )
    loop
        exitwhen cyclA > cyclAEnd
        set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( caster ), 'n03Q', GetUnitX( caster ) + GetRandomReal( -200, 200 ), GetUnitY( caster ) + GetRandomReal( -200, 200 ),  GetRandomReal( 0, 360 ))
        call UnitApplyTimedLife(bj_lastCreatedUnit, 'BTLF', 60)
        call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\FlakCannons\\FlakTarget.mdl", GetUnitX( bj_lastCreatedUnit ), GetUnitY( bj_lastCreatedUnit ) ) )
        set cyclA = cyclA + 1
    endloop
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_Spy takes nothing returns nothing
    set gg_trg_Spy = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Spy, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Spy, Condition( function Trig_Spy_Conditions ) )
    call TriggerAddAction( gg_trg_Spy, function Trig_Spy_Actions )
endfunction

