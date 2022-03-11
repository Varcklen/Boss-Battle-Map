function Trig_Kodo1_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventSource) == 'h01K' and not( IsUnitType( udg_DamageEventTarget, UNIT_TYPE_HERO) ) and not( IsUnitType( udg_DamageEventTarget, UNIT_TYPE_ANCIENT) )
endfunction

function Trig_Kodo1_Actions takes nothing returns nothing
    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", GetUnitX( udg_DamageEventTarget ), GetUnitY( udg_DamageEventTarget ) ) )
    call SetUnitState( udg_DamageEventSource, UNIT_STATE_LIFE, GetUnitState( udg_DamageEventSource, UNIT_STATE_LIFE) + GetUnitState( udg_DamageEventTarget, UNIT_STATE_MAX_LIFE) )
    call KillUnit( udg_DamageEventTarget )
endfunction

//===========================================================================
function InitTrig_Kodo1 takes nothing returns nothing
    set gg_trg_Kodo1 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Kodo1 )
    call TriggerRegisterVariableEvent( gg_trg_Kodo1, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Kodo1, Condition( function Trig_Kodo1_Conditions ) )
    call TriggerAddAction( gg_trg_Kodo1, function Trig_Kodo1_Actions )
endfunction

