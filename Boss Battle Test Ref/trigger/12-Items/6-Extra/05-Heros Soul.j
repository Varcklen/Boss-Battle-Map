function Trig_Heros_Soul_Conditions takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == 'I0G2' and udg_Ability_Spec[GetPlayerId(GetOwningPlayer(GetManipulatingUnit())) + 1] == 0
endfunction

function Trig_Heros_Soul_Actions takes nothing returns nothing
    call forgespell(GetManipulatingUnit(), GetManipulatedItem())
endfunction

//===========================================================================
function InitTrig_Heros_Soul takes nothing returns nothing
    set gg_trg_Heros_Soul = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Heros_Soul, EVENT_PLAYER_UNIT_USE_ITEM )
    call TriggerAddCondition( gg_trg_Heros_Soul, Condition( function Trig_Heros_Soul_Conditions ) )
    call TriggerAddAction( gg_trg_Heros_Soul, function Trig_Heros_Soul_Actions )
endfunction

