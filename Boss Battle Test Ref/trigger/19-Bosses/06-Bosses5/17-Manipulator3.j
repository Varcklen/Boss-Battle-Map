function Trig_Manipulator3_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'n02W' and GetUnitLifePercent(udg_DamageEventTarget) <= 40.
endfunction

function Trig_Manipulator3_Actions takes nothing returns nothing
    local integer cyclA = 1
    
    call DisableTrigger( GetTriggeringTrigger() )
    loop
        exitwhen cyclA > 2
        set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer(udg_DamageEventTarget), 'n02X', GetUnitX(udg_DamageEventTarget) + GetRandomReal( -200, 200 ), GetUnitY(udg_DamageEventTarget) + GetRandomReal( -200, 200 ), GetRandomReal( 0, 360 ) )
        call DestroyEffect(AddSpecialEffectTarget( "Abilities\\Spells\\Undead\\DarkRitual\\DarkRitualTarget.mdll", bj_lastCreatedUnit, "origin") )
        set cyclA = cyclA + 1
    endloop
endfunction

//===========================================================================
function InitTrig_Manipulator3 takes nothing returns nothing
    set gg_trg_Manipulator3 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Manipulator3 )
    call TriggerRegisterVariableEvent( gg_trg_Manipulator3, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Manipulator3, Condition( function Trig_Manipulator3_Conditions ) )
    call TriggerAddAction( gg_trg_Manipulator3, function Trig_Manipulator3_Actions )
endfunction

