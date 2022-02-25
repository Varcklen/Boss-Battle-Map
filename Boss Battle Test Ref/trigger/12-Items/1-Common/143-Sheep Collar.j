function Trig_Sheep_Collar_Conditions takes nothing returns boolean
    return not( udg_IsDamageSpell ) and inv(udg_DamageEventTarget, 'I04Z') > 0 and IsUnitEnemy(udg_DamageEventSource, GetOwningPlayer(udg_DamageEventTarget)) and luckylogic( udg_DamageEventTarget, 33, 1, 100 )
endfunction

function Trig_Sheep_Collar_Actions takes nothing returns nothing
    set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( udg_DamageEventTarget ), ID_SHEEP, GetUnitX( udg_DamageEventTarget ) + GetRandomReal( -200, 200 ), GetUnitY( udg_DamageEventTarget ) + GetRandomReal( -200, 200 ),  GetRandomReal( 0, 360 ))
    call UnitApplyTimedLife( bj_lastCreatedUnit, 'BTLF', 60 )
    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Orc\\FeralSpirit\\feralspirittarget.mdl", GetUnitX( bj_lastCreatedUnit ), GetUnitY( bj_lastCreatedUnit ) ) )
endfunction

//===========================================================================
function InitTrig_Sheep_Collar takes nothing returns nothing
    set gg_trg_Sheep_Collar = CreateTrigger(  )
    call TriggerRegisterVariableEvent( gg_trg_Sheep_Collar, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Sheep_Collar, Condition( function Trig_Sheep_Collar_Conditions ) )
    call TriggerAddAction( gg_trg_Sheep_Collar, function Trig_Sheep_Collar_Actions )
endfunction

