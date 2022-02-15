scope SteelRose initializer init

    globals
        private constant integer ID_ITEM = 'I0BT'
        private constant integer STRING_HASH = StringHash( "strz" )
        
        private constant integer ITEMS_NEEDED = 6
        private constant integer BONUS_RESSURECTIONS = 4
    endglobals

    private function SetRessurections takes unit hero returns nothing
        local integer heroId = GetHandleId( hero )
        local boolean isActive = LoadBoolean( udg_hash, heroId, STRING_HASH )
        local item myItem
        local integer i = 0
        local integer f = 0

        loop
            exitwhen i > 5
            set myItem = UnitItemInSlot(hero, i)
            if NatureLogic( myItem ) or GetItemTypeId(myItem) == 'I03I' then
                set f = f + 1
            endif
            set i = i + 1
        endloop
        if f >= ITEMS_NEEDED and isActive == false then
            call SaveBoolean( udg_hash, heroId, STRING_HASH, true )
            call RessurectionPoints(BONUS_RESSURECTIONS, true )
        elseif f < ITEMS_NEEDED and isActive then
            call SaveBoolean( udg_hash, heroId, STRING_HASH, false )
            call RessurectionPoints( -BONUS_RESSURECTIONS, true )
        endif

        set myItem = null
        set hero = null
    endfunction

    
    //Add nature
    private function AddNature_Conditions takes nothing returns boolean
        return IsHeroHasItem( Event_AddNature_Hero, ID_ITEM)
    endfunction
    
    private function AddNature takes nothing returns nothing
        call SetRessurections(Event_AddNature_Hero)
    endfunction
    
    
    //Remove nature
    private function RemoveNature_Conditions takes nothing returns boolean
        return IsHeroHasItem( Event_RemoveNature_Hero, ID_ITEM)
    endfunction
    
    private function RemoveNature takes nothing returns nothing
        call SetRessurections(Event_RemoveNature_Hero)
    endfunction
    
    
    //Remove item
    private function RemoveItem_Conditions takes nothing returns boolean
        return GetItemTypeId(GetManipulatedItem()) == 'I0BT' and LoadBoolean( udg_hash, GetHandleId(  GetManipulatingUnit() ), STRING_HASH )
    endfunction
    
    private function RemoveItem_Actions takes nothing returns nothing
        call SaveBoolean( udg_hash, GetHandleId(  GetManipulatingUnit() ), STRING_HASH, false )
        call RessurectionPoints( -BONUS_RESSURECTIONS, true )
    endfunction

    private function init takes nothing returns nothing
        local trigger trig = CreateTrigger()
        call TriggerRegisterAnyUnitEventBJ( trig, EVENT_PLAYER_UNIT_DROP_ITEM )
        call TriggerAddCondition( trig, Condition( function RemoveItem_Conditions ) )
        call TriggerAddAction( trig, function RemoveItem_Actions )
    
        call CreateEventTrigger( "Event_AddNature_Real", function AddNature, function AddNature_Conditions )
        call CreateEventTrigger( "Event_RemoveNature_Real", function RemoveNature, function RemoveNature_Conditions )
        
        set trig = null
    endfunction

endscope