function Trig_Superbot_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A08D'
endfunction

function Trig_Superbot_Actions takes nothing returns nothing
    local integer cyclA = 1
    local integer cyclAEnd 
    local integer cyclB
    local unit caster
    local integer i
    
    if CastLogic() then
        set caster = udg_Caster
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( udg_string[0] + GetObjectName('A08D'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
    endif
    
    set cyclAEnd = eyest( caster )
    set i = GetPlayerId(GetOwningPlayer(caster)) + 1
    loop
        exitwhen cyclA > cyclAEnd
        set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( caster ), 'n00U', GetUnitX( caster ) + GetRandomReal( -200, 200 ), GetUnitY( caster ) + GetRandomReal( -200, 200 ),  GetRandomReal( 0, 360 ))
        call UnitApplyTimedLife(bj_lastCreatedUnit, 'BTLF', 90)
        call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\FlakCannons\\FlakTarget.mdl", GetUnitX( bj_lastCreatedUnit ), GetUnitY( bj_lastCreatedUnit ) ) )
        if combat( GetManipulatingUnit(), false, 0 ) and not( udg_fightmod[3] ) then
            call SetPlayerTechResearched( GetOwningPlayer(caster), 'R000', GetHeroLevel(caster)*SetCount_GetPieces(caster, SET_MECH))
            call SetPlayerTechResearched( GetOwningPlayer(caster), 'R001', GetHeroLevel(caster)*SetCount_GetPieces(caster, SET_MECH))
        endif
        set cyclA = cyclA + 1
    endloop
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_Superbot takes nothing returns nothing
    set gg_trg_Superbot = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Superbot, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Superbot, Condition( function Trig_Superbot_Conditions ) )
    call TriggerAddAction( gg_trg_Superbot, function Trig_Superbot_Actions )
endfunction

