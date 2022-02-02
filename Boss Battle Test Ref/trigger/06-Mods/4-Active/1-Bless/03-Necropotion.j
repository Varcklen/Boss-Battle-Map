function Trig_Necropotion_Conditions takes nothing returns boolean
    return IsUnitInGroup(GetDyingUnit(), udg_heroinfo) and not( udg_fightmod[3] ) and combat( GetDyingUnit(), false, 0 )
endfunction

function Trig_Necropotion_Actions takes nothing returns nothing
    local integer cyclA = 1
    
    loop
        exitwhen cyclA > 4
        if GetUnitState( udg_hero[cyclA], UNIT_STATE_LIFE) > 0.405 and udg_combatlogic[GetPlayerId( GetOwningPlayer( udg_hero[cyclA] ) ) + 1] and UnitInventoryCount(udg_hero[cyclA]) < 6 and GetDyingUnit() != udg_hero[cyclA] then
            set bj_lastCreatedItem = CreateItem( udg_Database_Item_Potion[GetRandomInt(1, udg_Database_NumberItems[9])], GetUnitX( udg_hero[cyclA] ), GetUnitY(udg_hero[cyclA]))
            call UnitAddItem( udg_hero[cyclA], bj_lastCreatedItem )
        endif
        set cyclA = cyclA + 1
    endloop
endfunction

//===========================================================================
function InitTrig_Necropotion takes nothing returns nothing
    set gg_trg_Necropotion = CreateTrigger(  )
    call DisableTrigger( gg_trg_Necropotion )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Necropotion, EVENT_PLAYER_UNIT_DEATH )
    call TriggerAddCondition( gg_trg_Necropotion, Condition( function Trig_Necropotion_Conditions ) )
    call TriggerAddAction( gg_trg_Necropotion, function Trig_Necropotion_Actions )
endfunction

