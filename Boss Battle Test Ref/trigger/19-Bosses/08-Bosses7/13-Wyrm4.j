function Trig_Wyrm4_Conditions takes nothing returns boolean
    return GetUnitTypeId( udg_DamageEventTarget ) == 'o00M' and GetUnitLifePercent(udg_DamageEventTarget) <= 50
endfunction

function Trig_Wyrm4_Actions takes nothing returns nothing
    local integer i = 1

    call DisableTrigger( GetTriggeringTrigger() )
    loop
        exitwhen i > 4
        if GetUnitState(udg_hero[i], UNIT_STATE_LIFE) > 0.405 then
            call spectimeunit( udg_hero[i], "Abilities\\Spells\\Undead\\FrostNova\\FrostNovaTarget.mdl", "origin", 1 )
            call bufst( udg_DamageEventTarget, udg_hero[i], 'A0ZC', 'B099', "bswr4", 15 )
        endif
        set i = i + 1
    endloop
endfunction

//===========================================================================
function InitTrig_Wyrm4 takes nothing returns nothing
    set gg_trg_Wyrm4 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Wyrm4 )
    call TriggerRegisterVariableEvent( gg_trg_Wyrm4, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Wyrm4, Condition( function Trig_Wyrm4_Conditions ) )
    call TriggerAddAction( gg_trg_Wyrm4, function Trig_Wyrm4_Actions )
endfunction

