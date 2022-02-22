function Trig_Transformotron_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A18N' and GetItemTypeId(GetSpellTargetItem()) != 'I087' and GetPlayerState(GetOwningPlayer( GetSpellAbilityUnit() ), PLAYER_STATE_RESOURCE_GOLD) >= 100 and GetItemType(GetSpellTargetItem()) != ITEM_TYPE_POWERUP and GetItemType(GetSpellTargetItem()) != ITEM_TYPE_PURCHASABLE and GetItemType(GetSpellTargetItem()) != ITEM_TYPE_MISCELLANEOUS
endfunction

function Trig_Transformotron_Actions takes nothing returns nothing
    local integer h = eyest( GetSpellAbilityUnit() )
    local integer i = 0
    local integer cyclA = 0
    local string rarity = null

    loop
        exitwhen cyclA > 5
        if GetSpellTargetItem() == UnitItemInSlot( GetSpellAbilityUnit(), cyclA ) and GetItemTypeId(GetSpellTargetItem()) != 'I087' and GetItemType(GetSpellTargetItem()) != ITEM_TYPE_POWERUP then
            if GetItemType(GetSpellTargetItem()) == ITEM_TYPE_ARTIFACT then
                set i = 1
            elseif GetItemType(GetSpellTargetItem()) == ITEM_TYPE_CAMPAIGN then
                set i = 2
            elseif GetItemType(GetSpellTargetItem()) == ITEM_TYPE_PERMANENT then
                set i = 3
            endif
            if i != 0 then
                call SetPlayerState( GetOwningPlayer( GetSpellAbilityUnit() ), PLAYER_STATE_RESOURCE_GOLD, GetPlayerState( GetOwningPlayer( GetSpellAbilityUnit() ), PLAYER_STATE_RESOURCE_GOLD ) - 100 )
                call DestroyEffect(AddSpecialEffect( "Abilities\\Spells\\Human\\Polymorph\\PolyMorphDoneGround.mdl", GetUnitX( GetSpellAbilityUnit() ), GetUnitY( GetSpellAbilityUnit() ) ) )
                if i == 1 then
                    set rarity = "legendary"
                elseif i == 2 then
                    set rarity = "rare"
                elseif i == 3 then
                    set rarity = "common"
                endif
                call Inventory_ReplaceItemByNew(GetSpellAbilityUnit(), GetSpellTargetItem(), ItemRandomizerItemId( GetSpellAbilityUnit(), rarity ))
            endif
            set cyclA = 5
        endif
        set cyclA = cyclA + 1
    endloop
endfunction

//===========================================================================
function InitTrig_Transformotron takes nothing returns nothing
    set gg_trg_Transformotron = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Transformotron, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Transformotron, Condition( function Trig_Transformotron_Conditions ) )
    call TriggerAddAction( gg_trg_Transformotron, function Trig_Transformotron_Actions )
endfunction

