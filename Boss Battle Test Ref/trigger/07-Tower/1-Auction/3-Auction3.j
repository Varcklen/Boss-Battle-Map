globals
    real Event_ItemExchange_Real
    item Event_ItemExchange_Item
    item Event_ItemExchange_OldItem
    unit Event_ItemExchange_Hero
    unit Event_ItemExchange_Friend
endglobals

function Trig_Auction3_Conditions takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == 'I0BJ' or GetItemTypeId(GetManipulatedItem()) == 'I07Y'
endfunction

function Trig_Auction3_Actions takes nothing returns nothing
    local integer i = GetPlayerId(GetOwningPlayer(GetManipulatingUnit())) + 1
    local integer p = 0
    local integer cyclA 
    local boolean l = true
    local integer rand
    local integer gold = ExchangeCost

    set cyclA = 0
    loop
        exitwhen cyclA > 3
        if GetOwningPlayer(udg_artifzone[i]) == Player(cyclA) then
            set p = GetPlayerId(Player(cyclA) ) + 1
        endif
        set cyclA = cyclA + 1
    endloop
    
    if udg_auctionartif[i] != null and udg_auctionartif[p] != null and GetOwningPlayer(udg_artifzone[i]) == Player(p - 1) and GetOwningPlayer(udg_artifzone[p]) == Player(i - 1) and not( udg_auctionlogic[i] ) and ( GetOwningPlayer(GetManipulatingUnit()) == Player(i - 1) or GetOwningPlayer(GetManipulatingUnit()) == Player(p - 1) ) and not( IsUnitLoaded( udg_hero[i] ) ) and not( IsUnitLoaded( udg_hero[p] ) ) then
        set udg_auctionlogic[i] = true
        set l = false
        if udg_auctionlogic[p] then
            call SetItemPosition( udg_auctionartif[i], GetUnitX(udg_hero[p]), GetUnitY(udg_hero[p]))
            if UnitInventoryCount(udg_hero[p]) >= 6 then
                set rand = GetRandomInt(0, 5)
                call RemoveItem( UnitItemInSlot( udg_hero[p], rand ) )
                call DisplayTimedTextToPlayer(Player(p - 1), 0, 0, 10., "|cffffcc00WARNING!|r There is not enough room in the inventory to exchange. Artifact |cffffcc00" + GetItemName( UnitItemInSlot( udg_hero[i], rand ) ) + "|r was removed." )
            endif
            
            set Event_ItemExchange_Hero = udg_hero[p]
            set Event_ItemExchange_Item = udg_auctionartif[i]
            
            set Event_ItemExchange_Friend = udg_hero[i]
            set Event_ItemExchange_OldItem = udg_auctionartif[p]
            
            set Event_ItemExchange_Real = 0.00
            set Event_ItemExchange_Real = 1.00
            set Event_ItemExchange_Real = 0.00
            
            set udg_auctionartif[i] = Event_ItemExchange_Item
            
            if udg_auctionartif[i] != null then
                call UnitAddItem( udg_hero[p], udg_auctionartif[i] )
            endif
            
            
            
            call SetItemPosition( udg_auctionartif[p], GetUnitX(udg_hero[i]), GetUnitY(udg_hero[i]))
            if UnitInventoryCount(udg_hero[i]) >= 6 then
                set rand = GetRandomInt(0, 5)
                call RemoveItem( UnitItemInSlot( udg_hero[i], rand ) )
                call DisplayTimedTextToPlayer(Player(i - 1), 0, 0, 10., "|cffffcc00WARNING!|r There is not enough room in the inventory to exchange. Artifact |cffffcc00" + GetItemName( UnitItemInSlot( udg_hero[i], rand ) ) + "|r was removed." )
            endif
            
            set Event_ItemExchange_Hero = udg_hero[i]
            set Event_ItemExchange_Item = udg_auctionartif[p]
            
            set Event_ItemExchange_Friend = udg_hero[p]
            set Event_ItemExchange_OldItem = udg_auctionartif[i]
            
            set Event_ItemExchange_Real = 0.00
            set Event_ItemExchange_Real = 1.00
            set Event_ItemExchange_Real = 0.00
            
            set udg_auctionartif[p] = Event_ItemExchange_Item
            
            if udg_auctionartif[p] != null then
                call UnitAddItem( udg_hero[i], udg_auctionartif[p] )
            endif
            
            
            set udg_auctionartif[i] = null
            set udg_auctionartif[p] = null
            set udg_auctionlogic[i] = false
            set udg_auctionlogic[p] = false
            call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Human\\Resurrect\\ResurrectTarget.mdl", udg_hero[i], "origin" ) )
            call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Human\\Resurrect\\ResurrectTarget.mdl", udg_hero[p], "origin" ) )
            call SetUnitOwner( udg_artifzone[i], Player(PLAYER_NEUTRAL_PASSIVE), true )
            call SetUnitOwner( udg_artifzone[p], Player(PLAYER_NEUTRAL_PASSIVE), true )
        else
            call DisplayTimedTextToPlayer(Player(i - 1), 0, 0, 5., "Wait for the other player to click |cffffcc00'Make an exchange'|r." )
            call DisplayTimedTextToPlayer(Player(p - 1), 0, 0, 5., "Another player is ready to complete the exchange. Click |cffffcc00'Make an exchange'|r." )
        endif
    elseif udg_auctionlogic[i] then
        call DisplayTimedTextToPlayer( GetOwningPlayer(GetManipulatingUnit()), 0, 0, 5., "You have already clicked 'Make Exchange'. Wait for another player." )
    elseif IsUnitLoaded( udg_hero[i] ) or IsUnitLoaded( udg_hero[p] ) then
        call DisplayTimedTextToPlayer( GetOwningPlayer(GetManipulatingUnit()), 0, 0, 5., "Get out of the vehicle to finish the exchange (another player too)." )
    elseif udg_auctionartif[i] == null then
        call DisplayTimedTextToPlayer( GetOwningPlayer(GetManipulatingUnit()), 0, 0, 5., "You does not have an artifact in the exchanger." )
    elseif udg_auctionartif[p] == null then
        call DisplayTimedTextToPlayer( GetOwningPlayer(GetManipulatingUnit()), 0, 0, 5., "Another player does not have an artifact in the exchanger." )
    else
        call DisplayTimedTextToPlayer(GetOwningPlayer(GetManipulatingUnit()), 0, 0, 5, "The conditions are not met." )
    endif
    if  l then
        call SetPlayerState(GetOwningPlayer(GetManipulatingUnit()), PLAYER_STATE_RESOURCE_GOLD, GetPlayerState(GetOwningPlayer(GetManipulatingUnit()), PLAYER_STATE_RESOURCE_GOLD) + gold)
    endif
endfunction

//===========================================================================
function InitTrig_Auction3 takes nothing returns nothing
    set gg_trg_Auction3 = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Auction3, EVENT_PLAYER_UNIT_PICKUP_ITEM ) 
    call TriggerAddCondition( gg_trg_Auction3, Condition( function Trig_Auction3_Conditions ) )
    call TriggerAddAction( gg_trg_Auction3, function Trig_Auction3_Actions )
endfunction