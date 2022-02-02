function Trig_DragonPA_Conditions takes nothing returns boolean
    return GetUnitAbilityLevel( udg_DamageEventSource, 'A08E' ) > 0 and combat( udg_DamageEventSource, false, 0 ) and not( udg_IsDamageSpell ) and luckylogic( udg_DamageEventSource, 2 * GetUnitAbilityLevel( udg_DamageEventSource, 'A08E'), 1, 100 ) and IsUnitEnemy(udg_DamageEventSource, GetOwningPlayer(udg_DamageEventTarget)) and not(udg_fightmod[3])
endfunction

function Trig_DragonPA_Actions takes nothing returns nothing
    call crist( udg_DamageEventSource, 1 )
    call healst( udg_DamageEventSource, null, GetUnitState( udg_DamageEventSource, UNIT_STATE_MAX_LIFE) * 0.02 )
    call manast( udg_DamageEventSource, null, GetUnitState( udg_DamageEventSource, UNIT_STATE_MAX_MANA) * 0.02 )
endfunction

//===========================================================================
function InitTrig_DragonPA takes nothing returns nothing
    set gg_trg_DragonPA = CreateTrigger(  )
    call TriggerRegisterVariableEvent( gg_trg_DragonPA, "udg_DamageModifierEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_DragonPA, Condition( function Trig_DragonPA_Conditions ) )
    call TriggerAddAction( gg_trg_DragonPA, function Trig_DragonPA_Actions )
endfunction

