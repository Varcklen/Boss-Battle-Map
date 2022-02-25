function Trig_Parcel_Conditions takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == 'I063'
endfunction

function Trig_Parcel_Actions takes nothing returns nothing
    local integer i = 0
    local integer cyclA = 1

    call stazisst( GetManipulatingUnit(), GetManipulatedItem() )
    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\Polymorph\\PolyMorphDoneGround.mdl", GetUnitX( GetManipulatingUnit() ), GetUnitY( GetManipulatingUnit() ) ) )
    loop
        exitwhen cyclA > 6
        if GetItemType(UnitItemInSlot(GetManipulatingUnit(), cyclA-1)) == ITEM_TYPE_ARTIFACT then
            set i = i + 1
        endif
        set cyclA = cyclA + 1
    endloop
    if i == 0 then
        call ItemRandomizer( GetManipulatingUnit(), "legendary" )
    else
        call ItemRandomizer( GetManipulatingUnit(), "common" )
    endif
endfunction

//===========================================================================
function InitTrig_Parcel takes nothing returns nothing
    set gg_trg_Parcel = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Parcel, EVENT_PLAYER_UNIT_USE_ITEM )
    call TriggerAddCondition( gg_trg_Parcel, Condition( function Trig_Parcel_Conditions ) )
    call TriggerAddAction( gg_trg_Parcel, function Trig_Parcel_Actions )
endfunction

