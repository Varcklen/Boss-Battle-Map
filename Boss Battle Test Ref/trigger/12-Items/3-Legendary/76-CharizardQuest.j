scope CharizardQuest initializer init

    globals
        private constant integer ID_QUEST_ITEM = 'I09A'
        private constant integer ID_REWARD_ITEM = 'I03I'
        
        private constant integer ITEMS_NEEDED = 12
        private constant integer ITEMS_NEEDED_ARRAYS = ITEMS_NEEDED + 1
        
        private string array RarityColors[3]
        private itemtype array checkedItemType[3]
        private boolean array isConditionActive[ITEMS_NEEDED_ARRAYS]
    endglobals

    private function ItemSplit_Conditions takes nothing returns boolean
        return IsHeroHasItem( Event_ItemSplit_Hero, ID_QUEST_ITEM ) 
    endfunction
    
    private function ItemSplit takes nothing returns nothing
        local unit caster = Event_ItemSplit_Hero
        local item splittedItem = Event_ItemSplit_Item
        local itemtype itemType = GetItemType(splittedItem)
        local integer j
        local integer i
        
        set i = 1
        loop
            exitwhen i > udg_DB_AllSet
            if isConditionActive[i] == false then
                if SetCount_CheckItemSet( splittedItem, i ) then
                    set isConditionActive[i] = true
                    call ChangeToolCurrentItem( caster, ID_QUEST_ITEM, udg_DB_Set_Color[i], "|cff000000" )  
                endif
            endif
            set i = i + 1
        endloop

        set i = 0
        loop
            exitwhen i > 2
            if isConditionActive[10 + i] == false and itemType == checkedItemType[i] then
                set isConditionActive[10 + i] = true
                call ChangeToolCurrentItem( caster, ID_QUEST_ITEM, RarityColors[i], "|cff000000" )
            endif
            set i = i + 1
        endloop

        set i = 1
        set j = 0
        loop
            exitwhen i > ITEMS_NEEDED
            if isConditionActive[i] == true then
                set j = j + 1
            endif
            set i = i + 1
        endloop
        
        call Quest_QuestCondition( caster, ID_QUEST_ITEM, ID_REWARD_ITEM, j, ITEMS_NEEDED )
        
        set caster = null
        set splittedItem = null
        set itemType = null
    endfunction

    //===========================================================================
    private function init takes nothing returns nothing
        call CreateEventTrigger( "Event_ItemSplit_Real", function ItemSplit, function ItemSplit_Conditions )
        
        set RarityColors[0] = "|cffbababc"
        set RarityColors[1] = "|cff4169e1"
        set RarityColors[2] = "|cffe96a1c"
        
        set checkedItemType[0] = ITEM_TYPE_PERMANENT
        set checkedItemType[1] = ITEM_TYPE_CAMPAIGN
        set checkedItemType[2] = ITEM_TYPE_ARTIFACT
    endfunction
endscope