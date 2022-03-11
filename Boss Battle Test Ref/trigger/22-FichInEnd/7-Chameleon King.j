function Trig_Chameleon_King_Conditions takes nothing returns boolean
    return SubString(BlzGetItemExtendedTooltip(GetManipulatedItem()), 0, 19) == "|cFFFFFF7DChameleon" and combat( GetManipulatingUnit(), false, 0 )
endfunction

function Trig_Chameleon_King_Actions takes nothing returns nothing
    local item it = GetManipulatedItem()
    local unit u = GetManipulatingUnit()

    if GetUnitState( u, UNIT_STATE_LIFE) > 0.405 then
        call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\Polymorph\\PolyMorphDoneGround.mdl", GetUnitX( u ), GetUnitY( u ) ) )
        call Inventory_ReplaceItemByNew(u, it, udg_DB_Item_Activate[GetRandomInt( 1, udg_Database_NumberItems[31] )])
    endif
    
    set it = null
    set u = null
endfunction

//===========================================================================
function InitTrig_Chameleon_King takes nothing returns nothing
    set gg_trg_Chameleon_King = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Chameleon_King, EVENT_PLAYER_UNIT_USE_ITEM )
    call TriggerAddCondition( gg_trg_Chameleon_King, Condition( function Trig_Chameleon_King_Conditions ) )
    call TriggerAddAction( gg_trg_Chameleon_King, function Trig_Chameleon_King_Actions )
endfunction

