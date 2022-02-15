function Trig_OrbVolcano_Conditions takes nothing returns boolean
    return not( udg_IsDamageSpell ) and luckylogic( udg_DamageEventSource, 10, 1, 100 ) and inv( udg_DamageEventSource, 'I0ER') > 0
endfunction

function Trig_OrbVolcano_Actions takes nothing returns nothing
    set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( udg_DamageEventSource ), 'u000', GetUnitX( udg_DamageEventSource )+GetRandomReal(-500, 500), GetUnitY( udg_DamageEventSource )+GetRandomReal(-500, 500), 270 )
    call UnitAddAbility( bj_lastCreatedUnit, 'A0WB' )
    call UnitApplyTimedLife(bj_lastCreatedUnit, 'BTLF', 21 )
    call IssuePointOrder( bj_lastCreatedUnit, "volcano", GetUnitX( bj_lastCreatedUnit ), GetUnitY( bj_lastCreatedUnit  ) )
endfunction

//===========================================================================
function InitTrig_OrbVolcano takes nothing returns nothing
    set gg_trg_OrbVolcano = CreateTrigger(  )
    call TriggerRegisterVariableEvent( gg_trg_OrbVolcano, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_OrbVolcano, Condition( function Trig_OrbVolcano_Conditions ) )
    call TriggerAddAction( gg_trg_OrbVolcano, function Trig_OrbVolcano_Actions )
endfunction

