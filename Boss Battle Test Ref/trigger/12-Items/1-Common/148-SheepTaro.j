function Trig_SheepTaro_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A13O' and not( udg_fightmod[3] ) and combat( GetSpellAbilityUnit(), true, GetSpellAbilityId() )
endfunction

function Trig_SheepTaro_Actions takes nothing returns nothing
    local integer cyclA = 1
    
    loop
        exitwhen cyclA > 40
        set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( GetSpellAbilityUnit() ), ID_SHEEP, GetUnitX( GetSpellAbilityUnit() ), GetUnitY( GetSpellAbilityUnit() ), GetUnitFacing( GetSpellAbilityUnit() ) )
        call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Orc\\FeralSpirit\\feralspirittarget.mdl", GetUnitX( bj_lastCreatedUnit ), GetUnitY( bj_lastCreatedUnit ) ) )
        call UnitApplyTimedLife( bj_lastCreatedUnit, 'BTLF', 60 )
        set cyclA = cyclA + 1
    endloop
    
    call stazisst( GetSpellAbilityUnit(), GetItemOfTypeFromUnitBJ( GetSpellAbilityUnit(), 'I0BE') )
endfunction

//===========================================================================
function InitTrig_SheepTaro takes nothing returns nothing
    set gg_trg_SheepTaro = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_SheepTaro, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_SheepTaro, Condition( function Trig_SheepTaro_Conditions ) )
    call TriggerAddAction( gg_trg_SheepTaro, function Trig_SheepTaro_Actions )
endfunction

