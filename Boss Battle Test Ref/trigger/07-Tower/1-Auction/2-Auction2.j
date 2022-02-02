function Trig_Auction2_Conditions takes nothing returns boolean
    local integer cyclA = 0
    local boolean l = false
    
    loop
        exitwhen cyclA > 3
        if GetUnitTypeId(GetSoldUnit()) == 'n01G' + cyclA then
            set l = true
        endif
        set cyclA = cyclA + 1
    endloop
    return l
endfunction

function Trig_Auction2_Actions takes nothing returns nothing
    local integer cyclA = 1
    local integer i = GetPlayerId(GetOwningPlayer(GetBuyingUnit())) + 1
    local integer gold = ExchangeCost
    
    call RemoveUnit( GetSoldUnit() )
    
    if udg_auctionlogic[i] then
	call SetPlayerState(GetOwningPlayer(GetBuyingUnit()), PLAYER_STATE_RESOURCE_GOLD, GetPlayerState(GetOwningPlayer(GetBuyingUnit()), PLAYER_STATE_RESOURCE_GOLD) + gold)

        loop
            exitwhen cyclA > 4
            if GetOwningPlayer(udg_artifzone[cyclA]) == GetOwningPlayer(GetBuyingUnit()) and udg_auctionlogic[cyclA] then
                set udg_auctionlogic[cyclA] = false
                call SetPlayerState(Player(cyclA - 1), PLAYER_STATE_RESOURCE_GOLD, GetPlayerState(Player(cyclA - 1), PLAYER_STATE_RESOURCE_GOLD) + gold)
                call SetUnitOwner( udg_artifzone[cyclA], Player(PLAYER_NEUTRAL_PASSIVE), true )
                set cyclA = 4
            endif
            set cyclA = cyclA + 1
        endloop
    endif
    set udg_auctionlogic[i] = false
    set cyclA = 1
    loop
        exitwhen cyclA > 4
        if GetUnitTypeId(GetSoldUnit()) == 'n01F' + cyclA then
            if GetUnitState( udg_hero[cyclA], UNIT_STATE_LIFE) > 0.405 then
                call PanCameraToTimedLocForPlayer( Player(i - 1), GetUnitLoc( udg_hero[cyclA] ), 0 )
            endif
            call SetUnitOwner( udg_artifzone[i], Player(cyclA - 1), true )
        endif
        set cyclA = cyclA + 1
    endloop
endfunction

//===========================================================================
function InitTrig_Auction2 takes nothing returns nothing
    set gg_trg_Auction2 = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Auction2, EVENT_PLAYER_UNIT_SELL )
    call TriggerAddCondition( gg_trg_Auction2, Condition( function Trig_Auction2_Conditions ) )
    call TriggerAddAction( gg_trg_Auction2, function Trig_Auction2_Actions )
endfunction

