scope Auction01 initializer init

    globals
        integer array PutInExcanger[6]
        
        integer ExchangeCost = 125
    endglobals

    function Trig_Auction1_Conditions takes nothing returns boolean
        local integer cyclA = 0
        local boolean l = false
        
        loop
            exitwhen cyclA > 5 or l
            if GetItemTypeId(GetManipulatedItem()) == PutInExcanger[cyclA] then
                set l = true
            endif
            set cyclA = cyclA + 1
        endloop
        return l
    endfunction

    function Auction3Logic takes nothing returns boolean
        local integer cyclA = 0
        local boolean l = false

        loop
            exitwhen cyclA > 5 or l
            if GetItemTypeId(GetManipulatedItem()) == PutInExcanger[cyclA] and GetItemType(UnitItemInSlot(GetManipulatingUnit(), cyclA)) == ITEM_TYPE_PURCHASABLE then
                set l = true
            endif
            set cyclA = cyclA + 1
        endloop
        return l
    endfunction

    function Auction2Logic takes nothing returns boolean
        local integer cyclA = 0
        local boolean l = false
        
        loop
            exitwhen cyclA > 5 or l
            if GetItemTypeId(GetManipulatedItem()) == PutInExcanger[cyclA] and ( GetItemTypeId(UnitItemInSlot(GetManipulatingUnit(), cyclA)) == 'I05J' or GetItemTypeId(UnitItemInSlot(GetManipulatingUnit(), cyclA)) == 'I030' ) then
                set l = true
            endif
            set cyclA = cyclA + 1
        endloop
        return l
    endfunction

    function Auction1Logic takes nothing returns boolean
        local integer cyclA = 0
        local boolean l = false
        
        loop
            exitwhen cyclA > 5 or l
            if GetItemTypeId(GetManipulatedItem()) == PutInExcanger[cyclA] and GetItemType(UnitItemInSlot(GetManipulatingUnit(), cyclA)) == ITEM_TYPE_POWERUP then
                set l = true
            endif
            set cyclA = cyclA + 1
        endloop
        return l
    endfunction

    function Trig_Auction1_Actions takes nothing returns nothing
        local unit hero = GetManipulatingUnit()
        local integer cyclA = 0
        local item it = null
        local boolean l = true
        local player owner = GetOwningPlayer(hero)
        local integer i = GetPlayerId(owner) + 1
        local integer j = 0

        set udg_auctionlogic[i] = false
        if GetPlayerState(owner, PLAYER_STATE_RESOURCE_GOLD) >= ExchangeCost then
            set cyclA = 1
            loop
                exitwhen cyclA > 4
                if GetOwningPlayer( udg_artifzone[cyclA] ) == GetOwningPlayer( hero ) and udg_auctionlogic[cyclA] then
                    set udg_auctionlogic[cyclA] = false
                    call SetPlayerState( Player(cyclA - 1), PLAYER_STATE_RESOURCE_GOLD, GetPlayerState(Player(cyclA - 1), PLAYER_STATE_RESOURCE_GOLD) + ExchangeCost)
                    call SetUnitOwner( udg_artifzone[cyclA], Player(PLAYER_NEUTRAL_PASSIVE), true )
                    call DisplayTimedTextToPlayer( Player(cyclA - 1), 0, 0, 5., "|cffffcc00Exchanger:|r color reset. Another player posted an artifact from the exchanger." )
                endif
                set cyclA = cyclA + 1
            endloop
            if udg_item[3 * i] == null then
                if Auction1Logic() then
                    call DisplayTimedTextToPlayer(owner, 0, 0, 5, "Only artifacts can be exchanged.")
                    set l = false
                elseif Auction2Logic() then
                    call DisplayTimedTextToPlayer(owner, 0, 0, 5, "This artifact cannot be put into the exchanger.")
                    set l = false
                elseif Auction3Logic() then
                    call DisplayTimedTextToPlayer(owner, 0, 0, 5, "|cffffcc00Quests|r cannot be exchanged.")
                    set l = false
                elseif udg_auctionartif[i] != null then
                    set it = udg_auctionartif[i]
                    call SetItemPosition( it, GetUnitX(udg_hero[i]), GetUnitY(udg_hero[i]))
                    set udg_auctionartif[i] = null
                endif
                if l then
                    set cyclA = 0
                    loop
                        exitwhen cyclA > 5
                        if GetItemTypeId(GetManipulatedItem()) == PutInExcanger[cyclA] and UnitHasItem(hero, UnitItemInSlot(hero, cyclA)) then
                            set udg_auctionartif[i] = UnitItemInSlot(GetManipulatingUnit(), cyclA)
                            call SetItemPosition(UnitItemInSlot(udg_hero[i], cyclA), GetLocationX(udg_point[i]), GetLocationY(udg_point[i]))
                        endif
                        set cyclA = cyclA + 1
                    endloop
                    if not( IsItemOwned( it ) ) and it != null then
                        call UnitAddItem( udg_hero[i], it )
                    endif
                endif
            else
                set j = ( GetPlayerId(owner) * 3 ) + 2
                call PanCameraToTimedLocForPlayer(owner, udg_itemcentr[j], 0.5 )
                call DisplayTimedTextToPlayer( owner, 0, 0, 5., "Select an artifact in the preparatory room before starting the exchange." )
                call PingMinimapLocForForceEx( GetForceOfPlayer(owner), udg_itemcentr[j], 10., bj_MINIMAPPINGSTYLE_FLASHY, 100, 0, 0 )
            endif
        else
            call DisplayTimedTextToPlayer(owner, 0, 0, 5., "Not enough gold.")
        endif
        
        set hero = null
        set owner = null
        set it = null
    endfunction

    //===========================================================================
    private function init takes nothing returns nothing
        set gg_trg_Auction1 = CreateTrigger(  )
        call TriggerRegisterAnyUnitEventBJ( gg_trg_Auction1, EVENT_PLAYER_UNIT_PICKUP_ITEM ) 
        call TriggerAddCondition( gg_trg_Auction1, Condition( function Trig_Auction1_Conditions ) )
        call TriggerAddAction( gg_trg_Auction1, function Trig_Auction1_Actions )
        
        set PutInExcanger[0] = 'I0GX'
        set PutInExcanger[1] = 'I0GW'
        set PutInExcanger[2] = 'I0GV'
        set PutInExcanger[3] = 'I0GU'
        set PutInExcanger[4] = 'I0GT'
        set PutInExcanger[5] = 'I0GS'
    endfunction

endscope