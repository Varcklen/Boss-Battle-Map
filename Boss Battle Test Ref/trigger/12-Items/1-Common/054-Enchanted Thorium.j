scope EnchantedThorium initializer Triggs
    private function ItemAdd takes nothing returns nothing
        if GetItemTypeId(GetManipulatedItem()) == 'I0EM' then
            call SetRaritySpawn( udg_RarityChance[3]+4, udg_RarityChance[2]+4 )
        endif
    endfunction
    
    private function ItemRemove takes nothing returns nothing
        if GetItemTypeId(GetManipulatedItem()) == 'I0EM' then
            call SetRaritySpawn( udg_RarityChance[3]-4, udg_RarityChance[2]-4 )
        endif
    endfunction

    private function Triggs takes nothing returns nothing
        local trigger trig = CreateTrigger()
        call TriggerRegisterAnyUnitEventBJ( trig, EVENT_PLAYER_UNIT_PICKUP_ITEM )
        call TriggerAddAction( trig, function ItemAdd)
        
        set trig = CreateTrigger()
        call TriggerRegisterAnyUnitEventBJ( trig, EVENT_PLAYER_UNIT_DROP_ITEM )
        call TriggerAddAction( trig, function ItemRemove)
        set trig = null
    endfunction
endscope