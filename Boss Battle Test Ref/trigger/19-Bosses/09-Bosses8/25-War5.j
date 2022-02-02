function Trig_War5_Conditions takes nothing returns boolean
    return GetUnitTypeId( udg_DamageEventTarget ) == 'o011' and GetUnitLifePercent(udg_DamageEventTarget) <= 30
endfunction

function Trig_War5_Actions takes nothing returns nothing
    local integer cyclA = 0
    local integer cyclB

    call DisableTrigger( GetTriggeringTrigger() )
    call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\NightElf\\BattleRoar\\RoarCaster.mdl", udg_DamageEventTarget, "origin" ) )
    loop
        exitwhen cyclA > 3
        set cyclB = 0
        loop
            exitwhen cyclB > 3
            if cyclA != cyclB then
                call SetPlayerAllianceStateBJ( Player(cyclA), Player(cyclB), bj_ALLIANCE_UNALLIED )
            endif
            set cyclB = cyclB + 1
        endloop
        if GetUnitState( udg_hero[cyclA+1], UNIT_STATE_LIFE) > 0.405 then
            call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\NightElf\\BattleRoar\\RoarCaster.mdl", udg_hero[cyclA+1], "origin" ) )
        endif
        set cyclA = cyclA + 1
    endloop
endfunction

//===========================================================================
function InitTrig_War5 takes nothing returns nothing
    set gg_trg_War5 = CreateTrigger(  )
    call DisableTrigger( gg_trg_War5 )
    call TriggerRegisterVariableEvent( gg_trg_War5, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_War5, Condition( function Trig_War5_Conditions ) )
    call TriggerAddAction( gg_trg_War5, function Trig_War5_Actions )
endfunction

