function Trig_BoxDeath_Conditions takes nothing returns boolean
    return GetUnitTypeId(GetDyingUnit()) == 'h022'
endfunction

function Trig_BoxDeath_Actions takes nothing returns nothing
    local integer cyclA = 1
    
    loop
        exitwhen cyclA > 4
        if GetPlayerSlotState(Player(cyclA - 1)) == PLAYER_SLOT_STATE_PLAYING then
            call moneyst(udg_hero[cyclA], 75)
        endif
        set cyclA = cyclA + 1
    endloop
endfunction
    

//===========================================================================
function InitTrig_BoxDeath takes nothing returns nothing
    set gg_trg_BoxDeath = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_BoxDeath, EVENT_PLAYER_UNIT_DEATH )
    call TriggerAddCondition( gg_trg_BoxDeath, Condition( function Trig_BoxDeath_Conditions ) )
    call TriggerAddAction( gg_trg_BoxDeath, function Trig_BoxDeath_Actions )
endfunction

