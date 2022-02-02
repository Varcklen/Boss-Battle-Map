function Trig_ReSub_Conditions takes nothing returns boolean
    local integer cyclA = 1
    local boolean l = false
    
    loop
        exitwhen cyclA > 6
        if GetItemTypeId(GetManipulatedItem()) == udg_Database_Score_Item[cyclA] then
            set l = true
            set cyclA = 6
        endif
        set cyclA = cyclA + 1
    endloop
    return l
endfunction

function Trig_ReSub_Actions takes nothing returns nothing
    local integer cyclA = 1
    local item t
    
    loop
        exitwhen cyclA > 6
        if GetItemTypeId(GetManipulatedItem()) == udg_Database_Score_Item[cyclA] then 
            set t = UnitItemInSlot(GetManipulatingUnit(), cyclA-1)
            if not( UnitHasItem(GetManipulatingUnit(), t ) ) or GetItemType(t) == ITEM_TYPE_POWERUP or GetItemTypeId(t) == 'I05J' or GetItemTypeId(t) == 'I0B5' or GetItemType(t) == ITEM_TYPE_PURCHASABLE then
                call SetPlayerState(GetOwningPlayer(GetManipulatingUnit()), PLAYER_STATE_RESOURCE_GOLD, GetPlayerState(GetOwningPlayer(GetManipulatingUnit()), PLAYER_STATE_RESOURCE_GOLD) + 200 )
            else
                call RemoveItem( t )
                call DestroyEffect(AddSpecialEffectTarget( "Abilities\\Spells\\Human\\Polymorph\\PolyMorphDoneGround.mdl", GetManipulatingUnit(), "origin") )
                call ItemRandomizerAll( GetManipulatingUnit(), GetItemTypeId(t) )
                set cyclA = 6
            endif
        endif
        set cyclA = cyclA + 1
    endloop
    
    set t = null
endfunction

//===========================================================================
function InitTrig_ReSub takes nothing returns nothing
    set gg_trg_ReSub = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_ReSub, EVENT_PLAYER_UNIT_PICKUP_ITEM ) 
    call TriggerAddCondition( gg_trg_ReSub, Condition( function Trig_ReSub_Conditions ) )
    call TriggerAddAction( gg_trg_ReSub, function Trig_ReSub_Actions )
endfunction

