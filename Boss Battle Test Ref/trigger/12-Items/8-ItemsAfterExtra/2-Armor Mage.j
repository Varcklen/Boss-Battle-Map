function Trig_Armor_Mage_Conditions takes nothing returns boolean
    return inv(GetManipulatingUnit(), 'I02Q') > 0 and inv(GetManipulatingUnit(), 'I02J') > 0 and inv(GetManipulatingUnit(), 'I02D') > 0
endfunction

function Trig_Armor_Mage_Actions takes nothing returns nothing
    local integer i = GetPlayerId(GetOwningPlayer(GetManipulatingUnit())) + 1
    local integer cyclA = 0
    local item it

    call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\Human\\Resurrect\\ResurrectCaster.mdl", GetManipulatingUnit(), "origin" ) )

    loop
        exitwhen cyclA > 3
        if GetPlayerSlotState( Player( cyclA ) ) == PLAYER_SLOT_STATE_PLAYING then
            call DisplayTimedTextToPlayer( Player(cyclA), 0, 0, 10., udg_Player_Color[i] + GetPlayerName(GetOwningPlayer(GetManipulatingUnit())) + "|r assembled the Mage Armor!")
        endif
        set cyclA = cyclA + 1
    endloop
    call RemoveItem( GetItemOfTypeFromUnitBJ(GetManipulatingUnit(), 'I02Q') )
    call RemoveItem( GetItemOfTypeFromUnitBJ(GetManipulatingUnit(), 'I02J') )
    call RemoveItem( GetItemOfTypeFromUnitBJ(GetManipulatingUnit(), 'I02D') )
    set bj_lastCreatedItem = CreateItem('I02R', GetUnitX(GetManipulatingUnit()), GetUnitY(GetManipulatingUnit()))
    call UnitAddItem(GetManipulatingUnit(), bj_lastCreatedItem)
    
    set it = null
endfunction

//===========================================================================
function InitTrig_Armor_Mage takes nothing returns nothing
    set gg_trg_Armor_Mage = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Armor_Mage, EVENT_PLAYER_UNIT_PICKUP_ITEM )
    call TriggerAddCondition( gg_trg_Armor_Mage, Condition( function Trig_Armor_Mage_Conditions ) )
    call TriggerAddAction( gg_trg_Armor_Mage, function Trig_Armor_Mage_Actions )
endfunction

