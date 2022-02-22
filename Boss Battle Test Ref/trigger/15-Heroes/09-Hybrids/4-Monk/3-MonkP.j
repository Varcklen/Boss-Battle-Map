function Trig_MonkP_Conditions takes nothing returns boolean
    return GetUnitAbilityLevel( udg_DamageEventSource, 'A08W') > 0 and not( udg_IsDamageSpell )
endfunction

function Trig_MonkP_Actions takes nothing returns nothing
    local unit target = null
    local integer lvl = GetUnitAbilityLevel(udg_DamageEventSource, 'A08W')
    local real heal = 5. + I2R( ( lvl + 6 ) * lvl )

    set target = HeroLessHP(udg_DamageEventSource)
    if target != null then
        call healst( udg_DamageEventSource, target, heal )
        set target = null
    endif
endfunction

//===========================================================================
function InitTrig_MonkP takes nothing returns nothing
    set gg_trg_MonkP = CreateTrigger(  )
    call TriggerRegisterVariableEvent( gg_trg_MonkP, "udg_DamageModifierEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_MonkP, Condition( function Trig_MonkP_Conditions ) )
    call TriggerAddAction( gg_trg_MonkP, function Trig_MonkP_Actions )
endfunction

