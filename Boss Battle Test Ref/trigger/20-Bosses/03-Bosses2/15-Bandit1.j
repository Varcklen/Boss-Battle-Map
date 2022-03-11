function Trig_Bandit1_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'h014'
endfunction

function Trig_Bandit1_Actions takes nothing returns nothing
    call DisableTrigger( GetTriggeringTrigger() )
    call SaveInteger( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bsrg" ), 1 )
endfunction

//===========================================================================
function InitTrig_Bandit1 takes nothing returns nothing
    set gg_trg_Bandit1 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Bandit1 )
    call TriggerRegisterVariableEvent( gg_trg_Bandit1, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Bandit1, Condition( function Trig_Bandit1_Conditions ) )
    call TriggerAddAction( gg_trg_Bandit1, function Trig_Bandit1_Actions )
endfunction

