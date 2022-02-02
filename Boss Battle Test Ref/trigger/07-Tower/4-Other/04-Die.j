function Trig_Die_Conditions takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == 'I00Z'
endfunction

function Trig_Die_Actions takes nothing returns nothing
    local integer rand = GetRandomInt(1, 100 )
    
    if rand <= 33 then
        call SetPlayerState( GetOwningPlayer( GetManipulatingUnit() ), PLAYER_STATE_RESOURCE_GOLD, GetPlayerState( GetOwningPlayer( GetManipulatingUnit() ), PLAYER_STATE_RESOURCE_GOLD ) + 150 )
        if GetUnitState( GetManipulatingUnit(), UNIT_STATE_LIFE ) > 0.405 and not( IsUnitLoaded( GetManipulatingUnit() ) ) then
            call DestroyEffect(AddSpecialEffect( "UI\\Feedback\\GoldCredit\\GoldCredit.mdl", GetUnitX( GetManipulatingUnit() ), GetUnitY( GetManipulatingUnit() ) ))
            call textst( "|c00FFFF00 +150", GetManipulatingUnit(), 64, GetRandomReal(45, 135), 10, 1 )
        endif
        call textst( "|c00757575 Congratulations", gg_unit_h00G_0063, 64, 90, 8, 0.5 )
    else
        call textst( "|c00757575 Try again", gg_unit_h00G_0063, 64, 90, 8, 0.5 )
    endif
endfunction

//===========================================================================
function InitTrig_Die takes nothing returns nothing
    set gg_trg_Die = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Die, EVENT_PLAYER_UNIT_PICKUP_ITEM ) 
    call TriggerAddCondition( gg_trg_Die, Condition( function Trig_Die_Conditions ) )
    call TriggerAddAction( gg_trg_Die, function Trig_Die_Actions )
endfunction