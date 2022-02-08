scope AlchemistsStone initializer init

    globals
        private constant integer ID_ALCHEMISTS_STONE_ITEM = 'I0GY'
        
        private constant integer ALCHEMISTS_STONE_BONUS_POTION_SPELL_POWER = 50
        private constant integer ALCHEMISTS_STONE_BONUS_CHARGES = 3
        
        private constant integer ALCHEMISTS_STONE_FIRE = 'I0GZ'
        private constant integer ALCHEMISTS_STONE_EARTH = 'I0H0'
        private constant integer ALCHEMISTS_STONE_WATER = 'I0H1'
        
        integer array Alchemists_Stone_Potions[9]
    endglobals
    
    private function SetPotions takes nothing returns nothing
        set Alchemists_Stone_Potions[0] = 0
        set Alchemists_Stone_Potions[1] = 0
        set Alchemists_Stone_Potions[2] = 'I0H4'
        set Alchemists_Stone_Potions[3] = 'I0H2'
        set Alchemists_Stone_Potions[4] = 'I0H7'
        set Alchemists_Stone_Potions[5] = 'I0H3'
        set Alchemists_Stone_Potions[6] = 'I0H5'
        set Alchemists_Stone_Potions[7] = 0
        set Alchemists_Stone_Potions[8] = 'I0H6'
    endfunction

    private function Conditions takes nothing returns boolean
        return GetItemTypeId(GetManipulatedItem()) == ID_ALCHEMISTS_STONE_ITEM
    endfunction

    private function GetItem takes unit caster, integer element1, integer element2 returns nothing
        local integer potion = 0
        local item it
        
        if element1 == ALCHEMISTS_STONE_FIRE then
            set potion = potion + 1
        elseif element1 == ALCHEMISTS_STONE_EARTH then
           set potion = potion + 2
        elseif element1 == ALCHEMISTS_STONE_WATER then
            set potion = potion + 4
        endif
        if element2 == ALCHEMISTS_STONE_FIRE then
            set potion = potion + 1
        elseif element2 == ALCHEMISTS_STONE_EARTH then
           set potion = potion + 2
        elseif element2 == ALCHEMISTS_STONE_WATER then
            set potion = potion + 4
        endif
        
        set it = CreateItem( Alchemists_Stone_Potions[potion], GetUnitX(caster), GetUnitY(caster) )
        call UnitAddItem(caster, it )
        call BlzSetItemIntegerFieldBJ( it, ITEM_IF_NUMBER_OF_CHARGES, ALCHEMISTS_STONE_BONUS_CHARGES )
        call UnitRemoveItem(caster, it)
        call UnitAddItem(caster, it)
    
        set caster = null
        set it = null
    endfunction

    function Trig_Alchemists_Stone_Actions takes nothing returns nothing
        call forge( GetManipulatingUnit(), GetManipulatedItem(), ALCHEMISTS_STONE_FIRE, ALCHEMISTS_STONE_EARTH, ALCHEMISTS_STONE_WATER, false )
    endfunction
    
    private function Add takes nothing returns nothing
        call SpellPotionUnit(GetManipulatingUnit(), ALCHEMISTS_STONE_BONUS_POTION_SPELL_POWER)
    endfunction
    
    private function Remove takes nothing returns nothing
        call SpellPotionUnit(GetManipulatingUnit(), -ALCHEMISTS_STONE_BONUS_POTION_SPELL_POWER)
    endfunction
    
    private function BeforeForge_Conditions takes nothing returns boolean
        local integer forgetItemId = GetItemTypeId(Event_BeforeForge_ForgedItem)
        return forgetItemId == ID_ALCHEMISTS_STONE_ITEM and IsHeroHasItem(Event_BeforeForge_Hero, forgetItemId)
    endfunction
    
    private function Forge takes unit caster, item it returns nothing
        local integer id = GetHandleId(it)
        //local integer count = LoadInteger( udg_hash, id, StringHash( "alhst" ) )
        local integer element1 = LoadInteger( udg_hash, id, StringHash( "alhst1" ) )
        local integer element2 = LoadInteger( udg_hash, id, StringHash( "alhst2" ) )
    
        if element1 != 0 and element2 != 0 then
            //call RemoveItem(it)
            call stazisst( caster, it)
            call GetItem(caster,  element1, element2)
        endif
        
        set caster = null
        set it = null
    endfunction
    
    private function ChangeTooltip takes unit hero, item it, integer newItem returns nothing
        local string newDiscription = ""
        
        if newItem == ALCHEMISTS_STONE_FIRE then
            set newDiscription = "Fire"
        elseif newItem == ALCHEMISTS_STONE_EARTH then
            set newDiscription = "Earth"
        elseif newItem == ALCHEMISTS_STONE_WATER then
            set newDiscription = "Water"
        endif
        
        call BlzSetItemIconPath( it, words( hero, BlzGetItemDescription(it), "Current: ", ")|r", newDiscription ) )
        
        set hero = null
        set it = null
    endfunction
    
    private function BeforeForge takes nothing returns nothing
        local integer id = GetHandleId(Event_BeforeForge_ForgedItem)
        local integer count = LoadInteger( udg_hash, id, StringHash( "alhst" ) ) + 1
        
        if LoadInteger( udg_hash, id, StringHash( "alhst1" ) ) == 0 then
            call SaveInteger( udg_hash, id, StringHash( "alhst1" ), Event_BeforeForge_NewItem )
        else
            call SaveInteger( udg_hash, id, StringHash( "alhst2" ), Event_BeforeForge_NewItem )
        endif
        call SaveInteger( udg_hash, id, StringHash( "alhst" ), count )
        call ChangeTooltip( Event_BeforeForge_Hero, Event_BeforeForge_ForgedItem, Event_BeforeForge_NewItem )
        
        call Forge(Event_BeforeForge_Hero, Event_BeforeForge_ForgedItem)
    endfunction
    
    private function AfterForge_Conditions takes nothing returns boolean
        return Event_AfterForge_ForgedItem == ID_ALCHEMISTS_STONE_ITEM and IsHeroHasItem(Event_AfterForge_Hero, Event_AfterForge_ForgedItem)
    endfunction
    
    private function AfterForge takes nothing returns nothing
        call forge( Event_AfterForge_Hero, Event_AfterForge_ForgedItem_Item, ALCHEMISTS_STONE_FIRE, ALCHEMISTS_STONE_EARTH, ALCHEMISTS_STONE_WATER, false )
    endfunction
    
    //===========================================================================
    private function init takes nothing returns nothing
        local trigger trig
    
        set trig = CreateTrigger()
        call TriggerRegisterAnyUnitEventBJ( trig, EVENT_PLAYER_UNIT_USE_ITEM )
        call TriggerAddCondition( trig, Condition( function Conditions ) )
        call TriggerAddAction( trig, function Trig_Alchemists_Stone_Actions )
        
        set trig = CreateTrigger(  )
        call TriggerRegisterAnyUnitEventBJ( trig, EVENT_PLAYER_UNIT_PICKUP_ITEM )
        call TriggerAddCondition( trig, Condition( function Conditions ) )
        call TriggerAddAction( trig, function Add )
        
        set trig = CreateTrigger(  )
        call TriggerRegisterAnyUnitEventBJ( trig, EVENT_PLAYER_UNIT_DROP_ITEM )
        call TriggerAddCondition( trig, Condition( function Conditions ) )
        call TriggerAddAction( trig, function Remove )
        
        call CreateEventTrigger( "Event_BeforeForge_Real", function BeforeForge, function BeforeForge_Conditions )
        call CreateEventTrigger( "Event_AfterForge_Real", function AfterForge, function AfterForge_Conditions )

        call SetPotions()
        set trig = null
    endfunction

endscope