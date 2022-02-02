function Trig_Fedor3_Conditions takes nothing returns boolean
    return GetUnitTypeId( GetDyingUnit() ) == 'h00C' and udg_fightmod[0]
endfunction

function Trig_Fedor3_Actions takes nothing returns nothing
    local integer cyclA = 1
    local real x
    local real y
    
    call DisableTrigger( GetTriggeringTrigger() )
    loop
        exitwhen cyclA > 4
        set x = GetUnitX(GetDyingUnit()) + 1200 * Cos((45 + ( 90 * cyclA )) * bj_DEGTORAD)
        set y = GetUnitY(GetDyingUnit()) + 1200 * Sin((45 + ( 90 * cyclA )) * bj_DEGTORAD)
        set bj_lastCreatedUnit = CreateUnit(GetOwningPlayer( GetDyingUnit() ), 'o008', x, y, 45 + ( 90 * cyclA ) )
        call PingMinimapLocForForceEx( bj_FORCE_ALL_PLAYERS, GetUnitLoc( bj_lastCreatedUnit ), 5, bj_MINIMAPPINGSTYLE_ATTACK, 100, 50, 50 )
        set cyclA = cyclA + 1
    endloop
endfunction

//===========================================================================
function InitTrig_Fedor3 takes nothing returns nothing
    set gg_trg_Fedor3 = CreateTrigger()
    call DisableTrigger( gg_trg_Fedor3 )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Fedor3, EVENT_PLAYER_UNIT_DEATH )
    call TriggerAddCondition( gg_trg_Fedor3, Condition( function Trig_Fedor3_Conditions ) )
    call TriggerAddAction( gg_trg_Fedor3, function Trig_Fedor3_Actions )
endfunction

