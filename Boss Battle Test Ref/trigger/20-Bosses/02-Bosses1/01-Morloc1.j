function Trig_Morloc1_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'n005' and GetUnitLifePercent(udg_DamageEventTarget) <= 75.
endfunction

function Trig_Morloc1_Actions takes nothing returns nothing
    local integer cyclA = 1
    
    call DisableTrigger( GetTriggeringTrigger() )
    call SetUnitAnimation( udg_DamageEventTarget, "spell" )
    loop
        exitwhen cyclA > 4
        call CreateUnit( GetOwningPlayer( udg_DamageEventTarget ), 'n006', GetUnitX( udg_DamageEventTarget ) + GetRandomReal( -200, 200 ), GetUnitY( udg_DamageEventTarget ) + GetRandomReal( -200, 200 ), GetRandomReal( 0, 360 ) )
        set cyclA = cyclA + 1
    endloop
endfunction

//===========================================================================
function InitTrig_Morloc1 takes nothing returns nothing
    set gg_trg_Morloc1 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Morloc1 )
    call TriggerRegisterVariableEvent( gg_trg_Morloc1, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Morloc1, Condition( function Trig_Morloc1_Conditions ) )
    call TriggerAddAction( gg_trg_Morloc1, function Trig_Morloc1_Actions )
endfunction

