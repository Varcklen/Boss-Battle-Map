function Trig_Midas_Ring_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0UG' and GetItemTypeId(GetSpellTargetItem()) != 'I0EE' and GetItemType(GetSpellTargetItem()) != ITEM_TYPE_POWERUP and GetItemType(GetSpellTargetItem()) != ITEM_TYPE_PURCHASABLE and GetItemType(GetSpellTargetItem()) != ITEM_TYPE_MISCELLANEOUS
endfunction

function Trig_Midas_Ring_Actions takes nothing returns nothing
    local unit u = GetSpellAbilityUnit()
    local item it = GetSpellTargetItem()
    local integer h = eyest( u )
    local integer cyclA = 0

    loop
        exitwhen cyclA > 5
        if it == UnitItemInSlot( u, cyclA ) then
            call AddSpecialEffectTarget( "Abilities\\Spells\\Other\\Doom\\DoomDeath.mdl", u, "origin")
            if GetItemType(it) == ITEM_TYPE_ARTIFACT then
                call moneyst( u, 90 )
            elseif GetItemType(it) == ITEM_TYPE_CAMPAIGN then
                call moneyst( u, 60 )
            elseif GetItemType(it) == ITEM_TYPE_PERMANENT then
                call moneyst( u, 30 )
            endif
            call RemoveItem( it )
            set cyclA = 5
        endif
        set cyclA = cyclA + 1
    endloop
    
    set u = null
    set it = null
endfunction

//===========================================================================
function InitTrig_Midas_Ring takes nothing returns nothing
    set gg_trg_Midas_Ring = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Midas_Ring, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Midas_Ring, Condition( function Trig_Midas_Ring_Conditions ) )
    call TriggerAddAction( gg_trg_Midas_Ring, function Trig_Midas_Ring_Actions )
endfunction

