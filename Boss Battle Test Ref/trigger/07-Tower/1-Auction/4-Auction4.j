function Trig_Auction4_Conditions takes nothing returns boolean
    local integer cyclA = 0
    local boolean l = false
    
    loop
        exitwhen cyclA > 3
        if GetUnitTypeId(GetSoldUnit()) == 'n02A' + cyclA then
            set l = true
        endif
        set cyclA = cyclA + 1
    endloop
    return l
endfunction

function Trig_Auction4_Actions takes nothing returns nothing
    local integer cyclA = 0
    local integer n = 0
    local integer i = GetPlayerId(GetOwningPlayer(GetBuyingUnit())) + 1
    local integer gold = ExchangeCost
    
    call RemoveUnit( GetSoldUnit() )
    set udg_auctionlogic[i] = false
    loop  
        exitwhen cyclA > 5
        if UnitHasItem(udg_hero[i], UnitItemInSlot(udg_hero[i], cyclA)) then
            set n = n + 1
        endif
        set cyclA = cyclA + 1
    endloop
    if n < 6 then
        if udg_auctionartif[i] != null then
            if udg_auctionlogic[i] then
                call SetPlayerState(GetOwningPlayer(GetBuyingUnit()), PLAYER_STATE_RESOURCE_GOLD, GetPlayerState(GetOwningPlayer(GetBuyingUnit()), PLAYER_STATE_RESOURCE_GOLD) + gold)
            endif
            call SetItemPosition(udg_auctionartif[i], GetUnitX(udg_hero[i]), GetUnitY(udg_hero[i]))
            call UnitAddItem(udg_hero[i], udg_auctionartif[i] )
            set udg_auctionartif[i] = null
            set cyclA = 1
            loop
                exitwhen cyclA > 4
                if GetOwningPlayer( udg_artifzone[cyclA] ) == GetOwningPlayer( GetBuyingUnit() ) and udg_auctionlogic[cyclA] then
                    set udg_auctionlogic[cyclA] = false
                    call SetPlayerState( Player(cyclA - 1), PLAYER_STATE_RESOURCE_GOLD, GetPlayerState(Player(cyclA - 1), PLAYER_STATE_RESOURCE_GOLD) + gold)
                    call SetUnitOwner( udg_artifzone[cyclA], Player(PLAYER_NEUTRAL_PASSIVE), true )
                    call DisplayTimedTextToPlayer( Player(cyclA - 1), 0, 0, 5., "|cffffcc00Exchanger:|r Color reset. Another player posted an artifact from the exchanger." )
                endif
                set cyclA = cyclA + 1
            endloop
        else
            call DisplayTimedTextToPlayer(GetOwningPlayer(GetBuyingUnit()), 0, 0, 5., "The artifact is missing from the exchanger.")
        endif
    else
        call DisplayTimedTextToPlayer(GetOwningPlayer(GetBuyingUnit()), 0, 0, 5., "The inventory is full.")
    endif
endfunction

//===========================================================================
function InitTrig_Auction4 takes nothing returns nothing
    set gg_trg_Auction4 = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Auction4, EVENT_PLAYER_UNIT_SELL )
    call TriggerAddCondition( gg_trg_Auction4, Condition( function Trig_Auction4_Conditions ) )
    call TriggerAddAction( gg_trg_Auction4, function Trig_Auction4_Actions )
endfunction

