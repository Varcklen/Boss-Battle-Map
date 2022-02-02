function Trig_BuyItem_Conditions takes nothing returns boolean
    return GetUnitTypeId(GetSoldUnit()) == 'n029'
endfunction

function Trig_BuyItem_Actions takes nothing returns nothing
    call RemoveUnit( GetSoldUnit() )
    if UnitInventoryCount(GetBuyingUnit()) >= 6 then
        call DisplayTimedTextToForce( GetForceOfPlayer(GetOwningPlayer(GetBuyingUnit())), 5, "The inventory is full." )
        call SetPlayerState(GetOwningPlayer(GetBuyingUnit()), PLAYER_STATE_RESOURCE_GOLD, GetPlayerState(GetOwningPlayer(GetBuyingUnit()), PLAYER_STATE_RESOURCE_GOLD) + 350 )
    else
        call DestroyEffect ( AddSpecialEffectTarget( "Abilities\\Spells\\Human\\Polymorph\\PolyMorphDoneGround.mdl", GetBuyingUnit(), "origin") )
        call ItemRandomizerAll( GetBuyingUnit(), 0 )
    endif
endfunction

//===========================================================================
function InitTrig_BuyItem takes nothing returns nothing
    set gg_trg_BuyItem = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_BuyItem, EVENT_PLAYER_UNIT_SELL )
    call TriggerAddCondition( gg_trg_BuyItem, Condition( function Trig_BuyItem_Conditions ) )
    call TriggerAddAction( gg_trg_BuyItem, function Trig_BuyItem_Actions )
endfunction

