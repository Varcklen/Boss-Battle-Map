function Trig_SLCG_Conditions takes nothing returns boolean
    return GetUnitTypeId(GetSellingUnit()) == 'h007' and inv( GetBuyingUnit(), 'I0B9' ) > 0
endfunction

function Trig_SLCG_Actions takes nothing returns nothing
    local integer i = GetPlayerId(GetOwningPlayer(GetBuyingUnit())) + 1
    local integer id = GetHandleId( GetBuyingUnit() )
    local integer s = LoadInteger( udg_hash, id, StringHash( udg_QuestItemCode[16] ) ) + 1
    
    call SaveInteger( udg_hash, id, StringHash( udg_QuestItemCode[16] ), s )

    if s >= udg_QuestNum[16] then
        call RemoveItem( GetItemOfTypeFromUnitBJ(GetBuyingUnit(), 'I0B9') )
        call UnitAddItem(GetBuyingUnit(), CreateItem( 'I0EZ', GetUnitX(GetBuyingUnit()), GetUnitY(GetBuyingUnit())))
        call textst( "|c00ffffff Scholar's Gambit done!", GetBuyingUnit(), 64, GetRandomReal( 45, 135 ), 12, 1.5 )
        call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\ReviveHuman\\ReviveHuman.mdl", GetUnitX(GetBuyingUnit()), GetUnitY(GetBuyingUnit()) ) )
        set udg_QuestDone[i] = true
    else
        call QuestDiscription( GetBuyingUnit(), 'I0B9', s, udg_QuestNum[16] )
    endif
endfunction

//===========================================================================
function InitTrig_SLCG takes nothing returns nothing
    set gg_trg_SLCG = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_SLCG, EVENT_PLAYER_UNIT_SELL_ITEM )
    call TriggerAddCondition( gg_trg_SLCG, Condition( function Trig_SLCG_Conditions ) )
    call TriggerAddAction( gg_trg_SLCG, function Trig_SLCG_Actions )
endfunction

