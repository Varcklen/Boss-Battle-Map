scope SplitShop initializer init

    globals
        real Event_ItemSplit_Real
        item Event_ItemSplit_Item
        unit Event_ItemSplit_Hero
        
        private constant integer COST = 150
        
        private constant string ANIMATION = "Abilities\\Spells\\Undead\\DarkRitual\\DarkRitualTarget.mdl"
    endglobals

    private function Trig_SplitShop_Conditions takes nothing returns boolean
        local integer i = 0
        local boolean l = false
        
        loop
            exitwhen i > 5
            if GetUnitTypeId(GetSoldUnit()) == 'n00H' + i then 
                return true
            endif
            set i = i + 1
        endloop
        return false
    endfunction

    private function ThisItem takes item it returns boolean
        local boolean l = false
        local integer itemType = GetItemTypeId(it)
        
        if itemType == 'I03I' then
            set l = true
        elseif itemType == 'I052' then
            set l = true
        elseif itemType == 'I05J' then
            set l = true
        elseif itemType == 'I030' then
            set l = true
        endif
        set it = null
        return l
    endfunction
    
    private function IsCanSplit takes unit hero, item it returns boolean
        local player owner = GetOwningPlayer(hero)
        local boolean isCan = true
        
        if it == null then
            set isCan = false
            call DisplayTimedTextToPlayer( owner, 0, 0, 5, "You can't split an item that doesn't exist." )
        elseif ThisItem(it) then
            set isCan = false
            call DisplayTimedTextToPlayer( owner, 0, 0, 5, "This item cannot be split." )
        endif
        
        if isCan == false then
            if GetLocalPlayer() == owner then
                call StartSound(gg_snd_Error)
            endif
        endif
        
        set owner = null
        set hero = null
        set it = null
        return isCan
    endfunction
    
    private function Split takes unit hero, item splittedItem, integer index returns nothing
    
        if IsCanSplit(hero, splittedItem) then
            if BlzGetItemAbility( splittedItem, 'A0G2' ) != null or GetItemType(splittedItem) == ITEM_TYPE_POWERUP then//Random Bonus
                call SetPlayerState(GetOwningPlayer(hero), PLAYER_STATE_RESOURCE_GOLD, GetPlayerState(GetOwningPlayer(hero), PLAYER_STATE_RESOURCE_GOLD) + COST)
            endif
        
            call PlaySpecialEffect(ANIMATION, hero)

            set Event_ItemSplit_Item = splittedItem
            set Event_ItemSplit_Hero = hero
            set Event_ItemSplit_Real = 0.00
            set Event_ItemSplit_Real = 1.00
            set Event_ItemSplit_Real = 0.00
            
            call RemoveItem( splittedItem )
        else
            call SetPlayerState(GetOwningPlayer(hero), PLAYER_STATE_RESOURCE_GOLD, GetPlayerState(GetOwningPlayer(hero), PLAYER_STATE_RESOURCE_GOLD) + COST)
        endif
    
        set hero = null
        set splittedItem = null
    endfunction

    private function Trig_SplitShop_Actions takes nothing returns nothing
        local unit hero = GetBuyingUnit()
        local unit n = GetSoldUnit()
        local integer i
        local integer j    
        local boolean k = false
        local item it
        local integer buttonType = GetUnitTypeId(n)

        call RemoveUnit( n )
        set i = 0
        loop
            exitwhen i > 5
            if buttonType == 'n00H' + i then
                call Split(hero, UnitItemInSlot(hero, i), i)
                set i = 5
            endif
            set i = i + 1
        endloop
        
        set it = null
        set hero = null
        set n = null
    endfunction

    //===========================================================================
    private function init takes nothing returns nothing
        set gg_trg_SplitShop = CreateTrigger(  )
        call TriggerRegisterAnyUnitEventBJ( gg_trg_SplitShop, EVENT_PLAYER_UNIT_SELL )
        call TriggerAddCondition( gg_trg_SplitShop, Condition( function Trig_SplitShop_Conditions ) )
        call TriggerAddAction( gg_trg_SplitShop, function Trig_SplitShop_Actions )
    endfunction

endscope