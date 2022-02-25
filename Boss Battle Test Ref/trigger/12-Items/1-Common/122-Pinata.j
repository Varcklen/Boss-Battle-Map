function Trig_Pinata_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0A3' and combat( GetSpellAbilityUnit(), true, GetSpellAbilityId() ) and not( udg_fightmod[3] )
endfunction

function Trig_Pinata_Actions takes nothing returns nothing
    local group g = CreateGroup()
    local unit u
    local integer cyclA = 1
    local integer cyclAEnd = eyest( GetSpellAbilityUnit() )
    local integer cyclB
    local real r
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
        call textst( udg_string[0] + GetObjectName('A0A3'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
        set x = GetLocationX( GetSpellTargetLoc() )
        set y = GetLocationY( GetSpellTargetLoc() )
    endif
    call stazisst( caster, GetItemOfTypeFromUnitBJ( caster, 'I05X') )

    set bj_lastCreatedUnit = CreateUnit( Player(PLAYER_NEUTRAL_AGGRESSIVE), 'h01Z', x, y,  0 )
    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageDeathCaster.mdl", GetUnitX( bj_lastCreatedUnit ), GetUnitY( bj_lastCreatedUnit ) ) )

    set caster = null
endfunction

//===========================================================================
function InitTrig_Pinata takes nothing returns nothing
    set gg_trg_Pinata = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Pinata, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Pinata, Condition( function Trig_Pinata_Conditions ) )
    call TriggerAddAction( gg_trg_Pinata, function Trig_Pinata_Actions )
endfunction

