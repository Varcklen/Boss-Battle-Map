function Trig_Mehanic2_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'h010' and GetUnitLifePercent(udg_DamageEventTarget) <= 75
endfunction

function Trig_Mehanic2_Actions takes nothing returns nothing
    local integer cyclA = 1
    local real x
    local real y
    
    call DisableTrigger( GetTriggeringTrigger() )
    loop
        exitwhen cyclA > 4
        set x = GetUnitX(udg_DamageEventTarget) + 500 * Cos( ( 45 + ( 90 * cyclA ) ) * bj_DEGTORAD)
        set y = GetUnitY(udg_DamageEventTarget) + 500 * Sin( ( 45 + ( 90 * cyclA ) ) * bj_DEGTORAD)
        call CreateUnit( GetOwningPlayer( udg_DamageEventTarget ), 'n012', x, y, 45 + ( 90 * cyclA ))
        set cyclA = cyclA + 1
    endloop
endfunction

//===========================================================================
function InitTrig_Mehanic2 takes nothing returns nothing
    set gg_trg_Mehanic2 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Mehanic2 )
    call TriggerRegisterVariableEvent( gg_trg_Mehanic2, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Mehanic2, Condition( function Trig_Mehanic2_Conditions ) )
    call TriggerAddAction( gg_trg_Mehanic2, function Trig_Mehanic2_Actions )
endfunction

