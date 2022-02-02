function Trig_PotionDeath_Conditions takes nothing returns boolean
    return GetUnitTypeId(GetDyingUnit()) == 'h01J'
endfunction

function Trig_PotionDeath_Actions takes nothing returns nothing
    call CreateItem( udg_Database_Item_Potion[GetRandomInt(1, udg_Database_NumberItems[9])], GetUnitX( GetDyingUnit() ), GetUnitY( GetDyingUnit() ) )
endfunction
    

//===========================================================================
function InitTrig_PotionDeath takes nothing returns nothing
    set gg_trg_PotionDeath = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_PotionDeath, EVENT_PLAYER_UNIT_DEATH )
    call TriggerAddCondition( gg_trg_PotionDeath, Condition( function Trig_PotionDeath_Conditions ) )
    call TriggerAddAction( gg_trg_PotionDeath, function Trig_PotionDeath_Actions )
endfunction

