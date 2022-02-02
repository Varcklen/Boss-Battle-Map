function Trig_DarkBook_Conditions takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == 'I00T'
endfunction

function Trig_DarkBook_Actions takes nothing returns nothing
    call SetHeroLevel( GetManipulatingUnit(), GetHeroLevel(GetManipulatingUnit()) + 3, false )
    call DestroyEffect( AddSpecialEffectTarget( "war3mapImported\\BlackChakraExplosion.mdx", GetManipulatingUnit(), "origin") )
    call statst( GetManipulatingUnit(), -12, -12, -12, 0, true )
    call stazisst( GetManipulatingUnit(), GetManipulatedItem() )
endfunction

//===========================================================================
function InitTrig_DarkBook takes nothing returns nothing
    set gg_trg_DarkBook = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_DarkBook, EVENT_PLAYER_UNIT_USE_ITEM )
    call TriggerAddCondition( gg_trg_DarkBook, Condition( function Trig_DarkBook_Conditions ) )
    call TriggerAddAction( gg_trg_DarkBook, function Trig_DarkBook_Actions )
endfunction

