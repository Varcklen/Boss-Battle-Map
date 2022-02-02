function Trig_ExtraExp_Conditions takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == 'I0EA' or GetItemTypeId(GetManipulatedItem()) == 'I0EB'
endfunction

function Trig_ExtraExp_Actions takes nothing returns nothing
    local unit u = GetManipulatingUnit()
    local player p = GetOwningPlayer(u)
    local integer i = GetPlayerId(p) + 1

    if GetItemTypeId(GetManipulatedItem()) == 'I0EA' then
        if udg_ExtraExp[i] < 500 then
            set udg_ExtraExp[i] = udg_ExtraExp[i] + 5
            call DisplayTimedTextToPlayer( p, 0, 0, 5, "|cffffcc00Current experience:|r " + I2S(udg_ExtraExp[i]) + "/500.")
        else
            call DisplayTimedTextToPlayer( p, 0, 0, 5, "|cffffcc00Limit reached:|r " + I2S(udg_ExtraExp[i]) + "/500.")
            call SetPlayerState( p, PLAYER_STATE_RESOURCE_GOLD, GetPlayerState(p, PLAYER_STATE_RESOURCE_GOLD ) + 50 )
        endif
    elseif GetItemTypeId(GetManipulatedItem()) == 'I0EB' then
        if 50+udg_ExtraExp[i] <= 500 then
            set udg_ExtraExp[i] = udg_ExtraExp[i] + 50
            call DisplayTimedTextToPlayer( p, 0, 0, 5, "|cffffcc00Current experience:|r " + I2S(udg_ExtraExp[i]) + "/500.")
        else
            call DisplayTimedTextToPlayer( p, 0, 0, 5, "|cffffcc00Limit reached:|r " + I2S(udg_ExtraExp[i]) + "/500.")
            call SetPlayerState( p, PLAYER_STATE_RESOURCE_GOLD, GetPlayerState(p, PLAYER_STATE_RESOURCE_GOLD ) + 500 )
        endif
    endif
        
    set u = null
    set p = null
endfunction

//===========================================================================
function InitTrig_ExtraExp takes nothing returns nothing
    set gg_trg_ExtraExp = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_ExtraExp, EVENT_PLAYER_UNIT_PICKUP_ITEM )
    call TriggerAddCondition( gg_trg_ExtraExp, Condition( function Trig_ExtraExp_Conditions ) )
    call TriggerAddAction( gg_trg_ExtraExp, function Trig_ExtraExp_Actions )
endfunction

