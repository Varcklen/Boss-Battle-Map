function Trig_CircusPA_Conditions takes nothing returns boolean
    return GetUnitAbilityLevel(udg_DamageEventSource, 'A0S7') > 0 and luckylogic( udg_DamageEventSource, 10 + ( 5 * GetUnitAbilityLevel(udg_DamageEventSource, 'A0S7') ), 1, 100 ) and not( udg_IsDamageSpell )
endfunction

function Trig_CircusPA_Actions takes nothing returns nothing
    local unit u = randomtarget( udg_DamageEventSource, 900, "enemy", "", "", "", "" )
    
    if u != null then
        call DemomanCurse( udg_DamageEventSource, u )
    endif
    set u = null
endfunction

//===========================================================================
function InitTrig_CircusPA takes nothing returns nothing
    set gg_trg_CircusPA = CreateTrigger(  )
    call TriggerRegisterVariableEvent( gg_trg_CircusPA, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_CircusPA, Condition( function Trig_CircusPA_Conditions ) )
    call TriggerAddAction( gg_trg_CircusPA, function Trig_CircusPA_Actions )
endfunction

