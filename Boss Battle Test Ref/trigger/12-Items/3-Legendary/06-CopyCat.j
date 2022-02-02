function Trig_CopyCat_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A059' and GetItemTypeId(GetSpellTargetItem()) != 'I030' and GetItemTypeId(GetSpellTargetItem()) != 'I0DI' and GetItemType(GetSpellTargetItem()) != ITEM_TYPE_POWERUP and GetItemType(GetSpellTargetItem()) != ITEM_TYPE_PURCHASABLE and GetItemType(GetSpellTargetItem()) != ITEM_TYPE_MISCELLANEOUS
endfunction

function Trig_CopyCat_Actions takes nothing returns nothing
    local unit u = GetSpellAbilityUnit()
    local integer h = eyest( u )
    local item it = GetItemOfTypeFromUnitBJ( u, 'I0DI')
    local integer itd = GetItemTypeId(GetSpellTargetItem())

    call DestroyEffect(AddSpecialEffect( "Abilities\\Spells\\Human\\Polymorph\\PolyMorphDoneGround.mdl", GetUnitX( u ), GetUnitY( u ) ) )
    call RemoveItem ( it )
    call UnitAddItem( u, CreateItem(itd, GetUnitX(u), GetUnitY(u) ) )

    set it = null
    set u = null
endfunction

//===========================================================================
function InitTrig_CopyCat takes nothing returns nothing
    set gg_trg_CopyCat = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_CopyCat, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_CopyCat, Condition( function Trig_CopyCat_Conditions ) )
    call TriggerAddAction( gg_trg_CopyCat, function Trig_CopyCat_Actions )
endfunction

