function Trig_Sheep_Staff_Conditions takes nothing returns boolean
    return inv(GetSpellAbilityUnit(), 'I064') > 0 
endfunction

function Trig_Sheep_Staff_Actions takes nothing returns nothing
    set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( GetSpellAbilityUnit() ), ID_SHEEP, GetUnitX( GetSpellAbilityUnit() ), GetUnitY( GetSpellAbilityUnit() ), GetUnitFacing( GetSpellAbilityUnit() ) )
    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Orc\\FeralSpirit\\feralspirittarget.mdl", GetUnitX( bj_lastCreatedUnit ), GetUnitY( bj_lastCreatedUnit ) ) )
    call UnitApplyTimedLife( bj_lastCreatedUnit, 'BTLF', 60 )
endfunction

//===========================================================================
function InitTrig_Sheep_Staff takes nothing returns nothing
    set gg_trg_Sheep_Staff = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Sheep_Staff, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Sheep_Staff, Condition( function Trig_Sheep_Staff_Conditions ) )
    call TriggerAddAction( gg_trg_Sheep_Staff, function Trig_Sheep_Staff_Actions )
endfunction