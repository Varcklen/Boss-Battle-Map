library Inventory

    function inv takes unit u, integer id returns integer
        local integer i = 0
        local integer cyclA = 0
        local item it

        loop
            exitwhen cyclA > 5
            set it = UnitItemInSlot( u, cyclA )
            if GetItemTypeId( it ) == id then
                set i = i + 1
            endif
            set cyclA = cyclA + 1
        endloop
        set it = null
        set u = null
        return i
    endfunction

    function IsHeroHasItem takes unit hero, integer itemId returns boolean
        local boolean hasItem = false
        local integer i = 0
        
        loop
            exitwhen i > 5 or hasItem
            if GetItemTypeId( UnitItemInSlot( hero, i ) ) == itemId then
                set hasItem = true
            endif
            set i = i + 1
        endloop
        set hero = null
        return hasItem
    endfunction

    private function SetModificators takes unit owner, item oldItem, item newItem returns nothing
        if SubString(BlzGetItemExtendedTooltip(oldItem), 0, 19) == "|cff00cceeChameleon" then
            call BlzSetItemIconPath( newItem, "|cff00cceeChameleon|r|n" + BlzGetItemExtendedTooltip(newItem) )
        endif
        if SubString(BlzGetItemExtendedTooltip(oldItem), 0, 19) == "|cFFFFFF7DChameleon" then
            call BlzSetItemIconPath( newItem, "|cFFFFFF7DChameleon|r|n" + BlzGetItemExtendedTooltip(newItem) )
        endif
        if SubString(BlzGetItemExtendedTooltip(oldItem), 0, 15) == "|cFFB20080Ditto" then
            call BlzSetItemIconPath( newItem, "|cFFB20080Ditto|r|n" + BlzGetItemExtendedTooltip(newItem) )
        endif
        /*elseif SubString(BlzGetItemExtendedTooltip(oldItem), 0, 18) == "|cffC71585Cursed|r" then
            call BlzSetItemIconPath( newItem, "|cffC71585Cursed|r|n" + BlzGetItemExtendedTooltip(newItem) )
        endif*/

        set owner = null
        set oldItem = null
        set newItem = null
    endfunction

    public function ReplaceItemByNew takes unit owner, item oldItem, integer newItem returns item

        call UnitRemoveItem(owner, oldItem)
        set bj_lastCreatedItem = CreateItem( newItem, GetUnitX(owner), GetUnitY(owner) )
        call SetModificators(owner, oldItem, bj_lastCreatedItem)
        call RemoveItem(oldItem)
        call UnitAddItem( owner, bj_lastCreatedItem )
        
        set owner = null
        set oldItem = null
        return bj_lastCreatedItem
    endfunction

    public function ReplaceItem takes unit owner, item oldItem, item newItem returns nothing
        
        call UnitRemoveItem(owner, oldItem)
        call SetModificators(owner, oldItem, newItem)
        call RemoveItem(oldItem)
        if IsItemOwned(newItem) == false then
            call UnitAddItem( owner, newItem )
        endif
        
        set owner = null
        set oldItem = null
        set newItem = null
    endfunction

endlibrary