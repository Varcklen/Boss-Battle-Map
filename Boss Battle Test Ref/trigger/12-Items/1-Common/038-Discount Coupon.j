scope DiscountCoupon initializer init

    globals
        private constant integer ID_ITEM = 'I0A3'
        private constant integer GOLD_BONUS = 150
    endglobals

    function ItemSplit_Conditions takes nothing returns boolean
        return IsHeroHasItem( Event_ItemSplit_Hero, ID_ITEM ) and GetItemType(Event_ItemSplit_Item) != ITEM_TYPE_POWERUP and GetItemType(Event_ItemSplit_Item) != ITEM_TYPE_PURCHASABLE
    endfunction
    
    function ItemSplit takes nothing returns nothing
        call moneyst( Event_ItemSplit_Hero, GOLD_BONUS )
    endfunction

    private function init takes nothing returns nothing
        call CreateEventTrigger( "Event_ItemSplit_Real", function ItemSplit, function ItemSplit_Conditions )
    endfunction
endscope