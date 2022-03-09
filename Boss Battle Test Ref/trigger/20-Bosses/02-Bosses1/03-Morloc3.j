function Trig_Morloc3_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'n005' and GetUnitLifePercent(udg_DamageEventTarget) <= 25.
endfunction

function Trig_Morloc3_Actions takes nothing returns nothing
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
function InitTrig_Morloc3 takes nothing returns nothing
    set gg_trg_Morloc3 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Morloc3 )
    call TriggerRegisterVariableEvent( gg_trg_Morloc3, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Morloc3, Condition( function Trig_Morloc3_Conditions ) )
    call TriggerAddAction( gg_trg_Morloc3, function Trig_Morloc3_Actions )
endfunction

