function Trig_Fedor1_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'h00B' and GetUnitLifePercent(udg_DamageEventTarget) <= 66
endfunction

function Trig_Fedor1_Actions takes nothing returns nothing
    local integer cyclA = 1
    local real x
    local real y
    
    call DisableTrigger( GetTriggeringTrigger() )
    loop
        exitwhen cyclA > 4
        set x = GetUnitX(udg_DamageEventTarget) + 1200 * Cos((45 + ( 90 * cyclA )) * bj_DEGTORAD)
        set y = GetUnitY(udg_DamageEventTarget) + 1200 * Sin((45 + ( 90 * cyclA )) * bj_DEGTORAD)
        set bj_lastCreatedUnit = CreateUnit(GetOwningPlayer( udg_DamageEventTarget ), 'o008', x, y, 45 + ( 90 * cyclA ) )
        call PingMinimapLocForForceEx( bj_FORCE_ALL_PLAYERS, GetUnitLoc( bj_lastCreatedUnit ), 5, bj_MINIMAPPINGSTYLE_ATTACK, 100, 50, 50 )
        set cyclA = cyclA + 1
    endloop
endfunction

//===========================================================================
function InitTrig_Fedor1 takes nothing returns nothing
    set gg_trg_Fedor1 = CreateTrigger()
    call DisableTrigger( gg_trg_Fedor1 )
    call TriggerRegisterVariableEvent( gg_trg_Fedor1, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Fedor1, Condition( function Trig_Fedor1_Conditions ) )
    call TriggerAddAction( gg_trg_Fedor1, function Trig_Fedor1_Actions )
endfunction

