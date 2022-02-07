function Trig_JagotCast_Conditions takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == JAGOT_CLOCK_ID
endfunction

function Trig_JagotCast_Actions takes nothing returns nothing
    call UnitReduceCooldown(GetManipulatingUnit(), JAGOT_COOLDOWN_REDUCTION)
    call DestroyEffect( AddSpecialEffect( JAGOT_ANIMATION, GetUnitX( GetManipulatingUnit() ), GetUnitY( GetManipulatingUnit() ) ) )
endfunction

//===========================================================================
function InitTrig_JagotCast takes nothing returns nothing
    set gg_trg_JagotCast = CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ( gg_trg_JagotCast, EVENT_PLAYER_UNIT_PICKUP_ITEM )
    call TriggerAddCondition( gg_trg_JagotCast, Condition( function Trig_JagotCast_Conditions ) )
    call TriggerAddAction( gg_trg_JagotCast, function Trig_JagotCast_Actions )
endfunction

