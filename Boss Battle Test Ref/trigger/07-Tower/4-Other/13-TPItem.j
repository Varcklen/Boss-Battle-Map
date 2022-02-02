function Trig_TPItem_Conditions takes nothing returns boolean
    return RectContainsUnit(gg_rct_Vision5, GetManipulatingUnit()) and LoadBoolean( udg_hash, GetHandleId(GetManipulatedItem() ), StringHash( "sreg" ) )
endfunction

function Trig_TPItem_Actions takes nothing returns nothing
    local item it
    
    call SetUnitPosition(GetManipulatingUnit(), GetRectCenterX(gg_rct_HeroTp), GetRectCenterY(gg_rct_HeroTp))
    call SetUnitFacing(GetManipulatingUnit(), 270)
    call PanCameraToTimedForPlayer( GetOwningPlayer(GetManipulatingUnit()), GetRectCenterX(gg_rct_HeroTp), GetRectCenterY(gg_rct_HeroTp), 0.25 )
    call DestroyEffect( AddSpecialEffectTarget("Void Teleport Caster.mdx", GetManipulatingUnit(), "origin" ) )
    
    set it = CreateItem( GetItemTypeId(GetManipulatedItem()), GetItemX(GetManipulatedItem()), GetItemY(GetManipulatedItem()))
    call SaveBoolean( udg_hash, GetHandleId( it ), StringHash( "sreg" ), true )
    
    set it = null
endfunction

//===========================================================================
function InitTrig_TPItem takes nothing returns nothing
    set gg_trg_TPItem = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_TPItem, EVENT_PLAYER_UNIT_PICKUP_ITEM )
    call TriggerAddCondition( gg_trg_TPItem, Condition( function Trig_TPItem_Conditions ) )
    call TriggerAddAction( gg_trg_TPItem, function Trig_TPItem_Actions )
endfunction

