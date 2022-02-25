function Trig_Sundial_Conditions takes nothing returns boolean
    return not( udg_IsDamageSpell ) and LuckChance( udg_DamageEventSource, 8 ) and inv( udg_DamageEventSource, 'I017') > 0
endfunction

function Trig_Sundial_Actions takes nothing returns nothing
    set bj_lastCreatedUnit = CreateUnit( Player(4), udg_Database_RandomUnit[GetRandomInt(1, udg_Database_NumberItems[5])], GetUnitX( udg_DamageEventSource ) + GetRandomReal( -200, 200 ), GetUnitY( udg_DamageEventSource ) + GetRandomReal( -200, 200 ), GetRandomReal( 0, 360 ) )
    call UnitApplyTimedLife( bj_lastCreatedUnit, 'BTLF', 15.)
    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Orc\\FeralSpirit\\feralspirittarget.mdl", GetUnitX( bj_lastCreatedUnit ), GetUnitY( bj_lastCreatedUnit ) ) )
endfunction

//===========================================================================
function InitTrig_Sundial takes nothing returns nothing
    set gg_trg_Sundial = CreateTrigger(  )
    call TriggerRegisterVariableEvent( gg_trg_Sundial, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Sundial, Condition( function Trig_Sundial_Conditions ) )
    call TriggerAddAction( gg_trg_Sundial, function Trig_Sundial_Actions )
endfunction

