function Trig_Armor_Bandit_Conditions takes nothing returns boolean
    return inv(GetManipulatingUnit(), 'I05V') > 0 and inv(GetManipulatingUnit(), 'I06A') > 0 and inv(GetManipulatingUnit(), 'I06B') > 0
endfunction

function Trig_Armor_Bandit_Actions takes nothing returns nothing
    local integer i = GetPlayerId(GetOwningPlayer(GetManipulatingUnit())) + 1
    local integer cyclA = 0
    local item it

    call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\Human\\Resurrect\\ResurrectCaster.mdl", GetManipulatingUnit(), "origin" ) )

    loop
        exitwhen cyclA > 3
        if GetPlayerSlotState( Player( cyclA ) ) == PLAYER_SLOT_STATE_PLAYING then
            call DisplayTimedTextToPlayer( Player(cyclA), 0, 0, 10, udg_Player_Color[i] + GetPlayerName(GetOwningPlayer(GetManipulatingUnit())) + "|r assembled the Bandit Armor!")
        endif
        set cyclA = cyclA + 1
    endloop
    call RemoveItem( GetItemOfTypeFromUnitBJ(GetManipulatingUnit(), 'I05V') )
    call RemoveItem( GetItemOfTypeFromUnitBJ(GetManipulatingUnit(), 'I06A') )
    call RemoveItem( GetItemOfTypeFromUnitBJ(GetManipulatingUnit(), 'I06B') )
    set bj_lastCreatedItem = CreateItem('I06K', GetUnitX(GetManipulatingUnit()), GetUnitY(GetManipulatingUnit()))
    call UnitAddItem(GetManipulatingUnit(), bj_lastCreatedItem)
    
    set it = null
endfunction

//===========================================================================
function InitTrig_Armor_Bandit takes nothing returns nothing
    set gg_trg_Armor_Bandit = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Armor_Bandit, EVENT_PLAYER_UNIT_PICKUP_ITEM )
    call TriggerAddCondition( gg_trg_Armor_Bandit, Condition( function Trig_Armor_Bandit_Conditions ) )
    call TriggerAddAction( gg_trg_Armor_Bandit, function Trig_Armor_Bandit_Actions )
endfunction

