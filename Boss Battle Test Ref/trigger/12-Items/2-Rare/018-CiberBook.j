function Trig_CiberBook_Conditions takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == 'I08N'
endfunction

function Trig_CiberBook_Actions takes nothing returns nothing
    local unit u = udg_hero[GetPlayerId(GetOwningPlayer( GetManipulatingUnit() ) ) + 1]

    call statst( GetManipulatingUnit(), 1, 1, 1, 0, true )
    call spectimeunit( u, "Abilities\\Spells\\Other\\Silence\\SilenceAreaBirth.mdl", "origin", 0.6 )
    if SetCount_GetPieces(u, SET_MECH) > 0 then
        call SetHeroLevel( GetManipulatingUnit(), GetHeroLevel(GetManipulatingUnit()) + SetCount_GetPieces(u, SET_MECH), true )
    endif
    call stazisst( GetManipulatingUnit(), GetManipulatedItem() )
    
    set u = null
endfunction

//===========================================================================
function InitTrig_CiberBook takes nothing returns nothing
    set gg_trg_CiberBook = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_CiberBook, EVENT_PLAYER_UNIT_USE_ITEM )
    call TriggerAddCondition( gg_trg_CiberBook, Condition( function Trig_CiberBook_Conditions ) )
    call TriggerAddAction( gg_trg_CiberBook, function Trig_CiberBook_Actions )
endfunction

