function Trig_Armor_Knight_Conditions takes nothing returns boolean
    return inv(GetManipulatingUnit(), 'I001') > 0 and inv(GetManipulatingUnit(), 'I002') > 0 and inv(GetManipulatingUnit(), 'I000') > 0
endfunction

function Trig_Armor_Knight_Actions takes nothing returns nothing
    local integer i = GetPlayerId(GetOwningPlayer(GetManipulatingUnit())) + 1
    local integer cyclA = 0
    local item it

    call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\Human\\Resurrect\\ResurrectCaster.mdl", GetManipulatingUnit(), "origin" ) )

    loop
        exitwhen cyclA > 3
        if GetPlayerSlotState( Player( cyclA ) ) == PLAYER_SLOT_STATE_PLAYING then
            call DisplayTimedTextToPlayer( Player(cyclA), 0, 0, 10., udg_Player_Color[i] + GetPlayerName(GetOwningPlayer(GetManipulatingUnit())) + "|r assembled the Knight Armor!")
        endif
        set cyclA = cyclA + 1
    endloop
    call RemoveItem( GetItemOfTypeFromUnitBJ(GetManipulatingUnit(), 'I002') )
    call RemoveItem( GetItemOfTypeFromUnitBJ(GetManipulatingUnit(), 'I000') )
    call RemoveItem( GetItemOfTypeFromUnitBJ(GetManipulatingUnit(), 'I001') )
    set bj_lastCreatedItem = CreateItem('I003', GetUnitX(GetManipulatingUnit()), GetUnitY(GetManipulatingUnit()))
    call UnitAddItem(GetManipulatingUnit(), bj_lastCreatedItem)
    
    set it = null
endfunction

//===========================================================================
function InitTrig_Armor_Knight takes nothing returns nothing
    set gg_trg_Armor_Knight = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Armor_Knight, EVENT_PLAYER_UNIT_PICKUP_ITEM )
    call TriggerAddCondition( gg_trg_Armor_Knight, Condition( function Trig_Armor_Knight_Conditions ) )
    call TriggerAddAction( gg_trg_Armor_Knight, function Trig_Armor_Knight_Actions )
endfunction

