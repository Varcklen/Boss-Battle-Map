function Trig_Refresher_Conditions takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == 'I0GC'
endfunction

function Trig_Refresher_Actions takes nothing returns nothing
    local integer i = GetPlayerId( GetOwningPlayer( GetManipulatingUnit() ) ) + 1
    local integer k = LoadInteger( udg_hash, GetHandleId(GetManipulatedItem()), StringHash( "refr" )) + 1

    call SaveInteger( udg_hash, GetHandleId(GetManipulatedItem()), StringHash( "refr" ), k )
    call BlzSetUnitMaxHP( GetManipulatingUnit(), BlzGetUnitMaxHP(GetManipulatingUnit()) + 10 )
    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\Polymorph\\PolyMorphDoneGround.mdl", GetUnitX( GetManipulatingUnit() ), GetUnitY( GetManipulatingUnit() ) ) )
    if udg_item[( 3 * i ) - 2] != null or udg_item[( 3 * i ) - 1] != null or udg_item[3 * i] != null then
        call ItemsRefresh(i)
    endif
    
    if k == 10 then
        call stazisst( GetManipulatingUnit(), GetManipulatedItem() )
    elseif k == 9 then
        call BlzSetItemIconPath( GetManipulatedItem(), words( GetManipulatingUnit(), BlzGetItemDescription(GetManipulatedItem()), "|cffffffff", "|r", I2S(10-k) + " charge" ) )
    else
        call BlzSetItemIconPath( GetManipulatedItem(), words( GetManipulatingUnit(), BlzGetItemDescription(GetManipulatedItem()), "|cffffffff", "|r", I2S(10-k) + " charges" ) )
    endif
endfunction

//===========================================================================
function InitTrig_Refresher takes nothing returns nothing
    set gg_trg_Refresher = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Refresher, EVENT_PLAYER_UNIT_USE_ITEM )
    call TriggerAddCondition( gg_trg_Refresher, Condition( function Trig_Refresher_Conditions ) )
    call TriggerAddAction( gg_trg_Refresher, function Trig_Refresher_Actions )
endfunction

