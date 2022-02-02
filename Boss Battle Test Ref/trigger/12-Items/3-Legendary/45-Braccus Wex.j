scope BraccusWex initializer Triggs
    globals
        private constant integer BRACCUS_WEX_SPELL_POWER_BONUS = 50
    endglobals

    private function Conditions takes nothing returns boolean
        return GetItemTypeId(GetManipulatedItem()) == 'I071'
    endfunction

    private function PickUp takes nothing returns nothing
        call spdst( GetManipulatingUnit(), BRACCUS_WEX_SPELL_POWER_BONUS )
    endfunction
    
    private function Drop takes nothing returns nothing
        call spdst( GetManipulatingUnit(), -BRACCUS_WEX_SPELL_POWER_BONUS )
    endfunction

    private function Triggs takes nothing returns nothing
        local trigger trig = CreateTrigger()
        call TriggerRegisterAnyUnitEventBJ( trig, EVENT_PLAYER_UNIT_PICKUP_ITEM ) 
        call TriggerAddCondition( trig, Condition( function Conditions ) )
        call TriggerAddAction( trig, function PickUp)
        
        set trig = CreateTrigger()
        call TriggerRegisterAnyUnitEventBJ( trig, EVENT_PLAYER_UNIT_DROP_ITEM )
        call TriggerAddCondition( trig, Condition( function Conditions ) )
        call TriggerAddAction( trig, function Drop)
        
        set trig = null
    endfunction
endscope
