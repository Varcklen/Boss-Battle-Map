function Trig_PotionItemsUsed_Conditions takes nothing returns boolean
    return IsPotionItemIsUsed() and combat(GetSpellAbilityUnit(), false, 0) and not(udg_fightmod[3])
endfunction

function Trig_PotionItemsUsed_Actions takes nothing returns nothing
    local integer i = GetUnitUserData(GetSpellAbilityUnit())
    
    set udg_PotionItemsUsed[i] = udg_PotionItemsUsed[i] + 1
endfunction

//===========================================================================
function InitTrig_PotionItemsUsed takes nothing returns nothing
    set gg_trg_PotionItemsUsed = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_PotionItemsUsed, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_PotionItemsUsed, Condition( function Trig_PotionItemsUsed_Conditions ) )
    call TriggerAddAction( gg_trg_PotionItemsUsed, function Trig_PotionItemsUsed_Actions )
endfunction

