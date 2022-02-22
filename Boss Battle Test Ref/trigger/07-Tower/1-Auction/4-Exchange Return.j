scope ExchangeReturn initializer init

    globals
        private integer array Buttons[PLAYERS_LIMIT_ARRAYS]
    endglobals

    private function Trig_Exchange_Return_Conditions takes nothing returns boolean
        local integer i = 1
        
        if combat(GetManipulatingUnit(), false, 0) and udg_logic[0] == false then
            return false
        endif
        loop
            exitwhen i > PLAYERS_LIMIT
            if GetItemTypeId(GetManipulatedItem()) == Buttons[i] then
                return true
            endif
            set i = i + 1
        endloop
        return false
    endfunction
    
    private function InfoReset takes unit hero, integer gold returns nothing
        local integer i = 1
        local player ally
    
        loop
            exitwhen i > PLAYERS_LIMIT
            if GetOwningPlayer( udg_artifzone[i] ) == GetOwningPlayer( hero ) and udg_auctionlogic[i] then
                set ally = Player(i - 1)
                set udg_auctionlogic[i] = false
                call SetPlayerState( ally, PLAYER_STATE_RESOURCE_GOLD, GetPlayerState(ally, PLAYER_STATE_RESOURCE_GOLD) + gold)
                call SetUnitOwner( udg_artifzone[i], Player(PLAYER_NEUTRAL_PASSIVE), true )
                call DisplayTimedTextToPlayer( ally, 0, 0, 5, "|cffffcc00Exchanger:|r Color reset. Another player posted an artifact from the exchanger." )
                set i = PLAYERS_LIMIT
            endif
            set i = i + 1
        endloop
    
        set ally = null
        set hero = null
    endfunction

    private function Trig_Exchange_Return_Actions takes nothing returns nothing
        local unit hero = GetManipulatingUnit()
        local player owner = GetOwningPlayer(hero)
        local integer index = GetPlayerId(owner) + 1
        local integer gold = ExchangeCost
        
        set udg_auctionlogic[index] = false
        
        if UnitInventoryCount(hero) < 6 then
            if udg_auctionartif[index] != null then
                if udg_auctionlogic[index] then
                    call SetPlayerState(GetOwningPlayer(hero), PLAYER_STATE_RESOURCE_GOLD, GetPlayerState(GetOwningPlayer(hero), PLAYER_STATE_RESOURCE_GOLD) + gold)
                endif
                call SetItemPosition(udg_auctionartif[index], GetUnitX(hero), GetUnitY(hero))
                call UnitAddItem(hero, udg_auctionartif[index] )
                set udg_auctionartif[index] = null
                call InfoReset(hero, gold)
            else
                call DisplayTimedTextToPlayer(owner, 0, 0, 5, "The artifact is missing from the exchanger.")
            endif
        else
            call DisplayTimedTextToPlayer(owner, 0, 0, 5, "The inventory is full.")
        endif
        
        set hero = null
        set owner = null
    endfunction

    //===========================================================================
    private function init takes nothing returns nothing
        set gg_trg_Exchange_Return = CreateTrigger(  )
        call TriggerRegisterAnyUnitEventBJ( gg_trg_Exchange_Return, EVENT_PLAYER_UNIT_PICKUP_ITEM ) 
        call TriggerAddCondition( gg_trg_Exchange_Return, Condition( function Trig_Exchange_Return_Conditions ) )
        call TriggerAddAction( gg_trg_Exchange_Return, function Trig_Exchange_Return_Actions )
        
        set Buttons[1] = 'IV12'
        set Buttons[2] = 'IV10'
        set Buttons[3] = 'IV11'
        set Buttons[4] = 'IV13'
    endfunction

endscope