scope GoldenLamp initializer Triggs

    private function GoldenLamp_Conditions takes nothing returns boolean
        return inv(GetSpellAbilityUnit(), 'I01J') > 0 and combat( GetSpellAbilityUnit(), false, 0 ) and GetSpellAbilityId() != 'A0VB' and not( udg_fightmod[3] )
    endfunction

    private function GoldenLamp_Actions takes nothing returns nothing
        local integer id = GetHandleId( GetSpellAbilityUnit() )
        local integer s = LoadInteger( udg_hash, id, StringHash( "gldl" ) ) 
        
        if s <= 10000 then
            set s = s + 10
            call SaveInteger( udg_hash, id, StringHash( "gldl" ), s )
            call ChangeToolItem( GetSpellAbilityUnit(), 'I01J', "|cffbe81f7", "|r", I2S(s) )
        endif
    endfunction
    
    private function AddItem_Conditions takes nothing returns boolean
        return GetItemTypeId(GetManipulatedItem()) == 'I01J'
    endfunction
    
    private function AddItem takes nothing returns nothing
        local integer id = GetHandleId( GetManipulatingUnit() )
        local integer s = LoadInteger( udg_hash, id, StringHash( "gldl" ) )
        
        call BlzSetItemExtendedTooltip( GetManipulatedItem(), words( GetManipulatingUnit(), BlzGetItemExtendedTooltip(GetManipulatedItem()), "|cffbe81f7", "|r", I2S(s) ) )
    endfunction

    private function Triggs takes nothing returns nothing
        local trigger trig = CreateTrigger()
        call TriggerRegisterAnyUnitEventBJ( trig, EVENT_PLAYER_UNIT_SPELL_EFFECT )
        call TriggerAddCondition( trig, Condition( function GoldenLamp_Conditions ) )
        call TriggerAddAction( trig, function GoldenLamp_Actions )
        
        set trig = CreateTrigger()
        call TriggerRegisterAnyUnitEventBJ( trig, EVENT_PLAYER_UNIT_PICKUP_ITEM )
        call TriggerAddCondition( trig, Condition( function AddItem_Conditions ) )
        call TriggerAddAction( trig, function AddItem )
        
        set trig = null
    endfunction

endscope

