function Trig_PotionStuff_Conditions takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == 'I05Q'
endfunction

function Trig_PotionStuff_Actions takes nothing returns nothing
    local integer cyclA = 1

    call stazisst( GetManipulatingUnit(), GetManipulatedItem() )
    loop
        exitwhen cyclA > 6
        if UnitInventoryCount(GetManipulatingUnit()) < 6 then
            set bj_lastCreatedItem = CreateItem( udg_Database_Item_Potion[GetRandomInt(1, udg_Database_NumberItems[9])], GetUnitX( GetManipulatingUnit() ), GetUnitY(GetManipulatingUnit()))
            call UnitAddItem(GetManipulatingUnit(), bj_lastCreatedItem )
        endif
        set cyclA = cyclA + 1
    endloop

    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Human\\Polymorph\\PolyMorphTarget.mdl", GetManipulatingUnit(), "origin" ) )
endfunction

//===========================================================================
function InitTrig_PotionStuff takes nothing returns nothing
    set gg_trg_PotionStuff = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_PotionStuff, EVENT_PLAYER_UNIT_USE_ITEM )
    call TriggerAddCondition( gg_trg_PotionStuff, Condition( function Trig_PotionStuff_Conditions ) )
    call TriggerAddAction( gg_trg_PotionStuff, function Trig_PotionStuff_Actions )
endfunction

